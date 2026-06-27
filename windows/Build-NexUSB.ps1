#Requires -Version 5.1
<#
.SYNOPSIS
    Build NexUSB on Windows 11 (ARM64 or x64) by driving the Linux build inside
    WSL2.

.DESCRIPTION
    The NexUSB build is Linux-only (debootstrap/chroot/GRUB/xorriso). This script
    runs it inside a WSL2 Ubuntu distribution. On Windows 11 ARM64, WSL2 runs an
    arm64 Linux kernel, so 'arm64' builds run natively. The build is staged onto
    the WSL filesystem and the finished ISO/IMG is copied back to the repo's
    dist\ folder on Windows.

.PARAMETER Target
    'minimal' (default) or 'full'.

.PARAMETER SizeGB
    USB image size for full builds (default 32). Ignored for minimal.

.PARAMETER Arch
    'arm64' or 'amd64'. Defaults to the host architecture (arm64 on ARM64
    Windows, otherwise amd64).

.PARAMETER Distro
    WSL distribution name (default 'Ubuntu'). See: wsl -l -q

.EXAMPLE
    .\Build-NexUSB.ps1
    Builds a minimal ISO for the host architecture.

.EXAMPLE
    .\Build-NexUSB.ps1 -Target full -SizeGB 32 -Arch arm64
#>
[CmdletBinding()]
param(
    [ValidateSet('minimal', 'full')] [string]$Target = 'minimal',
    [int]$SizeGB = 32,
    [ValidateSet('arm64', 'amd64', '')] [string]$Arch = '',
    [string]$Distro = 'Ubuntu'
)

$ErrorActionPreference = 'Stop'

function Write-Step($m) { Write-Host ">> $m" -ForegroundColor Cyan }
function Fail($m) { Write-Host "Error: $m" -ForegroundColor Red; exit 1 }

# Default architecture from the host if not specified.
if ([string]::IsNullOrEmpty($Arch)) {
    if ($env:PROCESSOR_ARCHITECTURE -match 'ARM64' -or $env:PROCESSOR_ARCHITEW6432 -match 'ARM64') {
        $Arch = 'arm64'
    }
    else {
        $Arch = 'amd64'
    }
}
Write-Step "Target=$Target  Arch=$Arch  Distro=$Distro"

# 1. WSL present?
if (-not (Get-Command wsl.exe -ErrorAction SilentlyContinue)) {
    Fail "WSL is not installed. Run 'wsl --install', reboot, then install an Ubuntu (ARM64) distro from the Microsoft Store."
}

# 2. Distro installed? (wsl -l -q emits UTF-16 with NUL bytes)
$installed = (wsl.exe -l -q) -replace "`0", "" |
    ForEach-Object { $_.Trim() } | Where-Object { $_ -ne '' }
if ($installed -notcontains $Distro) {
    Fail "WSL distro '$Distro' not found. Installed: $($installed -join ', '). Install one with: wsl --install -d Ubuntu"
}

# 3. Confirm it's a real WSL2 kernel (WSL1 lacks loop devices / a real kernel).
$kernel = (wsl.exe -d $Distro -u root -- uname -r) 2>$null
if ($kernel -notmatch 'WSL2') {
    Write-Host "Warning: '$Distro' does not report a WSL2 kernel (got '$kernel')." -ForegroundColor Yellow
    Write-Host "         debootstrap and loop devices need WSL2. Convert with: wsl --set-version $Distro 2" -ForegroundColor Yellow
}

# 4. Repo root = parent of this script's folder; translate to a WSL path.
$RepoRoot = Split-Path -Parent $PSScriptRoot
$wslRepo = (wsl.exe -d $Distro wslpath -a "$RepoRoot").Trim()
if ([string]::IsNullOrEmpty($wslRepo)) { Fail "Could not translate '$RepoRoot' to a WSL path." }
$wslScript = "$wslRepo/windows/wsl-build.sh"
Write-Step "Repo: $RepoRoot  ->  $wslRepo"

# 5. Run the build inside WSL as root; output streams live to this console.
Write-Step "Starting build in WSL (this can take a while; emulated arches are slow) ..."
Write-Host ""
wsl.exe -d $Distro -u root -- bash "$wslScript" $Target $SizeGB $Arch "$wslRepo"
$rc = $LASTEXITCODE
Write-Host ""
if ($rc -ne 0) { Fail "Build failed (exit $rc). See the output above." }

Write-Step "Done. Artifacts are in: $(Join-Path $RepoRoot 'dist')"
