# syntax=docker/dockerfile:1
#
# NexUSB build environment (multi-arch).
#
# The build executes target-arch binaries inside a chroot (debootstrap + apt),
# so the container platform must match the target architecture. The caller sets
# it via `docker build --platform linux/<arch>`; BuildKit then provides
# TARGETARCH (amd64 | arm64), which selects the right GRUB packages below.
#
# On Apple Silicon, `--platform linux/arm64` runs natively; `linux/amd64` runs
# under emulation. Base is ubuntu:22.04 (jammy) to match the debootstrap suite.
FROM ubuntu:22.04

ARG TARGETARCH
ENV DEBIAN_FRONTEND=noninteractive

# Architecture-independent build dependencies, plus arch-specific GRUB:
#   amd64 -> Legacy BIOS (grub-pc-bin + syslinux) and UEFI (grub-efi-amd64-bin)
#   arm64 -> UEFI only (grub-efi-arm64-bin); no BIOS / syslinux on arm64
RUN apt-get update && apt-get install -y --no-install-recommends \
        debootstrap \
        grub2-common \
        xorriso \
        squashfs-tools \
        mtools \
        parted \
        dosfstools \
        e2fsprogs \
        ntfs-3g \
        exfatprogs \
        imagemagick \
        ca-certificates \
        wget \
    && if [ "$TARGETARCH" = "arm64" ]; then \
           apt-get install -y --no-install-recommends grub-efi-arm64-bin ; \
       else \
           apt-get install -y --no-install-recommends \
               grub-pc-bin grub-efi-amd64-bin isolinux syslinux syslinux-common syslinux-utils ; \
       fi \
    && rm -rf /var/lib/apt/lists/*

# In-container orchestration script (copies source in, builds, copies ISO out).
COPY container-build.sh /usr/local/bin/container-build.sh
RUN chmod +x /usr/local/bin/container-build.sh

WORKDIR /build
