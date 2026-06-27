# NexUSB

<div align="center">

**Professional Bootable USB Rescue Toolkit**

[![License: MIT](https://img.shields.io/badge/License-MIT-blue.svg)](LICENSE)
[![Build Status](https://img.shields.io/badge/build-passing-brightgreen.svg)]()
[![Version](https://img.shields.io/badge/version-1.0.0-blue.svg)](CHANGELOG.md)
[![Platform](https://img.shields.io/badge/platform-Linux%20%7C%20Windows%20PE-lightgrey.svg)]()

*System recovery • Malware scanning • Data recovery • Network diagnostics • Remote access*

[Quick Start](QUICKSTART.md) • [Documentation](docs/) • [Roadmap](ROADMAP.md) • [Contributing](CONTRIBUTING.md)

</div>

---

## 🚀 What is NexUSB?

NexUSB is a comprehensive, open-source bootable USB toolkit that combines a live Linux environment with Windows PE integration, providing access to 150+ professional tools for:

- **🛡️ Malware Scanning** - ClamAV, chkrootkit, rkhunter, and Windows antivirus tools
- **💾 Data Recovery** - TestDisk, PhotoRec, ddrescue, and file carving tools
- **💿 Disk Management** - GParted, fdisk, SMART monitoring, and partition tools
- **🌐 Network Diagnostics** - Wireshark, nmap, tcpdump, and WiFi analysis
- **🖥️ Remote Access** - RDP, VNC, SSH, TeamViewer, AnyDesk
- **🔧 System Repair** - Boot repair, file system check, registry tools

**Perfect for:** IT professionals, system administrators, security researchers, and anyone who needs to rescue, repair, or diagnose computer systems.

## ✨ Key Features

### Dual Environment
- **Linux Environment** - 150+ open-source tools, fast and secure
- **Windows PE** - Native Windows tools via Hiren's BootCD PE integration
- **Multi-boot** - 50+ additional rescue ISOs supported

### Professional Interface
- **Modern GUI** - GTK3 interface with actual tool logos
- **Interactive Menus** - Easy-to-use text-based menus
- **Custom Theme** - Professional blue/black design
- **Touch Support** - Works on tablets and touchscreens

### Comprehensive Tools
- **Security** - 14 malware scanners and security tools
- **Recovery** - 13 data recovery and repair utilities
- **Disk** - 13 partition and disk management tools
- **Network** - 14 network diagnostic and monitoring tools
- **Remote** - 12 remote access and control applications
- **System** - 12 hardware information and monitoring tools

### Easy to Build
- **Automated** - One command builds everything
- **Makefile** - Simplified build process
- **Minimal Option** - 2GB ISO in 30 minutes
- **Full Option** - 32GB system in 90 minutes

## 📦 Two Build Options

### Minimal ISO (~2GB)
Perfect for quick rescue operations and remote access.

**Includes:**
- ClamAV antivirus
- TestDisk/PhotoRec recovery
- GParted disk management
- Remote access tools
- Network diagnostics
- Lightweight GUI

**Build time:** 30 minutes

### Full System (~32GB)
Complete toolkit with everything you need.

**Includes:**
- Everything from minimal
- 150+ Linux tools
- 30+ Windows portable apps
- 10+ bootable ISOs
- Multi-partition layout

**Build time:** 60-90 minutes

## 🎯 Quick Start

```bash
# 1. Install dependencies
make install-deps

# 2. Check environment
make check

# 3. Download logos
make icons

# 4. Build minimal ISO
make minimal

# 5. Flash to USB
sudo dd if=dist/NexUSB-Minimal.iso of=/dev/sdX bs=4M status=progress
```

**That's it!** Boot from USB and start rescuing systems.

For detailed instructions, see [QUICKSTART.md](QUICKSTART.md).

## 📖 Documentation

- **[Quick Start Guide](QUICKSTART.md)** - Get started in 15 minutes
- **[Build Instructions](BUILD.md)** - Detailed build process
- **[Malware Scanning Guide](docs/MALWARE_SCANNING.md)** - How to scan and remove malware
- **[Windows Tools Usage](docs/WINDOWS_TOOLS_USAGE.md)** - Using Windows applications
- **[Flashing Guide](docs/FLASHING.md)** - How to create bootable USB
- **[Tools Reference](docs/TOOLS.md)** - Complete tool documentation
- **[FAQ](docs/FAQ.md)** - Frequently asked questions
- **[Roadmap](ROADMAP.md)** - Future plans and features

## 🛠️ What Gets Downloaded Automatically

When you run the build, NexUSB automatically:

✅ Installs 150+ Linux tools from Ubuntu repositories  
✅ Downloads 30+ Windows portable applications  
✅ Downloads 10 essential rescue ISOs (~3GB)  
✅ Creates professional GUI with tool logos  
✅ Generates custom branding and theme  

**Total automatic download: ~10GB**

Additional tools and ISOs can be added manually. See [What's Included](docs/WHAT_IS_INCLUDED.md) for details.

## 🔒 Malware Scanning

NexUSB provides professional-grade malware scanning:

**Linux Environment:**
- ClamAV (8+ million signatures)
- chkrootkit (rootkit detection)
- rkhunter (advanced rootkit hunter)
- Lynis (security auditing)

**Windows PE Environment:**
- Malwarebytes
- Kaspersky Virus Removal Tool
- AdwCleaner
- McAfee Stinger
- And 10+ more

**How it works:** Boot from USB into a clean environment, mount the infected drive, and scan offline. Malware can't run or defend itself!

See [Malware Scanning Guide](docs/MALWARE_SCANNING.md) for detailed instructions.

## 🌐 Remote Access

Built-in remote access tools for remote troubleshooting:

- **Remmina** - RDP/VNC client with GUI
- **xrdp** - RDP server (accept incoming connections)
- **x11vnc** - VNC server (share your screen)
- **OpenSSH** - SSH client and server
- **TeamViewer** - Remote support software
- **AnyDesk** - Remote desktop application

**Use case:** Boot a broken machine with NexUSB, connect to network, start RDP server, and troubleshoot remotely from your desk!

## 💻 System Requirements

### Build System
- **OS:** Ubuntu 22.04+ or Debian 11+ (Linux)
- **Disk:** 50GB free space
- **RAM:** 4GB minimum (8GB recommended)
- **Network:** Internet connection required
- **Time:** 30-90 minutes depending on build type

### Target System (Runtime)
- **Architecture:** x86_64 (64-bit)
- **RAM:** 2GB minimum (4GB recommended)
- **Boot:** UEFI or Legacy BIOS
- **USB:** 4GB for minimal, 32GB for full

## 🎨 Screenshots

*Coming soon - Professional GUI with tool logos, custom theme, and modern interface*

## 🤝 Contributing

We welcome contributions! Here's how you can help:

- **Code:** Fix bugs, add features, improve performance
- **Documentation:** Write guides, improve docs, create tutorials
- **Testing:** Test on different hardware, report bugs
- **Translation:** Translate to other languages
- **Community:** Answer questions, help users

See [CONTRIBUTING.md](CONTRIBUTING.md) for guidelines.

## 📋 Comparison

| Feature | NexUSB | Medicat USB | Hiren's BootCD | SystemRescue |
|---------|-----------|-------------|----------------|--------------|
| **Open Source** | ✅ Yes | ❌ No | ⚠️ Partial | ✅ Yes |
| **Linux Tools** | 150+ | Limited | Limited | 50+ |
| **Windows Tools** | 30+ | 100+ | 100+ | None |
| **GUI** | ✅ Modern | ✅ Yes | ✅ Yes | ❌ No |
| **Malware Scanning** | ✅ Multiple | ✅ Yes | ✅ Yes | ⚠️ Limited |
| **Remote Access** | ✅ Full | ⚠️ Limited | ⚠️ Limited | ⚠️ Limited |
| **Customizable** | ✅ Fully | ❌ No | ❌ No | ⚠️ Partial |
| **Size** | 2-32GB | 20GB | 1.5GB | 800MB |
| **Cost** | Free | Free | Free | Free |

## 📜 License

NexUSB is released under the [MIT License](LICENSE).

**You are free to:**
- Use commercially
- Modify
- Distribute
- Sublicense

**Conditions:**
- Include copyright notice
- Include license text

## 🙏 Acknowledgments

**Inspired by:**
- Medicat USB
- Hiren's BootCD
- Ultimate Boot CD
- SystemRescue

**Built with:**
- Ubuntu/Debian base
- GRUB2 bootloader
- GTK3 for GUI
- Open-source tools and utilities

**Special thanks to:**
- All open-source tool developers
- The Linux community
- Contributors and testers

## 📞 Support

- **Issues:** [GitHub Issues](https://github.com/TheElephantCoder/NexUSB/issues)
- **Discussions:** [GitHub Discussions](https://github.com/TheElephantCoder/NexUSB/discussions)
- **Documentation:** [docs/](docs/) directory
- **FAQ:** [docs/FAQ.md](docs/FAQ.md)

## 🗺️ Roadmap

See [ROADMAP.md](ROADMAP.md) for planned features and future development.

**Coming soon:**
- Web-based GUI
- Mobile app for remote control
- Multi-language support
- Cloud integration
- AI-powered malware detection

## ⭐ Star History

If you find NexUSB useful, please consider giving it a star on GitHub!

---

<div align="center">

**Made with ❤️ by TheElephantCoder**

[GitHub](https://github.com/TheElephantCoder/NexUSB) • [Documentation](docs/)

</div>

### Core Environment
- Modern blue/black themed boot interface (GRUB2 + custom theme)
- Multi-boot support with 50+ rescue ISOs
- Both UEFI and Legacy BIOS support
- Persistent storage option for saving data

### Security & Malware Tools (20+ tools)
- ClamAV, Kaspersky, Bitdefender, Malwarebytes
- Rootkit detection (chkrootkit, rkhunter)
- Penetration testing (Metasploit, Aircrack-ng, Nmap)
- Password recovery and reset utilities
- Full Kali Linux and Parrot Security ISOs included

### System Recovery (15+ tools)
- TestDisk, PhotoRec, ddrescue
- Clonezilla for disk imaging
- Multiple file recovery tools
- Boot repair utilities
- Windows and Linux system restore

### Disk Management
- GParted, fdisk, parted
- SMART monitoring tools
- Disk health diagnostics
- Secure erase utilities
- Partition recovery tools

### Windows Tools Collection (100+ portable apps)
- Portable antivirus scanners
- System information tools (CPU-Z, GPU-Z, HWMonitor)
- Data recovery software
- Registry and driver tools
- Portable browsers and office suites

### Network Diagnostics
- Wireshark, nmap, tcpdump
- WiFi analysis tools
- Remote access utilities
- Network monitoring and scanning

### Remote Access & Control
- **Remmina** - RDP/VNC client with GUI
- **xrdp** - RDP server (accept incoming connections)
- **x11vnc** - VNC server (share your screen)
- **TeamViewer** - Remote support software
- **AnyDesk** - Remote desktop application
- **OpenSSH** - SSH client and server
- **Rustdesk** - Open-source remote desktop
- Perfect for remote troubleshooting and support

### Additional ISOs (50+ distributions)
- Linux distributions (Ubuntu, Mint, Fedora, etc.)
- Security distros (Kali, Parrot, BlackArch)
- Antivirus rescue discs
- Specialized recovery tools
- Windows installation media support

## Requirements

- USB drive: 32GB minimum (64GB recommended for full collection)
- Build system: Ubuntu 22.04+ with 50GB free space
- Target size: 20-32GB (expandable to 64GB with all ISOs)
- RAM: 4GB minimum for live environment

## Quick Start

### Option 1: Minimal ISO (Recommended for Quick Start)
```bash
# Install dependencies
sudo apt update
sudo apt install -y debootstrap grub-pc-bin grub-efi-amd64-bin xorriso \
    squashfs-tools mtools isolinux syslinux-utils

# Build minimal 2GB ISO
sudo ./build-minimal.sh

# Flash to USB
sudo dd if=dist/NexUSB-Minimal.iso of=/dev/sdX bs=4M status=progress
```

**Minimal ISO includes:**
- ClamAV antivirus
- TestDisk/PhotoRec recovery
- GParted disk management
- Remote access tools (RDP, VNC, SSH, TeamViewer, AnyDesk)
- Network diagnostics
- Lightweight GUI

### Option 2: Full Build (Complete Toolkit)
```bash
# Install dependencies (same as above)

# Build full system (32GB default)
sudo ./build.sh 32

# Output: dist/NexUSB.img
sudo dd if=dist/NexUSB.img of=/dev/sdX bs=4M status=progress
```

**Full build includes:**
- Everything from minimal
- 150+ Linux tools
- 30+ Windows portable apps
- 10+ bootable ISOs
- Multi-partition layout

## Documentation

- [Minimal ISO Guide](docs/MINIMAL_ISO.md) - Lightweight 2GB ISO with remote access
- [Build Instructions](BUILD.md) - Detailed build process
- [What's Included](docs/WHAT_IS_INCLUDED.md) - Complete list of automatic vs manual downloads
- [Flashing Guide](docs/FLASHING.md) - How to create bootable USB
- [Tools Reference](docs/TOOLS.md) - Complete tool documentation
- [Size Guide](docs/SIZE_GUIDE.md) - Size configurations and customization
- [FAQ](docs/FAQ.md) - Frequently asked questions

## What Gets Downloaded Automatically

When you run `./build.sh`, NexUSB automatically:

- Installs 150+ Linux tools from Ubuntu repositories
- Downloads 30+ Windows portable applications
- Downloads 10 essential rescue ISOs (~3GB)
- Creates a complete bootable environment

**Total automatic download: ~10GB**

Additional tools and ISOs can be added manually (see [What's Included](docs/WHAT_IS_INCLUDED.md) for details).

### Automatically Included Malware Scanners:

**Linux:**
- ClamAV (full antivirus with auto-updates)
- chkrootkit, rkhunter (rootkit detection)
- Lynis, AIDE (security auditing)

**Windows (auto-downloaded):**
- AdwCleaner
- McAfee Stinger
- Kaspersky Virus Removal Tool

**ISOs (auto-downloaded):**
- Kaspersky Rescue Disk

**Manual download available for:**
- Malwarebytes, Bitdefender, ESET, Sophos, HitmanPro, and 10+ more (see docs/WHAT_IS_INCLUDED.md)

## Project Structure

```
NexUSB/
├── build.sh              # Main build script (full build)
├── build-minimal.sh      # Minimal ISO builder (2GB)
├── config/
│   ├── tools.conf        # Linux tools to install
│   ├── windows-tools.conf # Windows portable apps
│   └── iso-collection.conf # Bootable ISOs to include
├── scripts/
│   ├── setup-base.sh     # Base system setup
│   ├── setup-minimal-base.sh # Minimal base setup
│   ├── install-tools.sh  # Full tool installation
│   ├── install-minimal-tools.sh # Essential tools only
│   ├── setup-boot.sh     # Boot configuration
│   ├── create-iso.sh     # ISO creation
│   ├── create-multiboot.sh # Multi-partition image
│   ├── download-windows-tools.sh # Auto-download Windows tools
│   └── download-isos.sh  # Auto-download ISOs
├── theme/
│   ├── grub.cfg          # GRUB configuration
│   └── nex/              # Theme assets
├── autorun/
│   ├── nex-menu.sh       # Main interactive menu
│   ├── nex-remote.sh     # Remote access menu
│   └── nex-*.sh          # Other menu scripts
└── docs/                 # Documentation
```

## Features in Detail

### Multi-Partition Layout
1. **Boot Partition (512MB)** - EFI/GRUB bootloader
2. **NexUSB Live (8GB)** - Linux environment with tools
3. **Windows Tools (8GB)** - Portable Windows applications
4. **ISO Collection (remaining)** - Multiboot ISO library

### Bootable ISOs Included
- System rescue and recovery tools
- Linux distributions for all purposes
- Security and penetration testing distros
- Antivirus rescue discs
- Windows installation media
- Specialized diagnostic tools

### Interactive Menus
Easy-to-use text menus for:
- Malware scanning and removal
- System recovery and repair
- Disk management and diagnostics
- Password reset and recovery
- Network diagnostics
- System information

## Customization

### Add Your Own Tools
Edit `config/tools.conf`:
```
CATEGORY|TOOL_NAME|PACKAGE_NAME|DESCRIPTION
```

### Add Windows Applications
Edit `config/windows-tools.conf` and download to `build/windows-tools/`

### Add ISOs
Place ISO files in `build/isos/` organized by category:
- Linux/
- Security/
- Rescue/
- Antivirus/
- Windows/
- Tools/

### Customize Theme
Edit files in `theme/nex/`:
- `theme.txt` - Colors and layout
- `background.png` - Boot background
- `logo.png` - NexUSB logo

## Contributing

Contributions welcome! See [CONTRIBUTING.md](CONTRIBUTING.md) for guidelines.

## License

MIT License - See [LICENSE](LICENSE) file for details.

## Acknowledgments

Inspired by:
- Hiren's BootCD
- Ultimate Boot CD
- SystemRescue

Built with:
- Debian/Ubuntu base system
- GRUB2 bootloader
- Ventoy multiboot technology
- Open-source tools and utilities

## Support

- Issues: GitHub Issues
- Discussions: GitHub Discussions
- Wiki: Project Wiki

## Disclaimer

This toolkit is intended for legitimate system administration, recovery, and security testing purposes only. Users are responsible for ensuring they have proper authorization before using these tools on any system.
