#!/bin/bash
# Check build environment for NexUSB

set -e

echo "=== NexUSB Environment Check ==="
echo ""

# Color codes
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m'

ERRORS=0
WARNINGS=0

# Resolve target architecture settings (NEXUSB_ARCH, default amd64)
source "$(dirname "$0")/arch-config.sh"

# Function to check command
check_command() {
    local cmd=$1
    local package=$2
    
    if command -v "$cmd" &> /dev/null; then
        echo -e "${GREEN}✓${NC} $cmd found"
        return 0
    else
        echo -e "${RED}✗${NC} $cmd not found (install: $package)"
        ((ERRORS++))
        return 1
    fi
}

# Function to check optional command
check_optional() {
    local cmd=$1
    local package=$2
    
    if command -v "$cmd" &> /dev/null; then
        echo -e "${GREEN}✓${NC} $cmd found"
        return 0
    else
        echo -e "${YELLOW}⚠${NC} $cmd not found (optional: $package)"
        ((WARNINGS++))
        return 1
    fi
}

# Check if running as root
echo "Checking permissions..."
if [ "$EUID" -eq 0 ]; then
    echo -e "${YELLOW}⚠${NC} Running as root (build scripts will need sudo)"
else
    echo -e "${GREEN}✓${NC} Running as regular user"
fi
echo ""

# Check required commands
echo "Checking required tools (target arch: $NEXUSB_ARCH)..."
check_command "debootstrap" "debootstrap"
check_command "grub-mkstandalone" "grub2-common $GRUB_EFI_PKG"
check_command "xorriso" "xorriso"
check_command "mksquashfs" "squashfs-tools"
check_command "mcopy" "mtools"
if [ "$HAS_BIOS" -eq 1 ]; then
    check_command "isohybrid" "syslinux-utils"
fi
check_command "parted" "parted"
check_command "mkfs.ntfs" "ntfs-3g"
check_command "mkfs.exfat" "exfatprogs"
check_command "convert" "imagemagick"
check_command "wget" "wget"
echo ""

# Check optional tools
echo "Checking optional tools..."
check_optional "git" "git"
check_optional "python3" "python3"
check_optional "dialog" "dialog"
echo ""

# Check disk space
echo "Checking disk space..."
AVAILABLE=$(df -BG . | tail -1 | awk '{print $4}' | sed 's/G//')
AVAILABLE=${AVAILABLE:-0}
if [ "$AVAILABLE" -ge 50 ]; then
    echo -e "${GREEN}✓${NC} $AVAILABLE GB available (50+ GB recommended)"
elif [ "$AVAILABLE" -ge 20 ]; then
    echo -e "${YELLOW}⚠${NC} $AVAILABLE GB available (50+ GB recommended)"
    ((WARNINGS++))
else
    echo -e "${RED}✗${NC} Only $AVAILABLE GB available (need at least 20 GB)"
    ((ERRORS++))
fi
echo ""

# Check memory
echo "Checking system memory..."
TOTAL_MEM=$(free -g | awk '/^Mem:/{print $2}')
TOTAL_MEM=${TOTAL_MEM:-0}
if [ "$TOTAL_MEM" -ge 4 ]; then
    echo -e "${GREEN}✓${NC} ${TOTAL_MEM}GB RAM (4+ GB recommended)"
elif [ "$TOTAL_MEM" -ge 2 ]; then
    echo -e "${YELLOW}⚠${NC} ${TOTAL_MEM}GB RAM (4+ GB recommended)"
    ((WARNINGS++))
else
    echo -e "${RED}✗${NC} Only ${TOTAL_MEM}GB RAM (need at least 2 GB)"
    ((ERRORS++))
fi
echo ""

# Check internet connection
echo "Checking internet connection..."
if ping -c 1 8.8.8.8 &> /dev/null; then
    echo -e "${GREEN}✓${NC} Internet connection available"
else
    echo -e "${YELLOW}⚠${NC} No internet connection (needed for downloads)"
    ((WARNINGS++))
fi
echo ""

# Check architecture (host vs build target)
echo "Checking system architecture..."
ARCH=$(uname -m)
case "$NEXUSB_ARCH" in
    amd64) EXPECTED_HOST="x86_64" ;;
    arm64) EXPECTED_HOST="aarch64" ;;
esac
if [ "$ARCH" = "$EXPECTED_HOST" ]; then
    echo -e "${GREEN}✓${NC} host $ARCH matches target $NEXUSB_ARCH (native build)"
elif [ "$ARCH" = "x86_64" ] || [ "$ARCH" = "aarch64" ]; then
    echo -e "${YELLOW}⚠${NC} host is $ARCH but target is $NEXUSB_ARCH — cross-build"
    echo -e "    needs qemu-user-static + binfmt (or build in a native container)"
    ((WARNINGS++))
else
    echo -e "${RED}✗${NC} Unsupported host architecture: $ARCH"
    ((ERRORS++))
fi
echo ""

# Check OS
echo "Checking operating system..."
if [ -f /etc/os-release ]; then
    . /etc/os-release
    echo -e "${GREEN}✓${NC} $NAME $VERSION_ID"
    
    if [[ "$ID" == "ubuntu" ]] || [[ "$ID" == "debian" ]]; then
        echo -e "${GREEN}✓${NC} Supported OS"
    else
        echo -e "${YELLOW}⚠${NC} Untested OS (Ubuntu/Debian recommended)"
        ((WARNINGS++))
    fi
else
    echo -e "${YELLOW}⚠${NC} Unknown OS"
    ((WARNINGS++))
fi
echo ""

# Summary
echo "=== Summary ==="
if [ "$ERRORS" -eq 0 ] && [ "$WARNINGS" -eq 0 ]; then
    echo -e "${GREEN}✓ Environment is ready for building NexUSB${NC}"
    exit 0
elif [ "$ERRORS" -eq 0 ]; then
    echo -e "${YELLOW}⚠ Environment is ready with $WARNINGS warning(s)${NC}"
    exit 0
else
    echo -e "${RED}✗ Environment has $ERRORS error(s) and $WARNINGS warning(s)${NC}"
    echo ""
    echo "Please install missing dependencies:"
    echo "  sudo apt update"
    if [ "$HAS_BIOS" -eq 1 ]; then
        echo "  sudo apt install -y debootstrap grub2-common grub-pc-bin \\"
        echo "      grub-efi-amd64-bin xorriso squashfs-tools mtools \\"
        echo "      syslinux-utils parted ntfs-3g exfatprogs imagemagick wget"
    else
        echo "  sudo apt install -y debootstrap grub2-common grub-efi-arm64-bin \\"
        echo "      xorriso squashfs-tools mtools parted ntfs-3g exfatprogs \\"
        echo "      imagemagick wget"
    fi
    exit 1
fi
