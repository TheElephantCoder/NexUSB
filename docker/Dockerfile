# syntax=docker/dockerfile:1
# multi-arch build env. platform must match target arch; TARGETARCH picks grub pkgs below
FROM ubuntu:22.04

ARG TARGETARCH
ENV DEBIAN_FRONTEND=noninteractive

# common deps + arch-specific grub. amd64: bios+uefi, arm64: uefi only
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

# build script that runs inside the container
COPY container-build.sh /usr/local/bin/container-build.sh
RUN chmod +x /usr/local/bin/container-build.sh

WORKDIR /build
