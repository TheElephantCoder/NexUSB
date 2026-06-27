#!/bin/bash
# Resolve per-architecture build settings from NEXUSB_ARCH.
#
# Source this from build scripts (it exports the vars below). Honors
# NEXUSB_ARCH = amd64 | arm64 (default amd64). x86_64/aarch64 are accepted as
# aliases.
#
# Exported:
#   NEXUSB_ARCH            normalized: amd64 | arm64
#   DEB_ARCH               debootstrap --arch value
#   UBUNTU_MIRROR          apt mirror (archive vs ports)
#   UBUNTU_SECURITY_MIRROR security mirror
#   GRUB_EFI_FORMAT        grub-mkstandalone --format (x86_64-efi | arm64-efi)
#   GRUB_EFI_PKG           grub EFI package name for the host build env
#   EFI_BOOT_NAME          removable-media EFI binary (BOOTX64.EFI | BOOTAA64.EFI)
#   HAS_BIOS               1 if Legacy BIOS boot applies (amd64 only), else 0

NEXUSB_ARCH="${NEXUSB_ARCH:-amd64}"

case "$NEXUSB_ARCH" in
    amd64|x86_64)
        NEXUSB_ARCH="amd64"
        DEB_ARCH="amd64"
        UBUNTU_MIRROR="http://archive.ubuntu.com/ubuntu"
        UBUNTU_SECURITY_MIRROR="http://security.ubuntu.com/ubuntu"
        GRUB_EFI_FORMAT="x86_64-efi"
        GRUB_EFI_PKG="grub-efi-amd64-bin"
        EFI_BOOT_NAME="BOOTX64.EFI"
        HAS_BIOS=1
        ;;
    arm64|aarch64)
        NEXUSB_ARCH="arm64"
        DEB_ARCH="arm64"
        # Ubuntu arm64 lives on ports.ubuntu.com, not archive.ubuntu.com.
        UBUNTU_MIRROR="http://ports.ubuntu.com/ubuntu-ports"
        UBUNTU_SECURITY_MIRROR="http://ports.ubuntu.com/ubuntu-ports"
        GRUB_EFI_FORMAT="arm64-efi"
        GRUB_EFI_PKG="grub-efi-arm64-bin"
        EFI_BOOT_NAME="BOOTAA64.EFI"
        HAS_BIOS=0          # arm64 is UEFI-only; no Legacy BIOS / syslinux
        ;;
    *)
        echo "Error: unsupported NEXUSB_ARCH '$NEXUSB_ARCH' (use amd64 or arm64)" >&2
        return 1 2>/dev/null || exit 1
        ;;
esac

export NEXUSB_ARCH DEB_ARCH UBUNTU_MIRROR UBUNTU_SECURITY_MIRROR \
       GRUB_EFI_FORMAT GRUB_EFI_PKG EFI_BOOT_NAME HAS_BIOS
