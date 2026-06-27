#!/usr/bin/env bash
#
# Runs INSIDE a WSL2 Ubuntu distro (as root) to build NexUSB on Windows 11.
# Invoked by windows/Build-NexUSB.ps1 — not meant to be run directly.
#
# Args: <target: minimal|full> <size_gb> <arch: amd64|arm64> <repo_wsl_path>
#
# The repo lives on the Windows filesystem (mounted at /mnt/<drive>/...).
# debootstrap/chroot/mknod and squashfs fail on that DrvFs mount, so we stage
# the source onto the WSL ext4 filesystem, build there, then copy the finished
# artifacts back to <repo>/dist on the Windows side.
set -euo pipefail

TARGET="${1:-minimal}"
SIZE_GB="${2:-32}"
ARCH="${3:-arm64}"
SRC="${4:?repo path (WSL form) required}"

echo ">> NexUSB WSL build — target=$TARGET arch=$ARCH"
echo ">> source: $SRC"

if [ "$(id -u)" -ne 0 ]; then
    echo "Error: must run as root (the PowerShell launcher uses 'wsl -u root')." >&2
    exit 1
fi

if [ ! -f "$SRC/build.sh" ]; then
    echo "Error: '$SRC' does not look like a NexUSB checkout (no build.sh)." >&2
    exit 1
fi

export DEBIAN_FRONTEND=noninteractive

echo ">> Installing build dependencies (apt) ..."
apt-get update -qq
COMMON="debootstrap grub2-common xorriso squashfs-tools mtools parted \
        dosfstools e2fsprogs ntfs-3g exfatprogs imagemagick ca-certificates \
        wget rsync"
# shellcheck disable=SC2086
apt-get install -y --no-install-recommends $COMMON
if [ "$ARCH" = "arm64" ]; then
    apt-get install -y --no-install-recommends grub-efi-arm64-bin
else
    apt-get install -y --no-install-recommends \
        grub-pc-bin grub-efi-amd64-bin isolinux syslinux syslinux-common syslinux-utils
fi

# Stage onto the WSL ext4 filesystem (NOT the /mnt DrvFs mount).
STAGE="/root/nexusb-build"
echo ">> Staging source into $STAGE ..."
mkdir -p "$STAGE"
rsync -a --delete \
    --exclude='.git' \
    --exclude='build' \
    --exclude='build-minimal' \
    --exclude='dist' \
    "$SRC"/ "$STAGE"/

cd "$STAGE"
find . -type f -name '*.sh' -exec chmod +x {} +

echo ">> Running '$TARGET' build (NEXUSB_ARCH=$ARCH) ..."
export NEXUSB_ASSUME_YES=1
export NEXUSB_ARCH="$ARCH"
case "$TARGET" in
    minimal) ./build-minimal.sh ;;
    full)    ./build.sh "$SIZE_GB" ;;
    *) echo "Error: unknown target '$TARGET' (minimal|full)" >&2; exit 1 ;;
esac

echo ">> Copying artifacts back to $SRC/dist ..."
mkdir -p "$SRC/dist"
cp -a "$STAGE"/dist/. "$SRC/dist"/

echo ">> Build finished. Artifacts are in the repo's dist/ folder."
