#!/bin/bash
# build the bootable iso

ISO_DIR=$1
OUTPUT_ISO=$2
source "$(dirname "$0")/arch-config.sh"

echo "Creating ISO image (arch: $NEXUSB_ARCH)..."

# EFI System Partition type GUID (C12A7328-F81F-11D2-BA4B-00A0C93EC93B) in the
# byte order xorriso expects, and the ISO9660 partition type GUID. These make
# the appended FAT image a real GPT ESP that UEFI firmware enumerates on USB.
ESP_GUID="c12a7328f81f11d2ba4b00a0c93ec93b"
ISO_GUID="a2a0d0ebe5b9334487c068b6b72699c7"

if [ "$HAS_BIOS" -eq 1 ]; then
    # amd64: hybrid BIOS (grub i386-pc el torito + hybrid MBR) + UEFI (GPT ESP).
    # Follows the proven Ubuntu 22.04 grub2 recipe: the appended efiboot.img is
    # exposed as a GPT EFI System Partition and reused as the El Torito EFI image
    # via --interval:appended_partition_2.
    xorriso -as mkisofs \
        -r -J -joliet-long \
        -iso-level 3 \
        -full-iso9660-filenames \
        -volid "NexUSB" \
        -output "$OUTPUT_ISO" \
        --grub2-mbr /usr/lib/grub/i386-pc/boot_hybrid.img \
        -partition_offset 16 \
        --mbr-force-bootable \
        -append_partition 2 "$ESP_GUID" "$ISO_DIR/boot/grub/efiboot.img" \
        -appended_part_as_gpt \
        -iso_mbr_part_type "$ISO_GUID" \
        -c boot/grub/boot.cat \
        -b boot/grub/bios.img \
        -no-emul-boot \
        -boot-load-size 4 \
        -boot-info-table \
        --grub2-boot-info \
        -eltorito-alt-boot \
        -e '--interval:appended_partition_2:::' \
        -no-emul-boot \
        "$ISO_DIR"
else
    # arm64: UEFI-only. GPT ESP from the appended efiboot.img, no BIOS el torito.
    xorriso -as mkisofs \
        -r -J -joliet-long \
        -iso-level 3 \
        -full-iso9660-filenames \
        -volid "NexUSB" \
        -output "$OUTPUT_ISO" \
        -partition_offset 16 \
        -append_partition 2 "$ESP_GUID" "$ISO_DIR/boot/grub/efiboot.img" \
        -appended_part_as_gpt \
        -iso_mbr_part_type "$ISO_GUID" \
        -e '--interval:appended_partition_2:::' \
        -no-emul-boot \
        "$ISO_DIR"
fi

chmod 644 "$OUTPUT_ISO"
echo "ISO created: $OUTPUT_ISO"
