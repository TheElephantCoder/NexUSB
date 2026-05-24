#!/bin/bash
# Download ISOs - automatic and manual

ISO_DIR="build/isos"
ISO_CONF="config/iso-collection.conf"

mkdir -p "$ISO_DIR"/{Linux,Security,Rescue,Antivirus,Windows,Tools}

echo "=== NexUSB ISO Downloader ==="
echo ""

# Function to download ISO
download_iso() {
    local name="$1"
    local url="$2"
    local output="$3"
    
    echo "Downloading: $name"
    echo "URL: $url"
    
    if wget --progress=bar:force -O "$output" "$url" 2>&1; then
        echo "✓ $name downloaded successfully"
        return 0
    else
        echo "✗ Failed to download $name"
        return 1
    fi
}

# Download freely available rescue ISOs automatically
echo "Downloading essential rescue ISOs (this will take a while)..."
echo ""

echo "[1/10] SystemRescue..."
download_iso "SystemRescue" \
    "https://sourceforge.net/projects/systemrescuecd/files/latest/download" \
    "$ISO_DIR/Rescue/systemrescue.iso"

echo "[2/10] Clonezilla..."
download_iso "Clonezilla" \
    "https://sourceforge.net/projects/clonezilla/files/clonezilla_live_stable/3.1.2-22/clonezilla-live-3.1.2-22-amd64.iso/download" \
    "$ISO_DIR/Rescue/clonezilla.iso"

echo "[3/10] GParted Live..."
download_iso "GParted" \
    "https://sourceforge.net/projects/gparted/files/gparted-live-stable/1.6.0-3/gparted-live-1.6.0-3-amd64.iso/download" \
    "$ISO_DIR/Rescue/gparted.iso"

echo "[4/10] MemTest86+..."
download_iso "MemTest86+" \
    "https://memtest.org/download/v7.00/mt86plus_7.00_64.iso.zip" \
    "$ISO_DIR/Tools/memtest86plus.zip"

echo "[5/10] Ultimate Boot CD..."
download_iso "Ultimate Boot CD" \
    "https://www.ultimatebootcd.com/download/ubcd539.iso" \
    "$ISO_DIR/Tools/ubcd.iso"

echo "[6/10] Rescuezilla..."
download_iso "Rescuezilla" \
    "https://github.com/rescuezilla/rescuezilla/releases/download/2.5.1/rescuezilla-2.5.1-64bit.jammy.iso" \
    "$ISO_DIR/Rescue/rescuezilla.iso"

echo "[7/10] Kaspersky Rescue Disk..."
download_iso "Kaspersky Rescue Disk" \
    "https://rescuedisk.s.kaspersky-labs.com/updatable/2018/krd.iso" \
    "$ISO_DIR/Antivirus/kaspersky-rescue.iso"

echo "[8/10] Tails (Privacy OS)..."
download_iso "Tails" \
    "https://tails.net/torrents/files/tails-amd64-6.8.iso" \
    "$ISO_DIR/Security/tails.iso"

echo "[9/10] Puppy Linux..."
download_iso "Puppy Linux" \
    "https://distro.ibiblio.org/puppylinux/puppy-fossa/fossapup64-9.5.iso" \
    "$ISO_DIR/Linux/puppy.iso"

echo "[10/10] Tiny Core Linux..."
download_iso "Tiny Core Linux" \
    "http://tinycorelinux.net/15.x/x86_64/release/TinyCorePure64-15.0.iso" \
    "$ISO_DIR/Linux/tinycore.iso"

# Extract zipped ISOs
if [ -f "$ISO_DIR/Tools/memtest86plus.zip" ]; then
    unzip -o "$ISO_DIR/Tools/memtest86plus.zip" -d "$ISO_DIR/Tools/"
    rm "$ISO_DIR/Tools/memtest86plus.zip"
fi

echo ""
echo "=== Automatic Downloads Complete ==="
echo ""

# Create manual download list
cat << 'EOF' > "$ISO_DIR/MANUAL_DOWNLOADS.txt"
=== MANUAL ISO DOWNLOADS ===

The following ISOs require manual download due to size, licensing, or registration:

LINUX DISTRIBUTIONS (Large):
1. Ubuntu Desktop (4GB) - https://ubuntu.com/download/desktop
2. Linux Mint (3GB) - https://linuxmint.com/download.php
3. Fedora Workstation (2.5GB) - https://getfedora.org/
4. Debian Live (3.5GB) - https://www.debian.org/CD/live/
5. Manjaro (3.8GB) - https://manjaro.org/download/
6. Pop!_OS (3GB) - https://pop.system76.com/
7. Elementary OS (2.8GB) - https://elementary.io/
8. Zorin OS (3.3GB) - https://zorin.com/os/download/
9. MX Linux (2GB) - https://mxlinux.org/download-links/

SECURITY & PENETRATION TESTING:
1. Kali Linux (4GB) - https://www.kali.org/get-kali/
   Download: kali-linux-2024.x-live-amd64.iso
   Place in: ISOs/Security/

2. Parrot Security (5GB) - https://www.parrotsec.org/download/
   Download: Parrot-security-x.x_amd64.iso
   Place in: ISOs/Security/

3. BlackArch Linux (8GB) - https://blackarch.org/downloads.html
   Download: blackarch-linux-live-x86_64.iso
   Place in: ISOs/Security/

4. Pentoo (4GB) - https://www.pentoo.ch/download/
   Place in: ISOs/Security/

ANTIVIRUS RESCUE DISCS:
1. Bitdefender Rescue CD - https://www.bitdefender.com/support/
   Download: rescue_cd.iso
   Place in: ISOs/Antivirus/

2. AVG Rescue CD - https://www.avg.com/
   Place in: ISOs/Antivirus/

3. Avira Rescue System - https://www.avira.com/
   Place in: ISOs/Antivirus/

4. ESET SysRescue Live - https://www.eset.com/
   Requires registration
   Place in: ISOs/Antivirus/

5. F-Secure Rescue CD - https://www.f-secure.com/
   Place in: ISOs/Antivirus/

6. Sophos Bootable Anti-Virus - https://www.sophos.com/
   Requires business account
   Place in: ISOs/Antivirus/

7. Dr.Web LiveDisk - https://free.drweb.com/livedisk/
   Place in: ISOs/Antivirus/

SPECIALIZED RESCUE TOOLS:
1. Hiren's BootCD PE (1.5GB) - https://www.hirensbootcd.org/
   Download: HBCD_PE_x64.iso
   Place in: ISOs/Rescue/

2. Trinity Rescue Kit - https://trinityhome.org/
   Place in: ISOs/Rescue/

3. Falcon - https://falconfour.com/
   Place in: ISOs/Rescue/

4. DBAN (Disk Wipe) - https://dban.org/
   Download: dban-x.x.x_i586.iso
   Place in: ISOs/Tools/

5. ShredOS - https://github.com/PartialVolume/shredos.x86_64/releases
   Place in: ISOs/Tools/

WINDOWS INSTALLATION MEDIA:
1. Windows 10 (6GB) - https://www.microsoft.com/software-download/windows10
   Use Media Creation Tool or download ISO directly
   Place in: ISOs/Windows/

2. Windows 11 (6GB) - https://www.microsoft.com/software-download/windows11
   Use Media Creation Tool or download ISO directly
   Place in: ISOs/Windows/

3. Windows Server - https://www.microsoft.com/evalcenter/
   Evaluation versions available
   Place in: ISOs/Windows/

BSD SYSTEMS:
1. FreeBSD (3GB) - https://www.freebsd.org/where/
2. GhostBSD (3.5GB) - https://www.ghostbsd.org/download
3. TrueNAS CORE - https://www.truenas.com/download-truenas-core/
4. pfSense - https://www.pfsense.org/download/
5. OPNsense - https://opnsense.org/download/

DOWNLOAD INSTRUCTIONS:
1. Visit the URLs above
2. Download the ISO files
3. Verify checksums when provided
4. Place in the appropriate directory:
   - ISOs/Linux/
   - ISOs/Security/
   - ISOs/Rescue/
   - ISOs/Antivirus/
   - ISOs/Windows/
   - ISOs/Tools/

4. The build script will automatically include them in the multiboot system

TIPS:
- Use a download manager for large files
- Verify ISO integrity with SHA256 checksums
- Keep ISOs updated by re-downloading periodically
- Remove ISOs you don't need to save space

TORRENT DOWNLOADS (Faster for large files):
Many distributions offer torrent downloads which are often faster:
- Ubuntu: Available on download page
- Kali Linux: Available on download page
- Tails: Recommended method
- Debian: Available via jigdo or torrent
EOF

# Create README
cat << 'EOF' > "$ISO_DIR/README.txt"
NexUSB - ISO Collection

AUTOMATICALLY DOWNLOADED (Essential Rescue Tools):
✓ SystemRescue - Complete rescue toolkit
✓ Clonezilla - Disk cloning and imaging
✓ GParted Live - Partition management
✓ MemTest86+ - Memory testing
✓ Ultimate Boot CD - Diagnostic tools
✓ Rescuezilla - Backup and restore
✓ Kaspersky Rescue Disk - Antivirus rescue
✓ Tails - Privacy-focused OS
✓ Puppy Linux - Lightweight Linux
✓ Tiny Core Linux - Minimal Linux

DIRECTORY STRUCTURE:
- Linux/ - Linux distributions
- Security/ - Penetration testing and security tools
- Rescue/ - System recovery and repair tools
- Antivirus/ - Antivirus rescue discs
- Windows/ - Windows installation media
- Tools/ - Specialized diagnostic tools

ADDING MORE ISOs:
1. Download ISOs (see MANUAL_DOWNLOADS.txt)
2. Place in appropriate directory
3. Rebuild NexUSB or copy directly to USB

MULTIBOOT:
All ISOs in these directories will be automatically
detected and added to the boot menu.

USAGE:
1. Boot from NexUSB USB drive
2. Select "ISO Collection" from main menu
3. Choose the ISO you want to boot
4. Follow the ISO's boot instructions

For more information:
https://github.com/yourusername/NexUSB
EOF

# Create download helper script
cat << 'SCRIPT' > "$ISO_DIR/download-popular.sh"
#!/bin/bash
# Download most popular ISOs

echo "Downloading popular Linux distributions..."
echo "This will download approximately 15GB of ISOs"
echo ""
read -p "Continue? (y/n) " -n 1 -r
echo
if [[ ! $REPLY =~ ^[Yy]$ ]]; then
    exit 1
fi

# Ubuntu
echo "Downloading Ubuntu Desktop..."
wget -O Linux/ubuntu-desktop.iso \
    "https://releases.ubuntu.com/24.04/ubuntu-24.04-desktop-amd64.iso"

# Linux Mint
echo "Downloading Linux Mint..."
wget -O Linux/linuxmint.iso \
    "https://mirrors.edge.kernel.org/linuxmint/stable/22/linuxmint-22-cinnamon-64bit.iso"

# Kali Linux
echo "Downloading Kali Linux..."
wget -O Security/kali-linux.iso \
    "https://cdimage.kali.org/kali-2024.3/kali-linux-2024.3-live-amd64.iso"

# Hiren's BootCD PE
echo "Downloading Hiren's BootCD PE..."
wget -O Rescue/hirens-bootcd.iso \
    "https://www.hirensbootcd.org/files/HBCD_PE_x64.iso"

echo ""
echo "Downloads complete!"
echo "Total downloaded: ~15GB"
SCRIPT

chmod +x "$ISO_DIR/download-popular.sh"

echo ""
echo "=== ISO Download Summary ==="
echo "✓ Essential rescue ISOs downloaded automatically"
echo "✓ Manual download list created: $ISO_DIR/MANUAL_DOWNLOADS.txt"
echo "✓ Helper script created: $ISO_DIR/download-popular.sh"
echo ""
echo "To download popular distributions:"
echo "  cd $ISO_DIR && ./download-popular.sh"
echo ""
echo "Total size of auto-downloaded ISOs: ~3GB"
echo "Full collection with manual downloads: ~30GB"
