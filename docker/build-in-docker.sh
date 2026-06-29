#!/usr/bin/env bash
# build NexUSB on any host by running the linux build in an ubuntu container
#
# usage: docker/build-in-docker.sh [minimal|full] [usb_size_gb] [amd64|arm64]
#
# notes:
#   - container platform matches target arch; native arch is fast, other is emulated
#   - 'full' uses loop devices, flaky under docker desktop; prefer a real linux vm
#   - arm64 media is uefi-only, does NOT boot apple silicon macs
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

# output dir; can point at another disk via NEXUSB_DIST_DIR
OUT_DIR="${NEXUSB_DIST_DIR:-$REPO_ROOT/dist}"

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

mkdir -p "$OUT_DIR"

echo ">> [2/2] Running '$TARGET' build (linux/$ARCH) ..."
if [ -n "${NEXUSB_ASSUME_YES:-}" ]; then
    # no tty (e.g. CI or a non-interactive shell); auto-confirm prompts
    docker run --rm \
        --platform "linux/$ARCH" \
        --privileged \
        -e NEXUSB_ASSUME_YES=1 \
        -e NEXUSB_ARCH="$ARCH" \
        -e NEXUSB_SKIP_PROPRIETARY="${NEXUSB_SKIP_PROPRIETARY:-}" \
        -v "$REPO_ROOT":/src:ro \
        -v "$OUT_DIR":/out \
        "$IMAGE" \
        container-build.sh "$TARGET" "$USB_SIZE"
else
    docker run --rm -it \
        --platform "linux/$ARCH" \
        --privileged \
        -e NEXUSB_ARCH="$ARCH" \
        -e NEXUSB_SKIP_PROPRIETARY="${NEXUSB_SKIP_PROPRIETARY:-}" \
        -v "$REPO_ROOT":/src:ro \
        -v "$OUT_DIR":/out \
        "$IMAGE" \
        container-build.sh "$TARGET" "$USB_SIZE"
fi

echo ""
echo ">> Done. Artifacts are in: $OUT_DIR/"
