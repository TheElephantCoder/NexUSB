# syntax=docker/dockerfile:1
#
# NexUSB build environment.
#
# The target product is an x86_64 bootable image, and the build executes amd64
# binaries inside a chroot (debootstrap + apt). The image is therefore pinned to
# linux/amd64. On Apple Silicon this runs under emulation (QEMU/Rosetta) — it
# works but is slower than native.
#
# Base is ubuntu:22.04 (jammy) to match the suite that the setup scripts
# bootstrap with debootstrap.
FROM --platform=linux/amd64 ubuntu:22.04

ENV DEBIAN_FRONTEND=noninteractive

# Build dependencies. This mirrors the tools that scripts/check-environment.sh
# verifies, plus the filesystem/loop tooling used by create-multiboot.sh.
RUN apt-get update && apt-get install -y --no-install-recommends \
        debootstrap \
        grub2-common \
        grub-pc-bin \
        grub-efi-amd64-bin \
        xorriso \
        squashfs-tools \
        mtools \
        isolinux \
        syslinux \
        syslinux-common \
        syslinux-utils \
        parted \
        dosfstools \
        e2fsprogs \
        ntfs-3g \
        exfatprogs \
        imagemagick \
        ca-certificates \
        wget \
    && rm -rf /var/lib/apt/lists/*

# In-container orchestration script (copies source in, builds, copies ISO out).
COPY container-build.sh /usr/local/bin/container-build.sh
RUN chmod +x /usr/local/bin/container-build.sh

WORKDIR /build
