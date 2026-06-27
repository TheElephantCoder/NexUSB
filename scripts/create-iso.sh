#!/bin/bash
# Create bootable ISO

ISO_DIR=$1
OUTPUT_ISO=$2
source "$(dirname "$0")/arch-config.sh"

echo "Creating ISO image (arch: $NEXUSB_ARCH)..."

if [ "$HAS_BIOS" -eq 1 ]; then
    # amd64: hybrid BIOS (El Torito + isohybrid MBR) and UEFI boot.
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
        -e "EFI/BOOT/$EFI_BOOT_NAME" \
        -no-emul-boot \
        -append_partition 2 0xef "$ISO_DIR/EFI/BOOT/$EFI_BOOT_NAME" \
        -output "$OUTPUT_ISO" \
        -graft-points \
        "$ISO_DIR" \
        /boot/grub/bios.img=boot/grub/bios.img \
        "/EFI/BOOT/$EFI_BOOT_NAME=EFI/BOOT/$EFI_BOOT_NAME"
else
    # arm64: UEFI-only (no Legacy BIOS / El Torito BIOS image).
    xorriso -as mkisofs \
        -iso-level 3 \
        -full-iso9660-filenames \
        -volid "NexUSB" \
        -e "EFI/BOOT/$EFI_BOOT_NAME" \
        -no-emul-boot \
        -append_partition 2 0xef "$ISO_DIR/EFI/BOOT/$EFI_BOOT_NAME" \
        -output "$OUTPUT_ISO" \
        -graft-points \
        "$ISO_DIR" \
        "/EFI/BOOT/$EFI_BOOT_NAME=EFI/BOOT/$EFI_BOOT_NAME"
fi

chmod 644 "$OUTPUT_ISO"
echo "ISO created: $OUTPUT_ISO"
