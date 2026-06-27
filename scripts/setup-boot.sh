#!/bin/bash
# grub boot env

ISO_DIR=$1
WORK_DIR=${2:-build/work}
source "$(dirname "$0")/arch-config.sh"

echo "Creating ISO directory structure..."
mkdir -p "$ISO_DIR"/{boot/grub,EFI/BOOT,live}

echo "Copying kernel and initrd..."
cp "$WORK_DIR"/boot/vmlinuz-* "$ISO_DIR/live/vmlinuz"
cp "$WORK_DIR"/boot/initrd.img-* "$ISO_DIR/live/initrd"

echo "Creating squashfs..."
mksquashfs "$WORK_DIR" "$ISO_DIR/live/filesystem.squashfs" \
    -comp xz -e boot

echo "Installing GRUB (UEFI: $GRUB_EFI_FORMAT -> $EFI_BOOT_NAME)..."
grub-mkstandalone \
    --format="$GRUB_EFI_FORMAT" \
    --output="$ISO_DIR/EFI/BOOT/$EFI_BOOT_NAME" \
    --locales="" \
    --fonts="" \
    "boot/grub/grub.cfg=theme/grub.cfg"

if [ "$HAS_BIOS" -eq 1 ]; then
    echo "Installing GRUB (Legacy BIOS: i386-pc)..."
    grub-mkstandalone \
        --format=i386-pc \
        --output="$ISO_DIR/boot/grub/core.img" \
        --locales="" \
        --fonts="" \
        "boot/grub/grub.cfg=theme/grub.cfg"

    cat /usr/lib/grub/i386-pc/cdboot.img "$ISO_DIR/boot/grub/core.img" \
        > "$ISO_DIR/boot/grub/bios.img"
else
    echo "Skipping Legacy BIOS image (arm64 is UEFI-only)"
fi

echo "Boot setup complete"
