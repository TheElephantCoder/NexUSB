#!/bin/bash
# NexUSB Full Build Script
# Builds complete bootable USB system with all tools

set -e
set -o pipefail

# Configuration
BUILD_DIR="build"
DIST_DIR="dist"
ISO_NAME="NexUSB.iso"
IMG_NAME="NexUSB.img"
WORK_DIR="$BUILD_DIR/work"
ISO_DIR="$BUILD_DIR/iso"
USB_SIZE=${1:-32}  # Default 32GB, can specify different size
LOG_FILE="build.log"

# Colors
BLUE='\033[0;34m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
RED='\033[0;31m'
NC='\033[0m'

# Logging function
log() {
    echo "[$(date +'%Y-%m-%d %H:%M:%S')] $1" | tee -a "$LOG_FILE"
}

# Error handler
error_exit() {
    echo -e "${RED}Error: $1${NC}" >&2
    log "ERROR: $1"
    exit 1
}

# Cleanup on exit
cleanup() {
    if [ $? -ne 0 ]; then
        echo -e "${RED}Build failed! Check $LOG_FILE for details${NC}"
    fi
}
trap cleanup EXIT

# Banner
echo "╔════════════════════════════════════════════════════════╗"
echo "║           NexUSB Full Build System                 ║"
echo "║     Professional Bootable USB Rescue Toolkit           ║"
echo "╚════════════════════════════════════════════════════════╝"
echo ""

# Check if running as root
if [ "$EUID" -ne 0 ]; then 
    error_exit "Please run as root (sudo ./build.sh)"
fi

# Check environment
if [ -f "scripts/check-environment.sh" ]; then
    echo "Checking build environment..."
    if ! bash scripts/check-environment.sh; then
        error_exit "Environment check failed"
    fi
    echo ""
fi

# Display configuration
echo -e "${YELLOW}Build Configuration:${NC}"
echo "  Target USB Size: ${USB_SIZE}GB"
echo "  Build Directory: $BUILD_DIR"
echo "  Output Directory: $DIST_DIR"
echo "  Log File: $LOG_FILE"
echo "  Estimated Time: 60-90 minutes"
echo "  Estimated Size: ~10GB"
echo ""
if [ -z "${NEXUSB_ASSUME_YES:-}" ]; then
    read -p "Continue? (y/n) " -n 1 -r
    echo
    if [[ ! $REPLY =~ ^[Yy]$ ]]; then
        echo "Build cancelled"
        exit 0
    fi
fi

# Start logging
log "=== NexUSB Build Started ==="
log "Configuration: ${USB_SIZE}GB target size"

echo -e "${BLUE}[1/10] Cleaning previous builds...${NC}"
rm -rf "$BUILD_DIR" "$DIST_DIR"
mkdir -p "$WORK_DIR" "$ISO_DIR" "$DIST_DIR"

echo -e "${BLUE}[1.5/10] Downloading tool logos...${NC}"
if [ -f "assets/download-logos.sh" ]; then
    chmod +x assets/download-logos.sh
    ./assets/download-logos.sh
else
    echo "Warning: Logo script not found, will use fallbacks"
fi

echo -e "${BLUE}[2/10] Setting up base system...${NC}"
./scripts/setup-base.sh "$WORK_DIR"

echo -e "${BLUE}[3/10] Installing Linux tools...${NC}"
./scripts/install-tools.sh "$WORK_DIR"

echo -e "${BLUE}[3.5/10] Installing professional GUI...${NC}"
./scripts/install-gui.sh "$WORK_DIR"

echo -e "${BLUE}[4/10] Downloading Windows tools...${NC}"
./scripts/download-windows-tools.sh

echo -e "${BLUE}[5/10] Downloading essential ISOs...${NC}"
./scripts/download-isos.sh

echo -e "${BLUE}[6/10] Configuring boot environment...${NC}"
./scripts/setup-boot.sh "$ISO_DIR" "$WORK_DIR"

echo -e "${BLUE}[7/10] Applying theme...${NC}"
./scripts/apply-theme.sh "$ISO_DIR"

echo -e "${BLUE}[8/10] Creating bootable ISO...${NC}"
./scripts/create-iso.sh "$ISO_DIR" "$DIST_DIR/$ISO_NAME"

echo -e "${BLUE}[9/10] Creating multi-partition USB image...${NC}"
log "Step 9: Creating USB image"
./scripts/create-multiboot.sh "$DIST_DIR/$IMG_NAME" "$USB_SIZE"

echo -e "${BLUE}[10/10] Generating checksums...${NC}"
log "Step 10: Generating checksums"
cd "$DIST_DIR"
sha256sum "$ISO_NAME" > "$ISO_NAME.sha256"
sha256sum "$IMG_NAME" > "$IMG_NAME.sha256"
cd ..

# Calculate sizes
ISO_SIZE=$(du -h "$DIST_DIR/$ISO_NAME" 2>/dev/null | cut -f1 || echo "N/A")
IMG_SIZE=$(du -h "$DIST_DIR/$IMG_NAME" 2>/dev/null | cut -f1 || echo "N/A")

echo ""
echo -e "${GREEN}╔════════════════════════════════════════════════════════╗${NC}"
echo -e "${GREEN}║          NexUSB Build Complete!                    ║${NC}"
echo -e "${GREEN}╚════════════════════════════════════════════════════════╝${NC}"
echo ""
echo "Output files:"
echo "  ISO (single boot): $DIST_DIR/$ISO_NAME ($ISO_SIZE)"
echo "  IMG (multi-partition): $DIST_DIR/$IMG_NAME ($IMG_SIZE)"
echo "  Checksums: $DIST_DIR/*.sha256"
echo "  Build log: $LOG_FILE"
echo ""
echo "Next steps:"
echo "  1. Verify: sha256sum -c $DIST_DIR/$ISO_NAME.sha256"
echo "  2. Flash: sudo dd if=$DIST_DIR/$ISO_NAME of=/dev/sdX bs=4M status=progress"
echo "  3. Or use Ventoy/Rufus (see docs/FLASHING.md)"
echo ""
echo "Documentation: BUILD.md, docs/FLASHING.md, docs/MALWARE_SCANNING.md"

log "=== Build completed successfully ==="
log "ISO size: $ISO_SIZE, IMG size: $IMG_SIZE"
