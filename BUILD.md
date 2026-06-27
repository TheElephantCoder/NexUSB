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

# Run the build script
sudo ./build.sh

# Output will be in dist/NexUSB.iso
```

## Building on macOS / Apple Silicon

macOS cannot run the build natively (no `debootstrap`/`chroot` for Linux
binaries, no loop devices, no ext4/ntfs tooling). Instead, build inside an
amd64 Ubuntu container. This works on Apple Silicon (under emulation), Intel
Macs, and Linux.

### Prerequisites

- A container runtime: Docker Desktop, OrbStack, or colima
- ~15GB free disk space for the minimal build

### Build

```bash
# Minimal ISO (recommended)
./docker/build-in-docker.sh

# or explicitly
./docker/build-in-docker.sh minimal

# Full multi-partition image (32GB)
./docker/build-in-docker.sh full 32
```

The container builds in its own filesystem and copies the finished artifacts
back to `dist/` on your Mac. The build prompts for confirmation, so run it in
an interactive terminal.

### How it works

- `docker/Dockerfile` — amd64 Ubuntu 22.04 image with all build dependencies.
- `docker/container-build.sh` — runs inside the container: stages the source,
  runs the build, copies artifacts to `dist/`.
- `docker/build-in-docker.sh` — host entry point: builds the image and runs it
  with `--platform linux/amd64 --privileged`, mounting the repo read-only and
  `dist/` for output.

### Caveats

- **Apple Silicon is slow.** The target is x86_64, so the amd64 container runs
  under emulation. `debootstrap` + `apt` are the slow steps; expect a minimal
  build to take significantly longer than on native amd64.
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
