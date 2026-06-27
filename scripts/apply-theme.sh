#!/bin/bash
# Apply custom theme to boot menu

ISO_DIR=$1

echo "Copying theme files..."
cp theme/grub.cfg "$ISO_DIR/boot/grub/"
mkdir -p "$ISO_DIR/boot/grub/themes"
cp -r theme/nex "$ISO_DIR/boot/grub/themes/"

echo "Theme applied successfully"
