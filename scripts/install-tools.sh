#!/bin/bash
# install tools from config

WORK_DIR=$1
TOOLS_CONF="config/tools.conf"

# mount kernel virtual filesystems into the chroot so package postinst
# scripts behave (apt wants /dev/pts; some postinst probe /proc). unmounted
# on exit via trap so they are never captured by the later squashfs.
mount_chroot() {
    mount -t proc   proc   "$WORK_DIR/proc"    2>/dev/null || true
    mount -t sysfs  sys    "$WORK_DIR/sys"     2>/dev/null || true
    mount --bind    /dev   "$WORK_DIR/dev"     2>/dev/null || true
    mount -t devpts devpts "$WORK_DIR/dev/pts" 2>/dev/null || true
}
umount_chroot() {
    umount -l "$WORK_DIR/dev/pts" 2>/dev/null || true
    umount -l "$WORK_DIR/dev"     2>/dev/null || true
    umount -l "$WORK_DIR/sys"     2>/dev/null || true
    umount -l "$WORK_DIR/proc"    2>/dev/null || true
}
trap umount_chroot EXIT
mount_chroot

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
