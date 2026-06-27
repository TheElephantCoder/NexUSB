#!/bin/bash
# Setup minimal base system for smaller ISO

WORK_DIR=$1
source "$(dirname "$0")/arch-config.sh"

echo "Downloading minimal base system (arch: $DEB_ARCH)..."
debootstrap --variant=minbase --arch="$DEB_ARCH" jammy "$WORK_DIR" "$UBUNTU_MIRROR"

echo "Configuring minimal system..."
cat > "$WORK_DIR/etc/apt/sources.list" << EOF
deb $UBUNTU_MIRROR jammy main restricted universe
deb $UBUNTU_MIRROR jammy-updates main restricted universe
deb $UBUNTU_SECURITY_MIRROR jammy-security main restricted universe
EOF

# Chroot and update
chroot "$WORK_DIR" apt update
chroot "$WORK_DIR" apt upgrade -y

# Install only essential packages
chroot "$WORK_DIR" apt install -y --no-install-recommends \
    linux-image-generic \
    live-boot \
    systemd-sysv

echo "Minimal base system setup complete"
