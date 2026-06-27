# NexUSB

[![License: MIT](https://img.shields.io/badge/License-MIT-blue.svg)](LICENSE)

A bootable USB rescue toolkit. It boots a live Linux environment with a large
set of tools for malware scanning, data recovery, disk and partition work,
network diagnostics, and remote access, and can also carry Windows portable
tools and a collection of other rescue ISOs.

Builds for x86_64 and arm64. The build runs on Linux, or from macOS/Windows via
the container and WSL2 helpers described below.

## What's on it

- **Malware scanning** — ClamAV, chkrootkit, rkhunter, Lynis, plus Windows
  scanners (AdwCleaner, McAfee Stinger, Kaspersky VRT, and more by manual
  download).
- **Data recovery** — TestDisk, PhotoRec, ddrescue, Clonezilla.
- **Disk tools** — GParted, parted, fdisk, SMART monitoring, secure erase.
- **Network** — Wireshark, nmap, tcpdump, Wi-Fi tools.
- **Remote access** — Remmina (RDP/VNC), xrdp, x11vnc, OpenSSH, TeamViewer,
  AnyDesk.
- **Password reset** — chntpw for Windows accounts, Linux password reset.
- A GTK GUI that starts automatically, plus text menus per category.

There are two builds: a **minimal** ISO (~2 GB, the essentials) and a **full**
image (~32 GB) that adds the rest of the Linux tools, Windows portable apps, and
a multiboot ISO collection.

## Building

The build is Linux-based (debootstrap, GRUB, xorriso). You can run it natively
on Linux, or drive it from macOS/Windows. Pick the target architecture with
`NEXUSB_ARCH` (`amd64` is the default; `arm64` is also supported).

### On Linux

```bash
sudo ./build-minimal.sh                  # ~2 GB ISO, x86_64
sudo NEXUSB_ARCH=arm64 ./build-minimal.sh
sudo ./build.sh 32                       # full 32 GB image
```

Install the dependencies first (or run `scripts/check-environment.sh` to see
what's missing):

```bash
sudo apt install -y debootstrap grub2-common grub-pc-bin grub-efi-amd64-bin \
    xorriso squashfs-tools mtools syslinux-utils parted ntfs-3g exfatprogs \
    imagemagick wget
```

### On macOS or any host (Docker)

```bash
./docker/build-in-docker.sh minimal "" arm64    # native arm64 on Apple Silicon
./docker/build-in-docker.sh full 32 amd64
```

The container's architecture matches the target, so on Apple Silicon an arm64
build runs natively and an amd64 build runs emulated (slower).

### On Windows 11 (via WSL2)

```powershell
.\windows\Build-NexUSB.ps1 -Target minimal -Arch arm64
```

See [windows/README.md](windows/README.md) for setup. On Windows 11 ARM64, WSL2
provides an arm64 Linux kernel, so the arm64 build runs natively.

> **Windows 11 ARM in a VM on Apple Silicon — unverified.** Running the Windows
> build inside a Windows 11 ARM virtual machine on an M-series Mac is not a path
> I've confirmed. WSL2 needs nested virtualization exposed to a *Windows* guest;
> Apple added nested virtualization on M3/M4 with macOS 15, but it landed for
> Linux guests first and Windows-guest WSL2 support depends on the VM software
> and is unreliable today. If you only want an arm64 image, use the Docker
> build above instead — it runs natively on the Mac. If you do get the VM route
> working end to end, let me know and it'll be documented properly.

More detail is in [BUILD.md](BUILD.md).

## Flashing

```bash
sudo dd if=dist/NexUSB-Minimal.iso of=/dev/sdX bs=4M status=progress
```

On macOS there's also a small companion app, **NexUSB Flasher** (in
`NexUSB-Flasher/`, kept in its own repository), which can build images via
Docker and flash them to a USB drive through a step-by-step interface. On
Windows, Rufus or balenaEtcher work.

## Requirements

**Build host:** Linux (Ubuntu 22.04+/Debian 11+) for a native build, or any host
with Docker, or Windows 11 with WSL2. About 50 GB free during a full build.

**Target machine:**
- x86_64 (UEFI or Legacy BIOS) or arm64 (UEFI only).
- 2 GB RAM minimum, 4 GB USB for the minimal build (32 GB+ for full).

arm64 media targets arm64 UEFI hardware (arm64 laptops/servers, some
Windows-on-Arm devices). It does not boot Apple Silicon Macs — those don't boot
external UEFI media.

For x86_64 machines with Secure Boot, disable it (or allow external boot) since
the GRUB image isn't signed.

## Documentation

- [Build instructions](BUILD.md)
- [Minimal ISO](docs/MINIMAL_ISO.md)
- [What's included](docs/WHAT_IS_INCLUDED.md)
- [Malware scanning](docs/MALWARE_SCANNING.md)
- [Windows tools](docs/WINDOWS_TOOLS_USAGE.md)
- [Flashing](docs/FLASHING.md)
- [Tools reference](docs/TOOLS.md)
- [Size guide](docs/SIZE_GUIDE.md)
- [FAQ](docs/FAQ.md)

## Layout

```
build.sh / build-minimal.sh   build orchestrators
scripts/                      build steps (base, tools, boot, iso, multiboot, …)
                              arch-config.sh resolves amd64/arm64 settings
autorun/                      in-live dialog menus (nex-*.sh)
gui/nex-gui.py                GTK GUI
config/                       tool / ISO / Windows-tool lists
theme/                        GRUB theme (theme/nex/)
docker/                       containerized build (any host)
windows/                      Windows 11 WSL2 build entry points
assets/                       branding + icon generation
```

## Customizing

- Linux tools: edit `config/tools.conf` (`CATEGORY|TOOL|PACKAGE|DESCRIPTION`).
- Windows apps: edit `config/windows-tools.conf`.
- ISOs: drop files under `build/isos/<category>/`.
- Theme: edit `theme/nex/` and `theme/grub.cfg`.

## Contributing

Bug reports and pull requests are welcome — see [CONTRIBUTING.md](CONTRIBUTING.md).

## License

MIT — see [LICENSE](LICENSE).

## Disclaimer

Intended for system administration, recovery, and authorized security work
only. Make sure you have permission before using these tools on any system you
don't own.
