#!/bin/bash
# essential tools only

WORK_DIR=$1
source "$(dirname "$0")/arch-config.sh"

# mount kernel virtual filesystems into the chroot so package postinst
# scripts behave (anydesk probes /proc/1/exe; apt wants /dev/pts). unmounted
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

# core
chroot "$WORK_DIR" apt install -y --no-install-recommends \
    network-manager \
    wireless-tools \
    wpasupplicant \
    dialog

# malware scanning
echo "Installing malware scanning tools..."
chroot "$WORK_DIR" apt install -y --no-install-recommends \
    clamav \
    clamav-freshclam \
    chkrootkit

# recovery
echo "Installing recovery tools..."
chroot "$WORK_DIR" apt install -y --no-install-recommends \
    testdisk \
    gddrescue \
    e2fsprogs

# disk
echo "Installing disk tools..."
chroot "$WORK_DIR" apt install -y --no-install-recommends \
    gparted \
    fdisk \
    parted \
    smartmontools

# network
echo "Installing network tools..."
chroot "$WORK_DIR" apt install -y --no-install-recommends \
    nmap \
    netcat-openbsd \
    tcpdump \
    openssh-client

# remote access
echo "Installing remote access tools..."
chroot "$WORK_DIR" apt install -y --no-install-recommends \
    remmina \
    remmina-plugin-rdp \
    remmina-plugin-vnc \
    tigervnc-viewer \
    xrdp

# minimal gui
echo "Installing minimal GUI..."
chroot "$WORK_DIR" apt install -y --no-install-recommends \
    xorg \
    openbox \
    lxdm \
    lxterminal \
    pcmanfm \
    firefox

# file managers + utils
chroot "$WORK_DIR" apt install -y --no-install-recommends \
    mc \
    nano \
    vim-tiny \
    htop

# teamviewer + anydesk (proprietary, amd64-only debs). their vendors don't
# ship matching arm64 .debs for this pinned setup, so skip them on arm64 — the
# open-source remote tools (remmina, xrdp, ssh, vnc) above still apply. set
# NEXUSB_SKIP_PROPRIETARY=1 to leave them out of a build entirely.
if [ -n "${NEXUSB_SKIP_PROPRIETARY:-}" ]; then
    echo "Skipping TeamViewer/AnyDesk (NEXUSB_SKIP_PROPRIETARY set)"
elif [ "$DEB_ARCH" = "amd64" ]; then
    echo "Downloading remote access tools..."
    mkdir -p "$WORK_DIR/opt/remote-tools"

    # teamviewer
    wget -O "$WORK_DIR/opt/remote-tools/teamviewer.deb" \
        "https://download.teamviewer.com/download/linux/teamviewer_amd64.deb" || true

    # anydesk
    wget -O "$WORK_DIR/opt/remote-tools/anydesk.deb" \
        "https://download.anydesk.com/linux/anydesk_6.3.2-1_amd64.deb" || true

    # install via apt so dependencies resolve in one step. if a package still
    # fails to configure (e.g. virtual filesystems unavailable), purge it so the
    # dpkg db stays clean and squashfs never captures a half-configured package;
    # the .deb is left under /opt/remote-tools for manual install at first boot.
    for tool in teamviewer anydesk; do
        deb="/opt/remote-tools/$tool.deb"
        if [ -s "$WORK_DIR$deb" ]; then
            echo "Installing $tool..."
            if ! chroot "$WORK_DIR" apt install -y --no-install-recommends "$deb"; then
                echo "Warning: $tool did not configure; keeping the .deb in /opt/remote-tools for manual install"
                chroot "$WORK_DIR" apt-get purge -y "$tool" 2>/dev/null || true
                chroot "$WORK_DIR" dpkg --purge --force-remove-reinstreq "$tool" 2>/dev/null || true
            fi
        fi
    done
else
    echo "Skipping TeamViewer/AnyDesk (no arm64 .deb); using remmina/xrdp/ssh/vnc"
fi

# make sure nothing is left half-configured before the squashfs is built
chroot "$WORK_DIR" dpkg --configure -a 2>/dev/null || true
chroot "$WORK_DIR" apt-get install -f -y 2>/dev/null || true

# trim size
echo "Cleaning up to reduce ISO size..."
chroot "$WORK_DIR" apt clean
chroot "$WORK_DIR" apt autoremove -y
rm -rf "$WORK_DIR/var/cache/apt/archives/"*.deb
rm -rf "$WORK_DIR/tmp/"*
rm -rf "$WORK_DIR/var/tmp/"*

echo "Minimal tools installation complete"
echo "Installed tools:"
echo "  - ClamAV (antivirus)"
echo "  - TestDisk/PhotoRec (recovery)"
echo "  - GParted (disk management)"
echo "  - nmap, tcpdump (network)"
echo "  - Remmina (RDP/VNC client)"
echo "  - xrdp (RDP server)"
echo "  - TeamViewer (if available)"
echo "  - AnyDesk (if available)"
