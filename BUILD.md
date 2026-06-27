# Building NexUSB

NexUSB builds on Linux. The build creates an Ubuntu (jammy) rootfs with
`debootstrap`, runs `apt` inside a `chroot`, and assembles a bootable x86_64
image with GRUB, `squashfs-tools`, and `xorriso`. None of that runs natively on
macOS, so on a Mac you build inside a Linux container (see
[Building on macOS / Apple Silicon](#building-on-macos--apple-silicon)).

## Prerequisites

- Linux system (Ubuntu 22.04+ recommended)
- 50GB free disk space
- Required packages: `grub-pc-bin`, `grub-efi-amd64-bin`, `xorriso`, `squashfs-tools`, `mtools`

## Install Dependencies

```bash
sudo apt update
sudo apt install -y grub-pc-bin grub-efi-amd64-bin xorriso squashfs-tools mtools isolinux syslinux-utils
```

## Build Process

```bash
# Clone the repository
git clone https://github.com/TheElephantCoder/NexUSB.git
cd NexUSB

# Run the build script (x86_64 by default)
sudo ./build.sh

# Output will be in dist/NexUSB.iso
```

## Architecture (x86_64 / arm64)

NexUSB builds for **x86_64 (amd64)** by default and also supports **arm64**.
Select the target with the `NEXUSB_ARCH` environment variable:

```bash
sudo NEXUSB_ARCH=amd64 ./build.sh          # x86_64 (default)
sudo NEXUSB_ARCH=arm64 ./build-minimal.sh  # arm64
```

Differences handled automatically (see `scripts/arch-config.sh`):
- debootstrap arch + mirror (`archive.ubuntu.com` vs `ports.ubuntu.com`)
- GRUB target (`x86_64-efi` + Legacy BIOS, vs `arm64-efi` UEFI-only)
- removable EFI binary (`BOOTX64.EFI` vs `BOOTAA64.EFI`)

**Boot targets — important:**
- x86_64 media boots x86_64 PCs and Intel Macs (UEFI + Legacy BIOS; disable
  Secure Boot / allow external boot).
- arm64 media is **UEFI-only** and targets **arm64 UEFI hardware** (some arm64
  servers/laptops, Windows-on-ARM devices). It does **not** boot on Apple
  Silicon Macs — those use a custom (non-UEFI) boot process, so no external
  GRUB USB will boot them, regardless of architecture.
- **Cross-arch builds** (e.g. building arm64 on an x86_64 host) need
  `qemu-user-static` + binfmt; building on a matching host — or the matching
  container below — is simplest.


## Building on macOS / Apple Silicon

macOS cannot run the build natively (no `debootstrap`/`chroot` for Linux
binaries, no loop devices, no ext4/ntfs tooling). Instead, build inside an
Ubuntu container of the target architecture. This works on Apple Silicon,
Intel Macs, and Linux.

### Prerequisites

- A container runtime: Docker Desktop, OrbStack, or colima
- ~15GB free disk space for the minimal build

### Build

```bash
# Minimal ISO (recommended), amd64
./docker/build-in-docker.sh

# Minimal ISO, arm64  (native + fast on Apple Silicon)
./docker/build-in-docker.sh minimal "" arm64

# Full multi-partition image (32GB), amd64
./docker/build-in-docker.sh full 32 amd64
```

The container platform matches the target arch, so on Apple Silicon an **arm64**
build runs natively (fast) while an **amd64** build runs under emulation (slow);
the reverse is true on Intel. The container builds in its own filesystem and
copies finished artifacts back to `dist/`. The build prompts for confirmation,
so run it in an interactive terminal.

### How it works

- `docker/Dockerfile` — multi-arch Ubuntu 22.04 image; `--build-arg TARGETARCH`
  selects the right GRUB packages (BIOS+UEFI for amd64, UEFI-only for arm64).
- `docker/container-build.sh` — runs inside the container: stages the source,
  runs the build, copies artifacts to `dist/`.
- `docker/build-in-docker.sh` — host entry point: `[minimal|full] [size]
  [amd64|arm64]`; builds the image for `linux/<arch>` and runs it `--privileged`
  with `NEXUSB_ARCH` set, mounting the repo read-only and `dist/` for output.

### Caveats

- **Emulated builds are slow.** Building a non-native arch (amd64 on Apple
  Silicon, or arm64 on Intel) runs the container under emulation; `debootstrap`
  and `apt` are the slow steps, so expect it to take significantly longer than
  a native build.
- **`minimal` is the reliable target.** The `full` build's
  `create-multiboot.sh` uses `losetup`/`mount` + ext4/ntfs/exfat formatting,
  which can fail inside Docker Desktop's VM even with `--privileged`. For the
  full image, a dedicated Linux VM (Lima/UTM/colima VM) is more dependable.
- Not yet validated end-to-end in CI — the container scripts are syntax-checked
  but the full build run has not been executed in this environment.

## Build Process (native Linux)

```bash
# Clone the repository
git clone https://github.com/TheElephantCoder/NexUSB.git
cd NexUSB

# Run the build script
sudo ./build.sh

# Output will be in dist/NexUSB.iso
```

Edit `config/tools.conf` to add/remove tools
Edit `theme/` directory to customize the boot menu appearance

## Flashing to USB

### Using Ventoy (Recommended)
1. Install Ventoy on your USB drive
2. Copy the ISO to the USB drive
3. Boot and select NexUSB

### Using Rufus
1. Open Rufus
2. Select your USB drive
3. Select the NexUSB.iso
4. Click Start
