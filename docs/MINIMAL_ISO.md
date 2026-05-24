# NexUSB Minimal ISO

A lightweight 2GB bootable ISO with essential rescue and remote access tools.

## What's Included

### Malware Scanning
- ClamAV with virus definitions
- chkrootkit for rootkit detection

### System Recovery
- TestDisk for partition recovery
- PhotoRec for file recovery
- ddrescue for damaged drive recovery

### Disk Management
- GParted for partition editing
- fdisk and parted for partition management
- smartmontools for disk health monitoring

### Network Tools
- nmap for network scanning
- tcpdump for packet analysis
- OpenSSH client for secure connections

### Remote Access (Key Feature)
- **Remmina** - RDP and VNC client with GUI
- **xrdp** - RDP server (accept incoming RDP connections)
- **x11vnc** - VNC server (accept incoming VNC connections)
- **TeamViewer** - Remote support (if available)
- **AnyDesk** - Remote desktop (if available)
- **OpenSSH** - SSH client and server

### GUI Environment
- Lightweight Openbox window manager
- Firefox web browser
- PCManFM file manager
- LXTerminal
- Midnight Commander (text-based file manager)

## Size Comparison

| Build Type | Size | Tools | ISOs | Use Case |
|------------|------|-------|------|----------|
| Minimal | 2GB | Essential only | None | Quick rescue, remote access |
| Standard | 10GB | 150+ tools | 10 ISOs | General purpose |
| Full | 32GB | 150+ tools + Windows | 20+ ISOs | Complete toolkit |

## Building Minimal ISO

```bash
# Install dependencies
sudo apt update
sudo apt install -y debootstrap grub-pc-bin grub-efi-amd64-bin xorriso \
    squashfs-tools mtools isolinux syslinux-utils

# Build minimal ISO
sudo ./build-minimal.sh

# Output: dist/NexUSB-Minimal.iso (~2GB)
```

## Use Cases

### Remote Support Scenario
1. Boot client machine with NexUSB Minimal
2. Connect to network (WiFi or Ethernet)
3. Start xrdp or x11vnc server
4. Connect remotely from your machine
5. Perform diagnostics and repairs remotely

### Quick Malware Scan
1. Boot infected machine
2. Run ClamAV full system scan
3. Remove detected threats
4. Reboot to cleaned system

### Emergency Data Recovery
1. Boot machine with failed drive
2. Use TestDisk to recover partitions
3. Use PhotoRec to recover files
4. Copy recovered data to external drive

### Network Diagnostics
1. Boot machine with network issues
2. Use nmap to scan network
3. Test connectivity with ping/traceroute
4. Configure network with NetworkManager

## Remote Access Setup

### As RDP Server (Accept Connections)
```bash
# From NexUSB menu: Remote Access > Start RDP Server
# Or manually:
systemctl start xrdp
ip addr  # Note your IP address

# From another machine:
# Windows: mstsc.exe, enter IP address
# Linux: remmina, connect to IP:3389
# Mac: Microsoft Remote Desktop, enter IP
```

### As VNC Server (Accept Connections)
```bash
# From NexUSB menu: Remote Access > Start VNC Server
# Or manually:
x11vnc -display :0 -forever -shared

# From another machine:
# Use any VNC client (TightVNC, RealVNC, etc.)
# Connect to IP:5900
```

### As RDP/VNC Client (Connect to Others)
```bash
# From NexUSB menu: Remote Access > Remmina
# Or manually:
remmina

# In Remmina:
# 1. Click "New connection profile"
# 2. Select protocol (RDP or VNC)
# 3. Enter server address
# 4. Enter credentials
# 5. Connect
```

### SSH Access
```bash
# Start SSH server:
systemctl start ssh
passwd  # Set root password

# From another machine:
ssh root@[NexUSB-ip]
```

## Advantages of Minimal ISO

1. **Fast Download** - Only 2GB vs 10GB+ for full build
2. **Quick Boot** - Minimal system boots faster
3. **Low RAM** - Runs on machines with 2GB RAM
4. **Easy to Update** - Smaller size means faster rebuilds
5. **Focused Tools** - Only essential tools, less clutter
6. **USB Friendly** - Fits on smaller USB drives (4GB+)

## When to Use Full Build Instead

Use the full build (./build.sh) when you need:
- Multiple antivirus scanners
- Penetration testing tools
- Windows portable applications
- Bootable ISO collection
- Forensics tools
- Complete toolkit for professional use

## Customizing Minimal Build

Edit `scripts/install-minimal-tools.sh` to add/remove tools:

```bash
# Add a tool
chroot "$WORK_DIR" apt install -y your-package-name

# Remove a tool
# Just comment out or delete the line
```

Keep the ISO under 2GB by:
- Using `--no-install-recommends` flag
- Avoiding large packages
- Cleaning apt cache after installation
- Removing unnecessary documentation

## Network Configuration

### WiFi Setup
```bash
# From menu: Remote Access > Configure Network
# Or use nmtui:
nmtui

# Or command line:
nmcli device wifi list
nmcli device wifi connect SSID password PASSWORD
```

### Ethernet
Usually auto-configured via DHCP. If not:
```bash
dhclient eth0
```

### Static IP
```bash
ip addr add 192.168.1.100/24 dev eth0
ip route add default via 192.168.1.1
echo "nameserver 8.8.8.8" > /etc/resolv.conf
```

## Troubleshooting

### Remote Desktop Not Working
- Check firewall: `ufw allow 3389` (RDP) or `ufw allow 5900` (VNC)
- Verify service running: `systemctl status xrdp`
- Check network connectivity: `ping 8.8.8.8`

### Can't Connect to Network
- Use NetworkManager TUI: `nmtui`
- Check interface status: `ip link`
- Restart NetworkManager: `systemctl restart NetworkManager`

### TeamViewer/AnyDesk Not Available
These require manual download due to licensing. The minimal build attempts to download them but may fail. Download manually:
- TeamViewer: https://www.teamviewer.com/
- AnyDesk: https://anydesk.com/

## Performance

Minimal ISO performance on typical hardware:

| Hardware | Boot Time | RAM Usage | Notes |
|----------|-----------|-----------|-------|
| Modern PC | 30-60s | 500MB | Fast, smooth |
| Old PC (2010) | 1-2min | 400MB | Usable |
| Very Old (2005) | 2-3min | 350MB | Slow but works |

## Updates

To update the minimal ISO:
```bash
# Pull latest changes
git pull

# Rebuild
sudo ./build-minimal.sh

# Flash to USB
sudo dd if=dist/NexUSB-Minimal.iso of=/dev/sdX bs=4M
```

## Comparison with Other Tools

| Tool | Size | Remote Access | Malware Scan | Recovery |
|------|------|---------------|--------------|----------|
| NexUSB Minimal | 2GB | ✓ Full | ✓ ClamAV | ✓ TestDisk |
| SystemRescue | 800MB | ✓ Limited | ✗ | ✓ TestDisk |
| Clonezilla | 400MB | ✗ | ✗ | ✓ Cloning only |
| Hiren's BootCD | 1.5GB | ✓ Limited | ✓ Multiple | ✓ Multiple |
| NexUSB Full | 10GB+ | ✓ Full | ✓ Multiple | ✓ Multiple |

NexUSB Minimal provides the best balance of size, features, and remote access capabilities.
