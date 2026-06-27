#!/bin/bash
# full build, all tools

set -e
set -o pipefail

# config — build/output dirs can point at another disk via env
BUILD_DIR="${NEXUSB_BUILD_DIR:-build}"
DIST_DIR="${NEXUSB_DIST_DIR:-dist}"
ISO_NAME="NexUSB.iso"
IMG_NAME="NexUSB.img"
WORK_DIR="$BUILD_DIR/work"
ISO_DIR="$BUILD_DIR/iso"
USB_SIZE=${1:-32}  # gb, override via arg
LOG_FILE="build.log"

# arch settings (NEXUSB_ARCH, default amd64)
source "$(dirname "$0")/scripts/arch-config.sh"

# colors
BLUE='\033[0;34m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
RED='\033[0;31m'
NC='\033[0m'

# log to file + stdout
log() {
    echo "[$(date +'%Y-%m-%d %H:%M:%S')] $1" | tee -a "$LOG_FILE"
}

# bail out
error_exit() {
    echo -e "${RED}Error: $1${NC}" >&2
    log "ERROR: $1"
    exit 1
}

# refuse to rm -rf a dangerous path (these dirs get wiped each run)
guard_dir() {
    case "$1" in
        ""|"/"|"."|"..") error_exit "Refusing to use '$1' as a build/output dir" ;;
    esac
    [ "$1" = "$HOME" ] && error_exit "Refusing build/output dir = \$HOME"
    if command -v mountpoint >/dev/null 2>&1 && mountpoint -q "$1" 2>/dev/null; then
        error_exit "'$1' is a mount root — point NEXUSB_BUILD_DIR/NEXUSB_DIST_DIR at a subdirectory on that disk"
    fi
}

# note failure on exit
cleanup() {
    if [ $? -ne 0 ]; then
        echo -e "${RED}Build failed! Check $LOG_FILE for details${NC}"
    fi
}
trap cleanup EXIT

echo "╔════════════════════════════════════════════════════════╗"
echo "║           NexUSB Full Build System                 ║"
echo "║     Professional Bootable USB Rescue Toolkit           ║"
echo "╚════════════════════════════════════════════════════════╝"
echo ""

# need root
if [ "$EUID" -ne 0 ]; then 
    error_exit "Please run as root (sudo ./build.sh)"
fi

# preflight checks
if [ -f "scripts/check-environment.sh" ]; then
    echo "Checking build environment..."
    if ! bash scripts/check-environment.sh; then
        error_exit "Environment check failed"
    fi
    echo ""
fi

# show config
echo -e "${YELLOW}Build Configuration:${NC}"
echo "  Target USB Size: ${USB_SIZE}GB"
echo "  Target architecture: $NEXUSB_ARCH"
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

# log start
log "=== NexUSB Build Started ==="
log "Configuration: ${USB_SIZE}GB target size"

echo -e "${BLUE}[1/10] Cleaning previous builds...${NC}"
guard_dir "$BUILD_DIR"
rm -rf "$BUILD_DIR"
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
( cd "$DIST_DIR" && sha256sum "$ISO_NAME" > "$ISO_NAME.sha256" )
( cd "$DIST_DIR" && sha256sum "$IMG_NAME" > "$IMG_NAME.sha256" )

# output sizes
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
