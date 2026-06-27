#!/usr/bin/env bash
# Runs inside the build container (not on the host).
# /src is the repo, mounted read-only. We copy it to /build first because
# debootstrap can't mknod / set ownership on the Docker bind mount. Finished
# artifacts go to /out, which maps back to <repo>/dist.
set -euo pipefail

TARGET="${1:-minimal}"
USB_SIZE="${2:-32}"

if [ ! -d /src ]; then
    echo "Error: /src is not mounted. Run this via docker/build-in-docker.sh." >&2
    exit 1
fi

echo ">> Staging source into container-local /build ..."
mkdir -p /build
# Exclude VCS metadata and any prior build output from the host.
tar -C /src \
    --exclude='./.git' \
    --exclude='./build' \
    --exclude='./build-minimal' \
    --exclude='./dist' \
    -cf - . | tar -C /build -xf -

cd /build

# Ensure scripts are executable regardless of how they arrived from the host.
find /build -type f -name '*.sh' -exec chmod +x {} +
chmod +x /build/gui/*.py 2>/dev/null || true

echo ">> Starting '$TARGET' build ..."
case "$TARGET" in
    minimal)
        ./build-minimal.sh
        ;;
    full)
        ./build.sh "$USB_SIZE"
        ;;
    *)
        echo "Error: unknown target '$TARGET' (expected 'minimal' or 'full')" >&2
        exit 1
        ;;
esac

echo ">> Copying artifacts to /out ..."
mkdir -p /out
if ! cp -av dist/. /out/ 2>/dev/null; then
    echo "Error: no artifacts found in /build/dist" >&2
    exit 1
fi

echo ">> Build finished. Artifacts copied to the host dist/ directory."
