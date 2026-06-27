#!/bin/bash
# essential tools only

WORK_DIR=$1

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

# teamviewer + anydesk
echo "Downloading remote access tools..."
mkdir -p "$WORK_DIR/opt/remote-tools"

# teamviewer
wget -O "$WORK_DIR/opt/remote-tools/teamviewer.deb" \
    "https://download.teamviewer.com/download/linux/teamviewer_amd64.deb" || true

# anydesk
wget -O "$WORK_DIR/opt/remote-tools/anydesk.deb" \
    "https://download.anydesk.com/linux/anydesk_6.3.2-1_amd64.deb" || true

# install if download worked
if [ -f "$WORK_DIR/opt/remote-tools/teamviewer.deb" ]; then
    chroot "$WORK_DIR" dpkg -i /opt/remote-tools/teamviewer.deb || true
    chroot "$WORK_DIR" apt install -f -y
fi

if [ -f "$WORK_DIR/opt/remote-tools/anydesk.deb" ]; then
    chroot "$WORK_DIR" dpkg -i /opt/remote-tools/anydesk.deb || true
    chroot "$WORK_DIR" apt install -f -y
fi

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
