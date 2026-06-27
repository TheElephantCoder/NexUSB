#!/usr/bin/env bash
#
# Build NexUSB on any host (macOS incl. Apple Silicon, Intel, or Linux) by
# running the existing Linux build inside an Ubuntu container of the target
# architecture.
#
# Usage:
#   docker/build-in-docker.sh [minimal|full] [usb_size_gb] [amd64|arm64]
#
# Examples:
#   docker/build-in-docker.sh                    # minimal amd64 ISO
#   docker/build-in-docker.sh minimal "" arm64   # minimal arm64 ISO
#   docker/build-in-docker.sh full 32 amd64      # full amd64 image
#
# Notes:
#   - The container platform matches the target arch. On Apple Silicon,
#     arm64 builds run NATIVELY (fast); amd64 builds run under emulation (slow),
#     and vice-versa on Intel.
#   - 'minimal' is the most reliable target. 'full' uses loop devices
#     (losetup/mount) which can be unreliable inside Docker Desktop's VM even
#     with --privileged; a full Linux VM is more dependable for that target.
#   - arm64 media is UEFI-only and targets arm64 UEFI hardware. It does NOT
#     boot on Apple Silicon Macs (no UEFI external boot).
set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
REPO_ROOT="$(cd "$SCRIPT_DIR/.." && pwd)"

TARGET="${1:-minimal}"
USB_SIZE="${2:-32}"
ARCH="${3:-amd64}"

if [[ "$TARGET" != "minimal" && "$TARGET" != "full" ]]; then
    echo "Usage: $0 [minimal|full] [usb_size_gb] [amd64|arm64]" >&2
    exit 1
fi
if [[ "$ARCH" != "amd64" && "$ARCH" != "arm64" ]]; then
    echo "Error: arch must be 'amd64' or 'arm64' (got '$ARCH')" >&2
    exit 1
fi
[ -n "$USB_SIZE" ] || USB_SIZE=32

IMAGE="nexusb-build:$ARCH"

if ! command -v docker >/dev/null 2>&1; then
    echo "Error: 'docker' not found. Install Docker Desktop, OrbStack, or colima." >&2
    exit 1
fi

if ! docker info >/dev/null 2>&1; then
    echo "Error: Docker daemon is not running. Start Docker Desktop/colima first." >&2
    exit 1
fi

echo ">> [1/2] Building $ARCH build-environment image ($IMAGE) ..."
docker build --platform "linux/$ARCH" --build-arg TARGETARCH="$ARCH" -t "$IMAGE" "$SCRIPT_DIR"

mkdir -p "$REPO_ROOT/dist"

echo ">> [2/2] Running '$TARGET' build (linux/$ARCH) ..."
if [ -n "${NEXUSB_ASSUME_YES:-}" ]; then
    # Non-interactive (e.g. launched from the NexUSB Flasher app): no TTY,
    # auto-confirm the build scripts' prompts.
    docker run --rm \
        --platform "linux/$ARCH" \
        --privileged \
        -e NEXUSB_ASSUME_YES=1 \
        -e NEXUSB_ARCH="$ARCH" \
        -v "$REPO_ROOT":/src:ro \
        -v "$REPO_ROOT/dist":/out \
        "$IMAGE" \
        container-build.sh "$TARGET" "$USB_SIZE"
else
    docker run --rm -it \
        --platform "linux/$ARCH" \
        --privileged \
        -e NEXUSB_ARCH="$ARCH" \
        -v "$REPO_ROOT":/src:ro \
        -v "$REPO_ROOT/dist":/out \
        "$IMAGE" \
        container-build.sh "$TARGET" "$USB_SIZE"
fi

echo ""
echo ">> Done. Artifacts are in: $REPO_ROOT/dist/"
