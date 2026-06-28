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

# Build a FAT EFI System Partition image holding /EFI/BOOT/<name>. UEFI
# firmware mounts the ESP as FAT, so the appended partition (and El Torito
# EFI image) MUST be a filesystem image, not the bare .efi binary — otherwise
# the stick never appears in the UEFI boot menu.
echo "Creating FAT EFI System Partition image (efiboot.img)..."
EFI_IMG="$ISO_DIR/boot/grub/efiboot.img"
efi_bin="$ISO_DIR/EFI/BOOT/$EFI_BOOT_NAME"
[ -s "$efi_bin" ] || { echo "Error: GRUB EFI binary missing ($efi_bin)"; exit 1; }
# size in whole MiB: binary + 4 MiB slack, min 16 MiB so mkfs.vfat picks FAT16
# (a few-MiB image falls below FAT16's minimum cluster count -> "too small").
efi_mb=$(( $(stat -c%s "$efi_bin") / 1048576 + 4 ))
[ "$efi_mb" -lt 16 ] && efi_mb=16
rm -f "$EFI_IMG"
dd if=/dev/zero of="$EFI_IMG" bs=1M count="$efi_mb" status=none
mkfs.vfat -F 16 -n NEXEFI "$EFI_IMG" >/dev/null
mmd   -i "$EFI_IMG" ::/EFI ::/EFI/BOOT
mcopy -i "$EFI_IMG" "$efi_bin" "::/EFI/BOOT/$EFI_BOOT_NAME"

if [ "$HAS_BIOS" -eq 1 ]; then
    echo "Installing GRUB (Legacy BIOS: i386-pc)..."
    # i386-pc core.img must fit the El Torito embed limit (~0x78000). By
    # default grub-mkstandalone packs *every* module into the memdisk, which
    # overflows it; restrict to the set actually needed to boot the ISO.
    grub-mkstandalone \
        --format=i386-pc \
        --output="$ISO_DIR/boot/grub/core.img" \
        --install-modules="linux linux16 normal configfile iso9660 biosdisk search search_label search_fs_uuid search_fs_file loopback part_gpt part_msdos fat ext2 gzio xzio gfxterm gfxmenu gfxterm_background all_video video font png jpeg chain halt reboot boot multiboot test true echo sleep ls cat help memdisk tar" \
        --modules="linux normal iso9660 biosdisk search configfile" \
        --locales="" \
        --fonts="" \
        "boot/grub/grub.cfg=theme/grub.cfg"

    cat /usr/lib/grub/i386-pc/cdboot.img "$ISO_DIR/boot/grub/core.img" \
        > "$ISO_DIR/boot/grub/bios.img"
else
    echo "Skipping Legacy BIOS image (arm64 is UEFI-only)"
fi

echo "Boot setup complete"
