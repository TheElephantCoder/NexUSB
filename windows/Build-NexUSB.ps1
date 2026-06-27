#Requires -Version 5.1
# build NexUSB on windows by driving the linux build inside WSL2.
# linux-only build (debootstrap/chroot/grub/xorriso); runs in an ubuntu wsl distro.
# on arm64 windows, arm64 builds run native. output ends up in repo\dist.
#   Target: minimal|full   SizeGB: full image size   Arch: arm64|amd64 (default host)
#   Distro: wsl distro name (default Ubuntu)
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

# default arch from host
if ([string]::IsNullOrEmpty($Arch)) {
    if ($env:PROCESSOR_ARCHITECTURE -match 'ARM64' -or $env:PROCESSOR_ARCHITEW6432 -match 'ARM64') {
        $Arch = 'arm64'
    }
    else {
        $Arch = 'amd64'
    }
}
Write-Step "Target=$Target  Arch=$Arch  Distro=$Distro"

# wsl installed?
if (-not (Get-Command wsl.exe -ErrorAction SilentlyContinue)) {
    Fail "WSL is not installed. Run 'wsl --install', reboot, then install an Ubuntu (ARM64) distro from the Microsoft Store."
}

# distro installed? (wsl -l -q is utf-16 with NULs)
$installed = (wsl.exe -l -q) -replace "`0", "" |
    ForEach-Object { $_.Trim() } | Where-Object { $_ -ne '' }
if ($installed -notcontains $Distro) {
    Fail "WSL distro '$Distro' not found. Installed: $($installed -join ', '). Install one with: wsl --install -d Ubuntu"
}

# needs wsl2 (wsl1 has no real kernel / loop devices)
$kernel = (wsl.exe -d $Distro -u root -- uname -r) 2>$null
if ($kernel -notmatch 'WSL2') {
    Write-Host "Warning: '$Distro' does not report a WSL2 kernel (got '$kernel')." -ForegroundColor Yellow
    Write-Host "         debootstrap and loop devices need WSL2. Convert with: wsl --set-version $Distro 2" -ForegroundColor Yellow
}

# repo root = parent of this script; translate to wsl path
$RepoRoot = Split-Path -Parent $PSScriptRoot
$wslRepo = (wsl.exe -d $Distro wslpath -a "$RepoRoot").Trim()
if ([string]::IsNullOrEmpty($wslRepo)) { Fail "Could not translate '$RepoRoot' to a WSL path." }
$wslScript = "$wslRepo/windows/wsl-build.sh"
Write-Step "Repo: $RepoRoot  ->  $wslRepo"

# run the build in wsl as root; output streams here
Write-Step "Starting build in WSL (this can take a while; emulated arches are slow) ..."
Write-Host ""
wsl.exe -d $Distro -u root -- bash "$wslScript" $Target $SizeGB $Arch "$wslRepo"
$rc = $LASTEXITCODE
Write-Host ""
if ($rc -ne 0) { Fail "Build failed (exit $rc). See the output above." }

Write-Step "Done. Artifacts are in: $(Join-Path $RepoRoot 'dist')"
