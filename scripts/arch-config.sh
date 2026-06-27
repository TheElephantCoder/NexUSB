#!/bin/bash
# Per-arch build settings. Source this; it reads NEXUSB_ARCH (amd64|arm64,
# default amd64; x86_64/aarch64 also accepted) and exports DEB_ARCH, the apt
# mirrors, the GRUB EFI format/package, the removable EFI name, and HAS_BIOS.

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
