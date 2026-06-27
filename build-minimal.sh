#!/bin/bash
set -e

echo "=== NexUSB Minimal ISO Builder ==="
echo "Building lightweight bootable ISO for quick deployment"
echo ""

# Configuration
BUILD_DIR="build-minimal"
DIST_DIR="dist"
ISO_NAME="NexUSB-Minimal.iso"
WORK_DIR="$BUILD_DIR/work"
ISO_DIR="$BUILD_DIR/iso"

# Colors
BLUE='\033[0;34m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m'

# Check if running as root
if [ "$EUID" -ne 0 ]; then 
    echo -e "${YELLOW}Please run as root (sudo ./build-minimal.sh)${NC}"
    exit 1
fi

echo -e "${YELLOW}Minimal Build Configuration:${NC}"
echo "  Target Size: ~2GB ISO"
echo "  Includes: Essential rescue tools only"
echo "  Boot: UEFI + Legacy BIOS"
echo ""
if [ -z "${NEXUSB_ASSUME_YES:-}" ]; then
    read -p "Continue? (y/n) " -n 1 -r
    echo
    if [[ ! $REPLY =~ ^[Yy]$ ]]; then
        exit 1
    fi
fi

echo -e "${BLUE}[1/7] Cleaning previous builds...${NC}"
rm -rf "$BUILD_DIR"
mkdir -p "$WORK_DIR" "$ISO_DIR" "$DIST_DIR"

echo -e "${BLUE}[1.5/7] Downloading tool logos...${NC}"
if [ -f "assets/download-logos.sh" ]; then
    chmod +x assets/download-logos.sh
    ./assets/download-logos.sh
else
    echo "Warning: Logo script not found, will use fallbacks"
fi

echo -e "${BLUE}[2/7] Setting up minimal base system...${NC}"
./scripts/setup-minimal-base.sh "$WORK_DIR"

echo -e "${BLUE}[3/7] Installing essential tools only...${NC}"
./scripts/install-minimal-tools.sh "$WORK_DIR"

echo -e "${BLUE}[3.5/7] Installing professional GUI...${NC}"
./scripts/install-gui.sh "$WORK_DIR"

echo -e "${BLUE}[4/7] Configuring boot environment...${NC}"
./scripts/setup-boot.sh "$ISO_DIR" "$WORK_DIR"

echo -e "${BLUE}[5/7] Applying theme...${NC}"
./scripts/apply-theme.sh "$ISO_DIR"

echo -e "${BLUE}[6/7] Creating minimal ISO...${NC}"
./scripts/create-iso.sh "$ISO_DIR" "$DIST_DIR/$ISO_NAME"

echo -e "${BLUE}[7/7] Generating checksum...${NC}"
cd "$DIST_DIR"
sha256sum "$ISO_NAME" > "$ISO_NAME.sha256"
cd ..

echo ""
echo -e "${GREEN}╔════════════════════════════════════════════════════════╗${NC}"
echo -e "${GREEN}║       NexUSB Minimal Build Complete!                ║${NC}"
echo -e "${GREEN}╚════════════════════════════════════════════════════════╝${NC}"
echo ""
echo "Output file: $DIST_DIR/$ISO_NAME"
echo "Size: ~2GB (compared to 10GB+ full build)"
echo ""
echo "Included tools:"
echo "  - ClamAV antivirus"
echo "  - TestDisk/PhotoRec recovery"
echo "  - GParted disk management"
echo "  - Network tools (nmap, wireshark)"
echo "  - Remote access (TeamViewer, AnyDesk, RDP)"
echo "  - Basic system utilities"
echo ""
echo "Flash to USB: sudo dd if=$DIST_DIR/$ISO_NAME of=/dev/sdX bs=4M"
