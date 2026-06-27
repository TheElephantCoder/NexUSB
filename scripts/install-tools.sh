#!/bin/bash
# install tools from config

WORK_DIR=$1
TOOLS_CONF="config/tools.conf"

echo "Installing essential packages..."
chroot "$WORK_DIR" apt install -y \
    linux-generic \
    live-boot \
    systemd-sysv \
    network-manager \
    wireless-tools \
    wpasupplicant

echo "Reading tools configuration..."
while IFS='|' read -r category tool package description; do
    # skip comments/blanks
    [[ "$category" =~ ^#.*$ ]] && continue
    [[ -z "$category" ]] && continue
    
    echo "Installing $tool ($package)..."
    chroot "$WORK_DIR" apt install -y "$package" || echo "Warning: Failed to install $package"
done < "$TOOLS_CONF"

echo "Installing GUI environment..."
chroot "$WORK_DIR" apt install -y \
    xorg \
    openbox \
    lxdm \
    lxterminal \
    pcmanfm

echo "Tool installation complete"
