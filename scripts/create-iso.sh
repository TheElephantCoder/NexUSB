#!/bin/bash
# build the bootable iso

ISO_DIR=$1
OUTPUT_ISO=$2
source "$(dirname "$0")/arch-config.sh"

echo "Creating ISO image (arch: $NEXUSB_ARCH)..."

if [ "$HAS_BIOS" -eq 1 ]; then
    # amd64: hybrid bios (el torito + isohybrid mbr) + uefi.
    # passing $ISO_DIR as the single source tree puts its contents at the ISO
    # root, so the -eltorito-boot/-e paths resolve relative to that root.
    xorriso -as mkisofs \
        -iso-level 3 \
        -full-iso9660-filenames \
        -volid "NexUSB" \
        -eltorito-boot boot/grub/bios.img \
        -no-emul-boot \
        -boot-load-size 4 \
        -boot-info-table \
        --eltorito-catalog boot/grub/boot.cat \
        --grub2-boot-info \
        --grub2-mbr /usr/lib/grub/i386-pc/boot_hybrid.img \
        -eltorito-alt-boot \
        -e boot/grub/efiboot.img \
        -no-emul-boot \
        -append_partition 2 0xef "$ISO_DIR/boot/grub/efiboot.img" \
        -output "$OUTPUT_ISO" \
        "$ISO_DIR"
else
    # arm64: uefi-only, no bios el torito
    xorriso -as mkisofs \
        -iso-level 3 \
        -full-iso9660-filenames \
        -volid "NexUSB" \
        -e boot/grub/efiboot.img \
        -no-emul-boot \
        -append_partition 2 0xef "$ISO_DIR/boot/grub/efiboot.img" \
        -output "$OUTPUT_ISO" \
        "$ISO_DIR"
fi

chmod 644 "$OUTPUT_ISO"
echo "ISO created: $OUTPUT_ISO"
