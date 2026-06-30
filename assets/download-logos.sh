#!/bin/bash
# download tool logos, generate fallbacks + branding

ICON_DIR="assets/icons"
TOOLS_DIR="$ICON_DIR/tools"
mkdir -p "$ICON_DIR" "$TOOLS_DIR"

echo "=========================================="
echo "  NexUSB Logo Downloader & Generator"
echo "=========================================="
echo ""

# need imagemagick + wget
command -v convert >/dev/null 2>&1 || { echo "Error: ImageMagick not installed. Run: sudo apt install imagemagick"; exit 1; }
command -v wget >/dev/null 2>&1 || { echo "Error: wget not installed. Run: sudo apt install wget"; exit 1; }

# download + convert a logo
download_logo() {
    local name="$1"
    local url="$2"
    local output="$TOOLS_DIR/${name}.png"
    
    if [ -f "$output" ]; then
        echo "  ✓ $name (already exists)"
        return 0
    fi
    
    echo -n "  Downloading $name... "
    
    # try download (descriptive UA: Wikimedia and some CDNs reject blank/default ones)
    if wget -q --timeout=15 --tries=2 \
        -U "NexUSB-build/1.0 (+https://github.com/TheElephantCoder/NexUSB)" \
        -O "/tmp/${name}_temp" "$url" 2>/dev/null; then
        # to 64x64 png
        if convert "/tmp/${name}_temp" -resize 64x64 -background none -gravity center -extent 64x64 "$output" 2>/dev/null; then
            echo "✓"
            rm -f "/tmp/${name}_temp"
            return 0
        fi
    fi
    
    echo "✗ (will create fallback)"
    rm -f "/tmp/${name}_temp"
    return 1
}

# fallback icon
create_fallback() {
    local name="$1"
    local letter="$2"
    local color="$3"
    local output="$TOOLS_DIR/${name}.png"
    
    if [ -f "$output" ]; then
        return 0
    fi
    
    convert -size 64x64 xc:"$color" \
        -fill white -font "DejaVu-Sans-Bold" -pointsize 32 \
        -gravity center -annotate +0+0 "$letter" \
        -bordercolor "$color" -border 2 \
        "$output" 2>/dev/null
}

echo "[1/5] Downloading Security Tool Logos..."
download_logo "clamav" "https://commons.wikimedia.org/wiki/Special:FilePath/ClamAV_Logo.png?width=128"
download_logo "wireshark" "https://commons.wikimedia.org/wiki/Special:FilePath/Wireshark_icon.svg?width=128"
download_logo "nmap" "https://nmap.org/images/nmap-logo-256x256.png"
create_fallback "chkrootkit" "R" "#cc0000"
create_fallback "rkhunter" "RK" "#990000"
create_fallback "lynis" "L" "#ff6600"
create_fallback "metasploit" "M" "#0066cc"
create_fallback "aircrack" "A" "#0099cc"

echo ""
echo "[2/5] Downloading Recovery Tool Logos..."
download_logo "gparted" "https://commons.wikimedia.org/wiki/Special:FilePath/Scalable_gparted.svg?width=128"
create_fallback "testdisk" "TD" "#00cc66"
create_fallback "photorec" "PR" "#00cc66"
create_fallback "clonezilla" "CZ" "#009933"
create_fallback "ddrescue" "DD" "#009933"
create_fallback "foremost" "F" "#00cc99"
create_fallback "bootrepair" "BR" "#6600cc"

echo ""
echo "[3/5] Downloading Remote Access Logos..."
download_logo "remmina" "https://commons.wikimedia.org/wiki/Special:FilePath/Org.remmina.Remmina.svg?width=128"
download_logo "teamviewer" "https://commons.wikimedia.org/wiki/Special:FilePath/TeamViewer_Icon.svg?width=128"
create_fallback "anydesk" "AD" "#cc0000"
create_fallback "vnc" "VNC" "#0066cc"
create_fallback "ssh" "SSH" "#009900"
create_fallback "rdp" "RDP" "#0066cc"
create_fallback "xrdp" "X" "#0099cc"

echo ""
echo "[4/5] Downloading System Tool Logos..."
download_logo "firefox" "https://commons.wikimedia.org/wiki/Special:FilePath/Firefox_logo,_2019.svg?width=128"
download_logo "vlc" "https://commons.wikimedia.org/wiki/Special:FilePath/VLC_Icon.svg?width=128"
create_fallback "hardinfo" "HW" "#0066cc"
create_fallback "htop" "H" "#00cc00"
create_fallback "lshw" "L" "#6666cc"
create_fallback "sensors" "S" "#cc6600"
create_fallback "memtest" "M" "#cc0066"

echo ""
echo "[5/5] Downloading Utility Logos..."
download_logo "7zip" "https://www.7-zip.org/7ziplogo.png"
create_fallback "notepadpp" "N++" "#90ee90"
create_fallback "cpuz" "CPU" "#0066cc"
create_fallback "gpuz" "GPU" "#00cc00"
create_fallback "crystaldiskinfo" "CDI" "#0099cc"
create_fallback "crystaldiskmark" "CDM" "#cc9900"
create_fallback "putty" "SSH" "#009900"
create_fallback "filezilla" "FZ" "#cc0000"

# network tools
create_fallback "tcpdump" "TCP" "#009999"
create_fallback "iftop" "IF" "#0099cc"
create_fallback "nethogs" "NH" "#00cccc"
create_fallback "mtr" "MTR" "#0066cc"
create_fallback "kismet" "K" "#6600cc"

# disk tools
create_fallback "fdisk" "FD" "#cc9900"
create_fallback "parted" "P" "#cc6600"
create_fallback "smart" "S" "#0066cc"
create_fallback "baobab" "DU" "#cc3300"

echo ""
echo "=========================================="
echo "  Creating NexUSB Branding"
echo "=========================================="
echo ""

# brand logo + app icon from bundled NexUSB-Logo.png
SOURCE_LOGO="$ICON_DIR/NexUSB-Logo.png"

if [ -f "$SOURCE_LOGO" ]; then
    echo "Using bundled NexUSB logo for branding..."
    convert "$SOURCE_LOGO" -resize 256x256 "$ICON_DIR/nex-logo.png"
    convert "$SOURCE_LOGO" -resize 256x256 "$ICON_DIR/nex-icon.png"
else
    echo "Warning: $SOURCE_LOGO not found; generating a text fallback logo"
    convert -size 400x80 xc:none \
        -font "DejaVu-Sans-Bold" -pointsize 48 \
        -fill "#66b3ff" -annotate +10+60 "Nex" \
        -fill "#0066cc" -annotate +140+60 "USB" \
        "$ICON_DIR/nex-logo.png"
    convert -size 256x256 xc:none \
        -fill "#001a33" -draw "roundrectangle 20,20 236,236 20,20" \
        -fill "#0066cc" -draw "roundrectangle 25,25 231,231 18,18" \
        -fill "#66b3ff" -font "DejaVu-Sans-Bold" -pointsize 120 \
        -gravity center -annotate +0+0 "N" \
        "$ICON_DIR/nex-icon.png"
fi

# background
echo "Creating background..."
convert -size 1920x1080 \
    -define gradient:angle=135 \
    gradient:'#001a33-#000814' \
    -blur 0x8 \
    "$ICON_DIR/background.png"

# grub selection highlights
echo "Creating GRUB theme elements..."
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

# category icons (128x128)
echo "Creating category icons..."
create_category() {
    local name="$1"
    local text="$2"
    local color="$3"
    
    convert -size 128x128 xc:none \
        -fill "$color" -draw "roundrectangle 10,10 118,118 15,15" \
        -fill white -font "DejaVu-Sans-Bold" -pointsize 48 \
        -gravity center -annotate +0+0 "$text" \
        "$ICON_DIR/${name}.png"
}

create_category "security" "🛡" "#cc0000"
create_category "recovery" "💾" "#00cc66"
create_category "disk" "💿" "#cc9900"
create_category "network" "🌐" "#0099cc"
create_category "remote" "🖥" "#0066cc"
create_category "system" "ℹ" "#6666cc"

echo ""
echo "=========================================="
echo "  Summary"
echo "=========================================="
echo ""
echo "✓ NexUSB branding created"
echo "✓ Tool logos downloaded/generated"
echo "✓ Category icons created"
echo "✓ GRUB theme elements created"
echo ""
echo "Locations:"
echo "  - Branding: $ICON_DIR/"
echo "  - Tool logos: $TOOLS_DIR/"
echo ""
echo "Total icons created: $(ls -1 $TOOLS_DIR/*.png 2>/dev/null | wc -l)"
echo ""
echo "To customize:"
echo "  1. Replace any PNG file in $TOOLS_DIR/"
echo "  2. Keep 64x64 size for consistency"
echo "  3. Rebuild NexUSB"
echo ""
