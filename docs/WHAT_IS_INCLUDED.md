# What's Actually Included in NexUSB

This document clarifies what tools are automatically downloaded vs what requires manual download.

## Automatically Installed During Build

### Linux Tools (from Ubuntu repositories)
All these are installed automatically when you run `./build.sh`:

**Security & Malware (14 tools):**
- ✓ ClamAV (with daemon and auto-updates)
- ✓ chkrootkit
- ✓ rkhunter
- ✓ Lynis
- ✓ AIDE
- ✓ Fail2ban
- ✓ OpenVAS
- ✓ Nikto
- ✓ John the Ripper
- ✓ Hashcat
- ✓ Aircrack-ng
- ✓ Metasploit Framework
- ✓ Burp Suite Community
- ✓ OWASP ZAP

**Recovery Tools (13 tools):**
- ✓ TestDisk
- ✓ PhotoRec
- ✓ ddrescue
- ✓ Foremost
- ✓ Scalpel
- ✓ extundelete
- ✓ fsck
- ✓ ntfsfix
- ✓ Clonezilla
- ✓ Partclone
- ✓ SystemRescue
- ✓ Boot-Repair

**Disk Tools (13 tools):**
- ✓ GParted
- ✓ fdisk
- ✓ parted
- ✓ gdisk
- ✓ smartmontools
- ✓ hdparm
- ✓ sdparm
- ✓ nvme-cli
- ✓ GNOME Disks
- ✓ KDE Partition Manager
- ✓ duf
- ✓ ncdu
- ✓ baobab

**Network Tools (14 tools):**
- ✓ Wireshark
- ✓ nmap
- ✓ netcat
- ✓ tcpdump
- ✓ iftop
- ✓ nethogs
- ✓ iperf3
- ✓ mtr
- ✓ traceroute
- ✓ ethtool
- ✓ wavemon
- ✓ kismet
- ✓ LinSSID
- ✓ NetworkManager

**Plus 50+ additional utilities, editors, file managers, etc.**

Total: 150+ Linux tools automatically installed

### Automatically Downloaded Windows Tools

These are downloaded automatically during build:

**System Information (5 tools):**
- ✓ CPU-Z
- ✓ GPU-Z
- ✓ CrystalDiskInfo
- ✓ CrystalDiskMark
- ✓ HWiNFO

**Utilities (10 tools):**
- ✓ 7-Zip
- ✓ Everything Search
- ✓ Rufus
- ✓ Etcher
- ✓ WinDirStat
- ✓ TreeSize Free
- ✓ Sysinternals Suite
- ✓ RegShot
- ✓ PeaZip
- ✓ Total Commander

**Recovery (2 tools):**
- ✓ Recuva
- ✓ TestDisk/PhotoRec (Windows version)

**Antivirus (3 tools):**
- ✓ AdwCleaner
- ✓ McAfee Stinger
- ✓ Kaspersky Virus Removal Tool

**Network (4 tools):**
- ✓ Angry IP Scanner
- ✓ Wireshark Portable
- ✓ PuTTY
- ✓ WinSCP

**Browsers (1 tool):**
- ✓ Firefox Portable

**Office (2 tools):**
- ✓ Notepad++
- ✓ SumatraPDF

**Media (2 tools):**
- ✓ VLC Portable
- ✓ IrfanView

**Drivers (1 tool):**
- ✓ Snappy Driver Installer

Total: 30+ Windows tools automatically downloaded

### Automatically Downloaded ISOs

These rescue ISOs are downloaded automatically:

**Essential Rescue Tools (10 ISOs - ~3GB):**
- ✓ SystemRescue
- ✓ Clonezilla Live
- ✓ GParted Live
- ✓ MemTest86+
- ✓ Ultimate Boot CD
- ✓ Rescuezilla
- ✓ Kaspersky Rescue Disk
- ✓ Tails (Privacy OS)
- ✓ Puppy Linux
- ✓ Tiny Core Linux

## Requires Manual Download

### Windows Tools (Licensing/Registration Required)

**Antivirus (11 tools):**
- Malwarebytes (requires registration)
- Bitdefender Rescue CD
- ESET Online Scanner
- Sophos Virus Removal Tool
- HitmanPro (trial/paid)
- RogueKiller (free version available)
- Emsisoft Emergency Kit (free)
- Comodo Cleaning Essentials (free)
- Dr.Web CureIt (free, updated daily)
- Norton Power Eraser (free)
- Trend Micro HouseCall (requires online)

**Data Recovery (Commercial):**
- EaseUS Data Recovery (trial)
- R-Studio (demo)
- GetDataBack (trial)
- Disk Drill
- Stellar Data Recovery

**Backup Tools:**
- Macrium Reflect Free (registration required)
- AOMEI Backupper (free version)
- EaseUS Todo Backup (free version)
- Acronis True Image (commercial)

**System Utilities:**
- CCleaner (free version)
- Speccy (free)
- Defraggler (free)

**Remote Access:**
- TeamViewer (free for personal use)
- AnyDesk (free for personal use)

### ISOs (Large Downloads)

**Linux Distributions (~20GB):**
- Ubuntu Desktop (4GB)
- Linux Mint (3GB)
- Fedora Workstation (2.5GB)
- Debian Live (3.5GB)
- Manjaro (3.8GB)
- Pop!_OS (3GB)
- Elementary OS (2.8GB)
- Zorin OS (3.3GB)
- MX Linux (2GB)

**Security Distros (~15GB):**
- Kali Linux (4GB)
- Parrot Security (5GB)
- BlackArch Linux (8GB)
- Pentoo (4GB)

**Antivirus Rescue Discs (~5GB):**
- Bitdefender Rescue CD
- AVG Rescue CD
- Avira Rescue System
- ESET SysRescue Live
- F-Secure Rescue CD
- Sophos Bootable Anti-Virus
- Dr.Web LiveDisk

**Specialized Tools (~5GB):**
- Hiren's BootCD PE (1.5GB)
- Trinity Rescue Kit
- Falcon
- DBAN
- ShredOS

**Windows Installation Media (~12GB):**
- Windows 10 (6GB)
- Windows 11 (6GB)
- Windows Server (5GB)

## Download Helpers Included

To make manual downloads easier, NexUSB includes:

1. **MANUAL_DOWNLOADS.txt** - Complete list with direct URLs
2. **download-manual-tools.ps1** - PowerShell script to download free Windows tools
3. **download-popular.sh** - Bash script to download popular Linux ISOs
4. **README files** - Instructions in each directory

## Size Breakdown

**Automatic Downloads:**
- Linux base system: 3GB
- Linux tools: 2GB
- Windows tools (auto): 1.5GB
- Essential ISOs: 3GB
- **Total: ~9.5GB**

**With Manual Downloads:**
- Add Windows tools: +3GB
- Add Linux distros: +20GB
- Add security distros: +15GB
- Add antivirus ISOs: +5GB
- Add Windows media: +12GB
- **Total: ~64GB**

## Recommended Approach

### For Quick Setup (10GB):
Just run `./build.sh` - you'll get all the essential tools automatically.

### For Complete Toolkit (32GB):
1. Run `./build.sh`
2. Download popular ISOs: `cd build/isos && ./download-popular.sh`
3. Add a few key Windows tools manually

### For Maximum Collection (64GB):
1. Run `./build.sh`
2. Follow all instructions in MANUAL_DOWNLOADS.txt files
3. Download all ISOs you might need

## Why Manual Downloads?

Many tools require manual download because:
- **Licensing** - Can't be redistributed automatically
- **Registration** - Require accepting terms or creating accounts
- **Size** - Large ISOs would make build time extremely long
- **Updates** - Tools update frequently, manual download ensures latest version
- **Legal** - Some tools have specific distribution restrictions

The automatic downloads focus on freely available, redistributable tools that provide core functionality.
