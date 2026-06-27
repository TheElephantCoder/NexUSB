#!/bin/bash
# Download Windows portable tools

WINDOWS_DIR="build/windows-tools"
TOOLS_CONF="config/windows-tools.conf"

echo "Creating Windows tools directory..."
mkdir -p "$WINDOWS_DIR"/{Antivirus,Recovery,SystemInfo,Utilities,Drivers,Network,Backup,Browsers,Office,Media}

echo "=== NexUSB Windows Tools Downloader ==="
echo ""

# Function to download with progress
download_tool() {
    local name="$1"
    local url="$2"
    local output="$3"
    local category="$4"
    
    echo "Downloading: $name"
    if wget --progress=bar:force -O "$WINDOWS_DIR/$category/$output" "$url"; then
        echo "✓ $name downloaded successfully"
        return 0
    else
        echo "✗ Failed to download $name"
        return 1
    fi
}

# Download freely available tools automatically
echo "Downloading freely available tools..."
echo ""

# System Information Tools
echo "[1/15] System Information Tools..."
download_tool "CPU-Z" \
    "https://download.cpuid.com/cpu-z/cpu-z_2.10-en.zip" \
    "cpu-z.zip" "SystemInfo"

download_tool "GPU-Z" \
    "https://ftp.nluug.nl/pub/games/PC/guru3d/apps/gpu-z/GPU-Z.2.59.0.exe" \
    "GPU-Z.exe" "SystemInfo"

download_tool "CrystalDiskInfo" \
    "https://sourceforge.net/projects/crystaldiskinfo/files/latest/download" \
    "CrystalDiskInfo.zip" "SystemInfo"

download_tool "CrystalDiskMark" \
    "https://sourceforge.net/projects/crystaldiskmark/files/latest/download" \
    "CrystalDiskMark.zip" "SystemInfo"

download_tool "HWiNFO" \
    "https://sourceforge.net/projects/hwinfo/files/latest/download" \
    "hwinfo.zip" "SystemInfo"

# Utilities
echo "[2/15] System Utilities..."
download_tool "7-Zip" \
    "https://www.7-zip.org/a/7z2408-x64.exe" \
    "7zip-installer.exe" "Utilities"

download_tool "Everything Search" \
    "https://www.voidtools.com/Everything-1.4.1.1024.x64.zip" \
    "Everything.zip" "Utilities"

download_tool "Rufus" \
    "https://github.com/pbatard/rufus/releases/download/v4.5/rufus-4.5.exe" \
    "rufus.exe" "Utilities"

download_tool "Etcher" \
    "https://github.com/balena-io/etcher/releases/latest/download/balenaEtcher-Portable.exe" \
    "etcher.exe" "Utilities"

download_tool "WinDirStat" \
    "https://sourceforge.net/projects/windirstat/files/latest/download" \
    "windirstat.exe" "Utilities"

download_tool "TreeSize Free" \
    "https://downloads.jam-software.de/treesize_free/TreeSizeFree-Portable.zip" \
    "TreeSizeFree.zip" "Utilities"

# Recovery Tools
echo "[3/15] Data Recovery Tools..."
download_tool "Recuva" \
    "https://download.ccleaner.com/rcsetup153.exe" \
    "recuva-setup.exe" "Recovery"

download_tool "TestDisk/PhotoRec Windows" \
    "https://www.cgsecurity.org/testdisk-7.2-WIP.win.zip" \
    "testdisk-win.zip" "Recovery"

# Antivirus (Free/Portable versions)
echo "[4/15] Antivirus Tools..."
download_tool "AdwCleaner" \
    "https://adwcleaner.malwarebytes.com/adwcleaner?channel=release" \
    "adwcleaner.exe" "Antivirus"

download_tool "McAfee Stinger" \
    "https://downloadcenter.mcafee.com/products/mcafee-avert/stinger/stinger64.exe" \
    "stinger.exe" "Antivirus"

download_tool "Kaspersky Virus Removal Tool" \
    "https://devbuilds.s.kaspersky-labs.com/devbuilds/KVRT/latest/full/KVRT.exe" \
    "KVRT.exe" "Antivirus"

# Network Tools
echo "[5/15] Network Tools..."
download_tool "Angry IP Scanner" \
    "https://github.com/angryip/ipscan/releases/download/3.9.1/ipscan-3.9.1-setup.exe" \
    "ipscan.exe" "Network"

download_tool "Wireshark Portable" \
    "https://www.wireshark.org/download/win64/WiresharkPortable64_latest.paf.exe" \
    "wireshark-portable.exe" "Network"

download_tool "PuTTY" \
    "https://the.earth.li/~sgtatham/putty/latest/w64/putty.exe" \
    "putty.exe" "Network"

download_tool "WinSCP" \
    "https://sourceforge.net/projects/winscp/files/latest/download" \
    "winscp.exe" "Network"

# Browsers
echo "[6/15] Portable Browsers..."
download_tool "Firefox Portable" \
    "https://download.mozilla.org/?product=firefox-latest-ssl&os=win64&lang=en-US" \
    "firefox-setup.exe" "Browsers"

# Office Tools
echo "[7/15] Office Tools..."
download_tool "Notepad++" \
    "https://github.com/notepad-plus-plus/notepad-plus-plus/releases/download/v8.6.9/npp.8.6.9.portable.x64.zip" \
    "notepadpp.zip" "Office"

download_tool "SumatraPDF" \
    "https://www.sumatrapdfreader.org/dl/rel/3.5.2/SumatraPDF-3.5.2-64.zip" \
    "SumatraPDF.zip" "Office"

# Media Tools
echo "[8/15] Media Tools..."
download_tool "VLC Portable" \
    "https://get.videolan.org/vlc/last/win64/vlc-3.0.20-win64.zip" \
    "vlc.zip" "Media"

download_tool "IrfanView" \
    "https://www.irfanview.com/files/iview464_x64.zip" \
    "irfanview.zip" "Media"

# Sysinternals Suite
echo "[9/15] Sysinternals Suite..."
download_tool "Sysinternals Suite" \
    "https://download.sysinternals.com/files/SysinternalsSuite.zip" \
    "SysinternalsSuite.zip" "Utilities"

# Disk Tools
echo "[10/15] Disk Tools..."
download_tool "HDDScan" \
    "https://hddscan.com/downloads/hddscan43.zip" \
    "hddscan.zip" "SystemInfo"

# Driver Tools
echo "[11/15] Driver Tools..."
download_tool "Snappy Driver Installer" \
    "https://sdi-tool.org/SDI_R2309.zip" \
    "SDI.zip" "Drivers"

# Backup Tools
echo "[12/15] Backup Tools..."
# Note: Most backup tools require manual download

# Registry Tools
echo "[13/15] Registry Tools..."
download_tool "RegShot" \
    "https://sourceforge.net/projects/regshot/files/latest/download" \
    "regshot.zip" "Utilities"

# Compression Tools
echo "[14/15] Additional Compression..."
download_tool "PeaZip" \
    "https://github.com/peazip/PeaZip/releases/download/9.8.0/peazip_portable-9.8.0.WIN64.zip" \
    "peazip.zip" "Utilities"

# File Managers
echo "[15/15] File Managers..."
download_tool "Total Commander" \
    "https://totalcmd.net/1101/tcmd101x64.exe" \
    "totalcmd.exe" "Utilities"

echo ""
echo "=== Download Summary ==="
echo "Automatic downloads completed for freely available tools."
echo ""

# Create README
cat << 'EOF' > "$WINDOWS_DIR/README.txt"
NexUSB - Windows Tools Collection

AUTOMATICALLY DOWNLOADED TOOLS:
✓ System Info: CPU-Z, GPU-Z, CrystalDiskInfo, CrystalDiskMark, HWiNFO
✓ Utilities: 7-Zip, Everything, Rufus, Etcher, WinDirStat, Sysinternals
✓ Recovery: Recuva, TestDisk/PhotoRec
✓ Antivirus: AdwCleaner, McAfee Stinger, Kaspersky VRT
✓ Network: Angry IP Scanner, Wireshark, PuTTY, WinSCP
✓ Browsers: Firefox Portable
✓ Office: Notepad++, SumatraPDF
✓ Media: VLC, IrfanView
✓ Drivers: Snappy Driver Installer

MANUAL DOWNLOAD REQUIRED (see MANUAL_DOWNLOADS.txt):
- Malwarebytes (requires registration)
- Bitdefender Rescue CD
- ESET Online Scanner
- HitmanPro (trial/paid)
- Commercial backup tools
- Some antivirus rescue discs

USAGE:
1. Boot into Windows or use Windows PE environment
2. Navigate to this drive
3. Extract .zip files if needed
4. Run tools directly from USB

For updates and more tools, visit:
https://github.com/yourusername/NexUSB
EOF

# Create manual download list
cat << 'EOF' > "$WINDOWS_DIR/MANUAL_DOWNLOADS.txt"
=== MANUAL DOWNLOAD REQUIRED ===

These tools require manual download due to licensing, registration, or terms of service:

ANTIVIRUS & MALWARE REMOVAL:
1. Malwarebytes - https://www.malwarebytes.com/
   (Requires registration for portable version)

2. Bitdefender Rescue CD - https://www.bitdefender.com/support/
   (ISO format, place in ISOs/Antivirus/)

3. ESET Online Scanner - https://www.eset.com/
   (Requires EULA acceptance)

4. Sophos Virus Removal Tool - https://www.sophos.com/
   (Requires business registration)

5. HitmanPro - https://www.hitmanpro.com/
   (Trial version, requires activation)

6. RogueKiller - https://www.adlice.com/
   (Free version available)

7. Emsisoft Emergency Kit - https://www.emsisoft.com/
   (Free download, extract to Antivirus/)

8. Comodo Cleaning Essentials - https://www.comodo.com/
   (Free download)

9. Dr.Web CureIt - https://free.drweb.com/
   (Free download, updated daily)

10. Norton Power Eraser - https://support.norton.com/
    (Free download)

11. Trend Micro HouseCall - https://www.trendmicro.com/
    (Requires online connection)

DATA RECOVERY (Commercial):
1. EaseUS Data Recovery - https://www.easeus.com/
   (Trial version available)

2. R-Studio - https://www.r-studio.com/
   (Demo version available)

3. GetDataBack - https://www.runtime.org/
   (Trial available)

BACKUP TOOLS:
1. Macrium Reflect Free - https://www.macrium.com/
   (Free for personal use, requires registration)

2. AOMEI Backupper - https://www.aomeitech.com/
   (Free version available)

3. EaseUS Todo Backup - https://www.easeus.com/
   (Free version available)

SYSTEM UTILITIES:
1. CCleaner - https://www.ccleaner.com/
   (Free version available)

2. Speccy - https://www.ccleaner.com/speccy
   (Free version)

3. Defraggler - https://www.ccleaner.com/defraggler
   (Free version)

REMOTE ACCESS:
1. TeamViewer - https://www.teamviewer.com/
   (Free for personal use)

2. AnyDesk - https://anydesk.com/
   (Free for personal use)

INSTRUCTIONS:
1. Visit the URLs above
2. Download the portable/standalone versions when available
3. Place in the appropriate category folder:
   - Antivirus/
   - Recovery/
   - Backup/
   - Utilities/
   - Network/

4. Update this list as you add tools

NOTE: Always download from official sources only!
EOF

# Create PowerShell helper script
cat << 'SCRIPT' > "$WINDOWS_DIR/download-manual-tools.ps1"
# PowerShell script to help download manual tools
# Run as Administrator in Windows

Write-Host "NexUSB Manual Tools Downloader" -ForegroundColor Cyan
Write-Host "=================================" -ForegroundColor Cyan
Write-Host ""

$tools = @(
    @{Name="Emsisoft Emergency Kit"; URL="https://dl.emsisoft.com/EmsisoftEmergencyKit.exe"; File="Antivirus/EmergencyKit.exe"},
    @{Name="Dr.Web CureIt"; URL="https://free.drweb.com/download+cureit+free/"; File="Antivirus/cureit.exe"},
    @{Name="Norton Power Eraser"; URL="https://support.norton.com/sp/static/external/tools/npe.exe"; File="Antivirus/NPE.exe"},
    @{Name="RogueKiller"; URL="https://www.adlice.com/download/roguekiller/"; File="Antivirus/RogueKiller.exe"},
    @{Name="Comodo Cleaning Essentials"; URL="https://download.comodo.com/cce/download/setups/cce_x64.zip"; File="Antivirus/CCE.zip"},
    @{Name="Macrium Reflect Free"; URL="https://www.macrium.com/reflectfree"; File="Backup/ReflectFree.exe"},
    @{Name="CCleaner Portable"; URL="https://www.ccleaner.com/ccleaner/builds"; File="Utilities/ccleaner.zip"}
)

foreach ($tool in $tools) {
    Write-Host "Downloading: $($tool.Name)" -ForegroundColor Yellow
    Write-Host "URL: $($tool.URL)" -ForegroundColor Gray
    
    try {
        $output = Join-Path $PSScriptRoot $tool.File
        Invoke-WebRequest -Uri $tool.URL -OutFile $output -UseBasicParsing
        Write-Host "✓ Downloaded successfully" -ForegroundColor Green
    } catch {
        Write-Host "✗ Failed - Please download manually from: $($tool.URL)" -ForegroundColor Red
    }
    Write-Host ""
}

Write-Host "Download process complete!" -ForegroundColor Cyan
Write-Host "Check MANUAL_DOWNLOADS.txt for additional tools" -ForegroundColor Cyan
SCRIPT

chmod +x "$WINDOWS_DIR/download-manual-tools.ps1"

echo ""
echo "Windows tools setup complete!"
echo "- Automatic downloads: $WINDOWS_DIR/"
echo "- Manual download list: $WINDOWS_DIR/MANUAL_DOWNLOADS.txt"
echo "- PowerShell helper: $WINDOWS_DIR/download-manual-tools.ps1"
echo ""
echo "Run the PowerShell script in Windows to download additional free tools."
