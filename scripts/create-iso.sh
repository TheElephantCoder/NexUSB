#!/bin/bash
# Create bootable ISO

ISO_DIR=$1
OUTPUT_ISO=$2

echo "Creating ISO image..."
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
    -e EFI/BOOT/BOOTX64.EFI \
    -no-emul-boot \
    -append_partition 2 0xef "$ISO_DIR/EFI/BOOT/BOOTX64.EFI" \
    -output "$OUTPUT_ISO" \
    -graft-points \
    "$ISO_DIR" \
    /boot/grub/bios.img=boot/grub/bios.img \
    /EFI/BOOT/BOOTX64.EFI=EFI/BOOT/BOOTX64.EFI

chmod 644 "$OUTPUT_ISO"
echo "ISO created: $OUTPUT_ISO"
