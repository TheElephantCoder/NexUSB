#!/usr/bin/env bash
#
# Build NexUSB on any host (macOS incl. Apple Silicon, Intel, or Linux) by
# running the existing Linux build inside an amd64 Ubuntu container.
#
# Usage:
#   docker/build-in-docker.sh [minimal|full] [usb_size_gb]
#
# Examples:
#   docker/build-in-docker.sh                # minimal ISO (recommended)
#   docker/build-in-docker.sh minimal        # minimal ISO
#   docker/build-in-docker.sh full 32        # full 32GB multi-partition image
#
# Notes:
#   - Apple Silicon runs the amd64 image under emulation; expect it to be slow.
#   - 'minimal' is the most reliable target. 'full' uses loop devices
#     (losetup/mount) which can be unreliable inside Docker Desktop's VM even
#     with --privileged; a full Linux VM is more dependable for that target.
set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
REPO_ROOT="$(cd "$SCRIPT_DIR/.." && pwd)"

IMAGE="nexusb-build:latest"
TARGET="${1:-minimal}"
USB_SIZE="${2:-32}"

if [[ "$TARGET" != "minimal" && "$TARGET" != "full" ]]; then
    echo "Usage: $0 [minimal|full] [usb_size_gb]" >&2
    exit 1
fi

if ! command -v docker >/dev/null 2>&1; then
    echo "Error: 'docker' not found. Install Docker Desktop, OrbStack, or colima." >&2
    exit 1
fi

if ! docker info >/dev/null 2>&1; then
    echo "Error: Docker daemon is not running. Start Docker Desktop/colima first." >&2
    exit 1
fi

echo ">> [1/2] Building amd64 build-environment image ($IMAGE) ..."
docker build --platform linux/amd64 -t "$IMAGE" "$SCRIPT_DIR"

mkdir -p "$REPO_ROOT/dist"

echo ">> [2/2] Running '$TARGET' build (linux/amd64; emulated on Apple Silicon) ..."
if [ -n "${NEXUSB_ASSUME_YES:-}" ]; then
    # Non-interactive (e.g. launched from the NexUSB Flasher app): no TTY,
    # auto-confirm the build scripts' prompts.
    docker run --rm \
        --platform linux/amd64 \
        --privileged \
        -e NEXUSB_ASSUME_YES=1 \
        -v "$REPO_ROOT":/src:ro \
        -v "$REPO_ROOT/dist":/out \
        "$IMAGE" \
        container-build.sh "$TARGET" "$USB_SIZE"
else
    docker run --rm -it \
        --platform linux/amd64 \
        --privileged \
        -v "$REPO_ROOT":/src:ro \
        -v "$REPO_ROOT/dist":/out \
        "$IMAGE" \
        container-build.sh "$TARGET" "$USB_SIZE"
fi

echo ""
echo ">> Done. Artifacts are in: $REPO_ROOT/dist/"
