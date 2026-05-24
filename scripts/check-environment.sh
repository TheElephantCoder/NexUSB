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
echo "Checking required tools..."
check_command "debootstrap" "debootstrap"
check_command "grub-mkstandalone" "grub-pc-bin grub-efi-amd64-bin"
check_command "xorriso" "xorriso"
check_command "mksquashfs" "squashfs-tools"
check_command "mcopy" "mtools"
check_command "isohybrid" "isolinux"
check_command "parted" "parted"
check_command "mkfs.ntfs" "ntfs-3g"
check_command "mkfs.exfat" "exfat-utils"
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

# Check architecture
echo "Checking system architecture..."
ARCH=$(uname -m)
if [ "$ARCH" = "x86_64" ]; then
    echo -e "${GREEN}✓${NC} x86_64 architecture"
else
    echo -e "${RED}✗${NC} Unsupported architecture: $ARCH (need x86_64)"
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
if [ $ERRORS -eq 0 ] && [ $WARNINGS -eq 0 ]; then
    echo -e "${GREEN}✓ Environment is ready for building NexUSB${NC}"
    exit 0
elif [ $ERRORS -eq 0 ]; then
    echo -e "${YELLOW}⚠ Environment is ready with $WARNINGS warning(s)${NC}"
    exit 0
else
    echo -e "${RED}✗ Environment has $ERRORS error(s) and $WARNINGS warning(s)${NC}"
    echo ""
    echo "Please install missing dependencies:"
    echo "  sudo apt update"
    echo "  sudo apt install -y debootstrap grub-pc-bin grub-efi-amd64-bin \\"
    echo "      xorriso squashfs-tools mtools isolinux syslinux-utils \\"
    echo "      parted ntfs-3g exfat-utils imagemagick wget"
    exit 1
fi
