# Building NexUSB on Windows 11 (ARM64 / x64)

NexUSB is built with Linux tooling (`debootstrap`, `chroot`, GRUB, `xorriso`),
which cannot run natively on Windows. These scripts drive the build inside
**WSL2**, where a real Linux kernel is available. On **Windows 11 ARM64**, WSL2
runs an **arm64** Linux kernel, so an `arm64` build runs **natively**.

## Prerequisites

1. **Windows 11** (ARM64 or x64) with virtualization enabled.
2. **WSL2** with an Ubuntu distro:
   ```powershell
   wsl --install -d Ubuntu
   ```
   Reboot if prompted. On ARM64 Windows this installs the ARM64 Ubuntu build.
   Confirm it is WSL **2**:
   ```powershell
   wsl -l -v
   ```
3. A few GB of free space inside the WSL distro (the rootfs is staged there).

> Docker Desktop also supports Windows on Arm, but it is less reliable there
> than WSL2; these scripts use WSL2 directly.

## Build

From this `windows\` folder in PowerShell:

```powershell
# Minimal ISO for the host architecture (arm64 on ARM64 Windows)
.\Build-NexUSB.ps1

# Full multi-partition image, explicit arch
.\Build-NexUSB.ps1 -Target full -SizeGB 32 -Arch arm64

# Force x86_64 (runs under emulation on ARM64 hosts — slow)
.\Build-NexUSB.ps1 -Arch amd64
```

Or just double-click **`build-nexusb.cmd`** (minimal build, host arch).

Output ISO/IMG lands in the repo's **`dist\`** folder. Flash it with Rufus,
balenaEtcher, or `dd` from WSL.

## How it works

- `Build-NexUSB.ps1` — checks WSL2 + the distro, translates the repo path with
  `wslpath`, and runs the build inside WSL as root.
- `wsl-build.sh` — installs build deps (arch-appropriate GRUB), stages the
  source onto the WSL ext4 filesystem (debootstrap can't run on the `/mnt`
  DrvFs mount), runs `NEXUSB_ASSUME_YES=1 NEXUSB_ARCH=<arch> ./build-*.sh`, then
  copies artifacts back to `dist\`.

## Notes & caveats

- **`minimal` is the most reliable target.** The `full` build uses loop devices
  (`losetup`/`mount`); these work in WSL2 but are less tested than the ISO path.
- **Emulation is slow.** Building `amd64` on ARM64 Windows (or `arm64` on x64)
  runs under emulation. Match the arch to the host for native speed.
- **Boot targets.** arm64 media is UEFI-only and boots **arm64 UEFI hardware**
  (incl. many Windows-on-Arm devices' firmware). It does **not** boot Apple
  Silicon Macs. x86_64 media boots x86_64 PCs and Intel Macs.
- Avoid spaces in the repo path if possible; if unavoidable, keep the checkout
  somewhere simple like `C:\src\NexUSB`.
