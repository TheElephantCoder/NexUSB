#!/bin/bash
# Setup GRUB boot environment

ISO_DIR=$1
WORK_DIR=${2:-build/work}

echo "Creating ISO directory structure..."
mkdir -p "$ISO_DIR"/{boot/grub,EFI/BOOT,live}

echo "Copying kernel and initrd..."
cp "$WORK_DIR"/boot/vmlinuz-* "$ISO_DIR/live/vmlinuz"
cp "$WORK_DIR"/boot/initrd.img-* "$ISO_DIR/live/initrd"

echo "Creating squashfs..."
mksquashfs "$WORK_DIR" "$ISO_DIR/live/filesystem.squashfs" \
    -comp xz -e boot

echo "Installing GRUB..."
grub-mkstandalone \
    --format=x86_64-efi \
    --output="$ISO_DIR/EFI/BOOT/BOOTX64.EFI" \
    --locales="" \
    --fonts="" \
    "boot/grub/grub.cfg=theme/grub.cfg"

grub-mkstandalone \
    --format=i386-pc \
    --output="$ISO_DIR/boot/grub/core.img" \
    --locales="" \
    --fonts="" \
    "boot/grub/grub.cfg=theme/grub.cfg"

cat /usr/lib/grub/i386-pc/cdboot.img "$ISO_DIR/boot/grub/core.img" \
    > "$ISO_DIR/boot/grub/bios.img"

echo "Boot setup complete"
