#!/bin/bash
# debootstrap the base rootfs

WORK_DIR=$1
source "$(dirname "$0")/arch-config.sh"

echo "Downloading base system (arch: $DEB_ARCH)..."
debootstrap --arch="$DEB_ARCH" jammy "$WORK_DIR" "$UBUNTU_MIRROR"

echo "Configuring base system..."
cat > "$WORK_DIR/etc/apt/sources.list" << EOF
deb $UBUNTU_MIRROR jammy main restricted universe multiverse
deb $UBUNTU_MIRROR jammy-updates main restricted universe multiverse
deb $UBUNTU_SECURITY_MIRROR jammy-security main restricted universe multiverse
EOF

# update in chroot
chroot "$WORK_DIR" apt update
chroot "$WORK_DIR" apt upgrade -y

echo "Base system setup complete"
