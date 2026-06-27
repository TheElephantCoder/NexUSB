#!/bin/bash
# multi-partition usb image

OUTPUT_IMG=$1
SIZE_GB=${2:-32}

echo "Creating multi-partition USB image..."
echo "Size: ${SIZE_GB}GB"

# partition sizes
BOOT_SIZE=512M
NEX_SIZE=8G
WINDOWS_SIZE=8G
ISO_SIZE=$((SIZE_GB - 16))G
DATA_SIZE=remaining

# blank image
dd if=/dev/zero of="$OUTPUT_IMG" bs=1M count=$((SIZE_GB * 1024)) status=progress

# gpt
parted "$OUTPUT_IMG" mklabel gpt

# p1: efi boot (fat32)
parted "$OUTPUT_IMG" mkpart primary fat32 1MiB 513MiB
parted "$OUTPUT_IMG" set 1 boot on
parted "$OUTPUT_IMG" set 1 esp on

# p2: live system (ext4)
parted "$OUTPUT_IMG" mkpart primary ext4 513MiB 8705MiB

# p3: windows tools (ntfs)
parted "$OUTPUT_IMG" mkpart primary ntfs 8705MiB 16897MiB

# p4: iso collection
parted "$OUTPUT_IMG" mkpart primary fat32 16897MiB 100%

echo "Partition layout created"
parted "$OUTPUT_IMG" print

# loop device
LOOP_DEV=$(losetup -f --show "$OUTPUT_IMG")
if [ -z "$LOOP_DEV" ]; then
    echo "Error: Failed to create loop device"
    exit 1
fi
echo "Created loop device: $LOOP_DEV"

partprobe "$LOOP_DEV"

# wait for partition nodes before formatting
echo "Waiting for partition devices..."
for i in 1 2 3 4; do
    part="${LOOP_DEV}p${i}"
    timeout=10
    while [ ! -b "$part" ] && [ "$timeout" -gt 0 ]; do
        sleep 1
        timeout=$((timeout - 1))
    done
    if [ ! -b "$part" ]; then
        echo "Error: Partition $part did not appear in time"
        losetup -d "$LOOP_DEV"
        exit 1
    fi
done

# format
echo "Formatting partitions..."
mkfs.vfat -F32 -n "NEXBOOT" "${LOOP_DEV}p1"
mkfs.ext4 -L "NEXLIVE" "${LOOP_DEV}p2"
mkfs.ntfs -f -L "WINTOOLS" "${LOOP_DEV}p3"
mkfs.exfat -n "ISOS" "${LOOP_DEV}p4"

# mount + populate
mkdir -p /mnt/{boot,live,windows,isos}
mount "${LOOP_DEV}p1" /mnt/boot
mount "${LOOP_DEV}p2" /mnt/live
mount "${LOOP_DEV}p3" /mnt/windows
mount "${LOOP_DEV}p4" /mnt/isos

# copy live system
echo "Copying NexUSB system..."
cp -r build/iso/* /mnt/live/

# copy windows tools
echo "Copying Windows tools..."
cp -r build/windows-tools/* /mnt/windows/

# ventoy for multiboot
echo "Installing Ventoy for multiboot..."
cd /mnt/isos
mkdir -p ventoy
cat > ventoy/ventoy.json << 'EOF'
{
    "theme": {
        "file": "/ventoy/theme.txt",
        "gfxmode": "1920x1080",
        "display_mode": "GUI",
        "ventoy_left": "5%",
        "ventoy_top": "10%",
        "ventoy_color": "#0066cc"
    },
    "menu_alias": [
        {
            "image": "/ISOs/Linux/*.iso",
            "alias": "Linux Distributions"
        },
        {
            "image": "/ISOs/Security/*.iso",
            "alias": "Security & Penetration Testing"
        },
        {
            "image": "/ISOs/Rescue/*.iso",
            "alias": "System Rescue & Recovery"
        },
        {
            "image": "/ISOs/Antivirus/*.iso",
            "alias": "Antivirus Rescue Discs"
        }
    ]
}
EOF

mkdir -p ISOs/{Linux,Security,Rescue,Antivirus,Windows,Tools}

# readme
cat > README.txt << 'EOF'
NexUSB - ISO Collection

Place your ISO files in the appropriate subdirectories:
- Linux: Linux distributions
- Security: Penetration testing and security tools
- Rescue: System recovery and repair tools
- Antivirus: Antivirus rescue discs
- Windows: Windows installation media
- Tools: Specialized diagnostic tools

The system will automatically detect and boot from any ISO placed here.
EOF

# cleanup
cd /
umount /mnt/{boot,live,windows,isos}
losetup -d "$LOOP_DEV"

echo "Multi-partition image created: $OUTPUT_IMG"
echo ""
echo "Partition Layout:"
echo "  1. Boot (512MB) - EFI/GRUB bootloader"
echo "  2. NexUSB (8GB) - Live Linux environment"
echo "  3. Windows Tools (8GB) - Portable Windows applications"
echo "  4. ISOs (${ISO_SIZE}) - Multiboot ISO collection"
