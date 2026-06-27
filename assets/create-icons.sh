#!/bin/bash
# Download and create actual tool logos for NexUSB

ICON_DIR="assets/icons"
TOOLS_DIR="$ICON_DIR/tools"
mkdir -p "$ICON_DIR" "$TOOLS_DIR"

echo "Creating NexUSB branding from the bundled logo..."

SOURCE_LOGO="$ICON_DIR/NexUSB-Logo.png"

if [ -f "$SOURCE_LOGO" ]; then
    # Derive the header logo and app icon from the real NexUSB logo.
    convert "$SOURCE_LOGO" -resize 256x256 "$ICON_DIR/nex-logo.png"
    convert "$SOURCE_LOGO" -resize 256x256 "$ICON_DIR/nex-icon.png"
else
    echo "Warning: $SOURCE_LOGO not found; generating a text fallback"
    # Fallback wordmark
    convert -size 400x80 xc:transparent \
        -font "DejaVu-Sans-Bold" -pointsize 48 \
        -fill "#66b3ff" -annotate +10+60 "Nex" \
        -fill "#0066cc" -annotate +200+60 "USB" \
        "$ICON_DIR/nex-logo.png"
    # Fallback app icon
    convert -size 256x256 xc:transparent \
        -fill "#001a33" -draw "roundrectangle 20,20 236,236 20,20" \
        -fill "#66b3ff" -font "DejaVu-Sans-Bold" -pointsize 120 \
        -gravity center -annotate +0+0 "N" \
        "$ICON_DIR/nex-icon.png"
fi

# Background (1920x1080)
convert -size 1920x1080 \
    gradient:'#001a33-#000000' \
    -blur 0x8 \
    "$ICON_DIR/background.png"

# Selection highlights for GRUB
convert -size 800x32 \
    gradient:'#0066cc-#003366' \
    -alpha set -channel A -evaluate set 80% \
    "$ICON_DIR/select_c.png"

convert -size 16x32 \
    gradient:'#0066cc-#003366' \
    -alpha set -channel A -evaluate set 80% \
    "$ICON_DIR/select_w.png"

convert -size 16x32 \
    gradient:'#0066cc-#003366' \
    -alpha set -channel A -evaluate set 80% \
    "$ICON_DIR/select_e.png"

echo ""
echo "Downloading actual tool logos (64x64)..."

# Function to download and resize logo
download_logo() {
    local name="$1"
    local url="$2"
    local output="$TOOLS_DIR/${name}.png"
    
    echo "  - $name"
    if wget -q -O "/tmp/${name}_temp.png" "$url" 2>/dev/null; then
        convert "/tmp/${name}_temp.png" -resize 64x64 "$output" 2>/dev/null || \
        cp "/tmp/${name}_temp.png" "$output"
        rm "/tmp/${name}_temp.png"
    else
        # Create fallback icon with first letter
        convert -size 64x64 xc:"#0066cc" \
            -fill white -font "DejaVu-Sans-Bold" -pointsize 32 \
            -gravity center -annotate +0+0 "${name:0:1}" \
            "$output"
    fi
}

# Security Tools
download_logo "clamav" "https://www.clamav.net/assets/clamav-trademark.png"
download_logo "wireshark" "https://www.wireshark.org/assets/icons/wireshark-fin.png"
download_logo "nmap" "https://nmap.org/images/nmap-logo-256x256.png"
download_logo "metasploit" "https://www.metasploit.com/includes/images/metasploit-r7-logo.svg"

# Recovery Tools
download_logo "testdisk" "https://www.cgsecurity.org/wiki/images/testdisk.png"
download_logo "clonezilla" "https://clonezilla.org/images/Clonezilla-icon.png"
download_logo "gparted" "https://gparted.org/gparted.png"

# Remote Access
download_logo "remmina" "https://remmina.org/images/remmina-icon.png"
download_logo "teamviewer" "https://www.teamviewer.com/link/?url=1234567&id=logo"
download_logo "anydesk" "https://anydesk.com/favicon.ico"

# System Tools
download_logo "firefox" "https://www.mozilla.org/media/protocol/img/logos/firefox/browser/logo.svg"
download_logo "vlc" "https://images.videolan.org/images/vlc-icon.png"
download_logo "libreoffice" "https://www.libreoffice.org/assets/Uploads/LibreOffice-Initial-Artwork-Logo-ColorLogoBasic-500px.png"

# Network Tools
download_logo "putty" "https://www.putty.org/images/putty-icon.png"
download_logo "filezilla" "https://filezilla-project.org/images/filezilla-icon.png"

# Disk Tools
download_logo "crystaldiskinfo" "https://crystalmark.info/en/wp-content/uploads/sites/2/2020/09/CrystalDiskInfo.png"
download_logo "crystaldiskmark" "https://crystalmark.info/en/wp-content/uploads/sites/2/2020/09/CrystalDiskMark.png"

# System Info
download_logo "cpuz" "https://www.cpuid.com/medias/images/softwares/cpu-z.png"
download_logo "gpuz" "https://www.techpowerup.com/img/gpuz.png"
download_logo "hwinfo" "https://www.hwinfo.com/img/hwi_logo.png"

# Utilities
download_logo "7zip" "https://www.7-zip.org/7ziplogo.png"
download_logo "notepadpp" "https://notepad-plus-plus.org/images/logo.svg"

# Create fallback icons for tools without logos
create_fallback() {
    local name="$1"
    local letter="$2"
    local color="$3"
    
    if [ ! -f "$TOOLS_DIR/${name}.png" ]; then
        convert -size 64x64 xc:"$color" \
            -fill white -font "DejaVu-Sans-Bold" -pointsize 28 \
            -gravity center -annotate +0+0 "$letter" \
            -bordercolor "$color" -border 2 \
            "$TOOLS_DIR/${name}.png"
    fi
}

echo ""
echo "Creating fallback icons for remaining tools..."

# Security
create_fallback "chkrootkit" "R" "#cc0000"
create_fallback "rkhunter" "R" "#990000"
create_fallback "lynis" "L" "#ff6600"
create_fallback "aide" "A" "#cc6600"
create_fallback "aircrack" "A" "#0099cc"

# Recovery
create_fallback "photorec" "P" "#00cc66"
create_fallback "ddrescue" "D" "#009933"
create_fallback "foremost" "F" "#00cc99"
create_fallback "bootrepair" "B" "#6600cc"

# Disk
create_fallback "fdisk" "F" "#cc9900"
create_fallback "parted" "P" "#cc6600"
create_fallback "smart" "S" "#0066cc"
create_fallback "baobab" "D" "#cc3300"

# Network
create_fallback "tcpdump" "T" "#009999"
create_fallback "iftop" "I" "#0099cc"
create_fallback "nethogs" "N" "#00cccc"
create_fallback "mtr" "M" "#0066cc"
create_fallback "kismet" "K" "#6600cc"

# Remote
create_fallback "vnc" "V" "#0066cc"
create_fallback "ssh" "S" "#009900"
create_fallback "rdp" "R" "#0066cc"
create_fallback "xrdp" "X" "#0099cc"

# System
create_fallback "htop" "H" "#00cc00"
create_fallback "hardinfo" "H" "#0066cc"
create_fallback "lshw" "L" "#6666cc"
create_fallback "sensors" "S" "#cc6600"
create_fallback "memtest" "M" "#cc0066"

# Category icons (larger, 128x128)
echo ""
echo "Creating category icons..."

create_category_icon() {
    local name="$1"
    local symbol="$2"
    local color="$3"
    
    convert -size 128x128 xc:transparent \
        -fill "$color" -draw "roundrectangle 10,10 118,118 15,15" \
        -fill white -font "DejaVu-Sans-Bold" -pointsize 64 \
        -gravity center -annotate +0+0 "$symbol" \
        "$ICON_DIR/${name}.png"
}

create_category_icon "security" "🛡" "#cc0000"
create_category_icon "recovery" "💾" "#00cc66"
create_category_icon "disk" "💿" "#cc9900"
create_category_icon "network" "🌐" "#0099cc"
create_category_icon "remote" "🖥" "#0066cc"
create_category_icon "system" "ℹ" "#6666cc"

echo ""
echo "✓ Icons created successfully!"
echo ""
echo "Locations:"
echo "  - NexB branding: $ICON_DIR/"
echo "  - Tool logos: $TOOLS_DIR/"
echo ""
echo "To use custom logos:"
echo "  1. Replace files in $TOOLS_DIR/ with your own 64x64 PNG files"
echo "  2. Name them exactly as shown (e.g., clamav.png, gparted.png)"
echo "  3. Rebuild NexB"
