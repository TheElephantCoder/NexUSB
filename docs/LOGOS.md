# NexUSB Logo System

## Automated Logo Download

NexUSB automatically downloads and generates professional logos for all tools during the build process.

## How It Works

When you run `./build.sh` or `./build-minimal.sh`, the system:

1. **Downloads Real Logos** - Attempts to download actual logos from official sources:
   - ClamAV from clamav.net
   - Wireshark from wireshark.org
   - Nmap from nmap.org
   - GParted from gparted.org
   - Remmina, Firefox, VLC, and more

2. **Creates Fallback Icons** - For tools without downloadable logos:
   - Professional colored squares with tool initials
   - Color-coded by category
   - Consistent 64x64 size

3. **Generates Branding** - Creates NexUSB branding:
   - Main logo (400x80)
   - App icon (256x256)
   - Background wallpaper (1920x1080)
   - GRUB theme elements

## Logo Categories

### Security Tools (Red/Orange)
- ClamAV - Actual logo
- Wireshark - Actual logo
- Nmap - Actual logo
- Metasploit - Fallback (M on blue)
- Aircrack-ng - Fallback (A on cyan)
- chkrootkit - Fallback (R on red)
- rkhunter - Fallback (RK on dark red)
- Lynis - Fallback (L on orange)

### Recovery Tools (Green)
- GParted - Actual logo
- TestDisk - Fallback (TD on green)
- PhotoRec - Fallback (PR on green)
- Clonezilla - Fallback (CZ on dark green)
- ddrescue - Fallback (DD on dark green)
- Foremost - Fallback (F on cyan-green)
- Boot Repair - Fallback (BR on purple)

### Remote Access (Blue)
- Remmina - Actual logo
- TeamViewer - Actual logo (if available)
- AnyDesk - Fallback (AD on red)
- VNC - Fallback (VNC on blue)
- SSH - Fallback (SSH on green)
- RDP - Fallback (RDP on blue)
- xrdp - Fallback (X on cyan)

### System Tools (Various)
- Firefox - Actual logo
- VLC - Actual logo
- 7-Zip - Actual logo (if available)
- Hardware Info - Fallback (HW on blue)
- htop - Fallback (H on green)
- CPU-Z - Fallback (CPU on blue)
- GPU-Z - Fallback (GPU on green)
- CrystalDiskInfo - Fallback (CDI on cyan)

### Network Tools (Cyan/Blue)
- tcpdump - Fallback (TCP on cyan)
- iftop - Fallback (IF on cyan)
- nethogs - Fallback (NH on cyan)
- mtr - Fallback (MTR on blue)
- Kismet - Fallback (K on purple)

### Disk Tools (Orange/Yellow)
- fdisk - Fallback (FD on orange)
- parted - Fallback (P on orange)
- SMART - Fallback (S on blue)
- Baobab - Fallback (DU on red-orange)

## Customizing Logos

### Replace Individual Logos

1. Create your own 64x64 PNG logo
2. Name it exactly as the tool (e.g., `clamav.png`, `gparted.png`)
3. Place in `assets/icons/tools/`
4. Rebuild NexUSB

Example:
```bash
# Create custom ClamAV logo
convert your-logo.png -resize 64x64 assets/icons/tools/clamav.png

# Rebuild
sudo ./build.sh
```

### Replace NexUSB Branding

Replace these files before building:
```
assets/icons/nex-logo.png (400x80) - Header logo
assets/icons/nex-icon.png (256x256) - App icon
assets/icons/background.png (1920x1080) - Wallpaper
```

### Add New Tool Logos

1. Add logo to `assets/icons/tools/toolname.png`
2. Update GUI to reference it:
```python
("toolname", "Tool Name", "Description", "command")
```

## Logo Requirements

**Format:** PNG with transparency
**Size:** 64x64 pixels (will be auto-resized if different)
**Background:** Transparent or solid color
**Style:** Simple, recognizable at small sizes

## Fallback Icon Colors

Color coding helps identify tool categories at a glance:

| Category | Color | Hex Code |
|----------|-------|----------|
| Security | Red/Orange | #cc0000, #ff6600 |
| Recovery | Green | #00cc66, #009933 |
| Disk | Orange/Yellow | #cc9900, #cc6600 |
| Network | Cyan/Blue | #0099cc, #00cccc |
| Remote | Blue | #0066cc, #0099cc |
| System | Purple/Blue | #6666cc, #0066cc |

## Build Process

The logo download happens automatically:

```bash
# Full build
sudo ./build.sh

# Minimal build
sudo ./build-minimal.sh
```

During build, you'll see:
```
[1.5/10] Downloading tool logos...
  Downloading clamav... ✓
  Downloading wireshark... ✓
  Downloading nmap... ✓
  ...
✓ Tool logos downloaded/generated
```

## Manual Logo Generation

To regenerate logos without full rebuild:

```bash
chmod +x assets/download-logos.sh
./assets/download-logos.sh
```

This creates all logos in `assets/icons/tools/`

## Troubleshooting

### Logo Download Fails
- Check internet connection
- Some sites may block automated downloads
- Fallback icons will be created automatically

### Logo Doesn't Appear in GUI
- Verify file exists: `ls assets/icons/tools/toolname.png`
- Check file permissions: `chmod 644 assets/icons/tools/*.png`
- Verify filename matches exactly (case-sensitive)

### Logo Looks Blurry
- Ensure source image is at least 64x64
- Use PNG format with transparency
- Avoid JPEG (no transparency support)

## Icon Sources

Logos are downloaded from official sources:
- **ClamAV**: clamav.net
- **Wireshark**: wireshark.org
- **Nmap**: nmap.org
- **GParted**: gparted.org
- **Firefox**: mozilla.org
- **VLC**: videolan.org
- **Remmina**: remmina.org

All logos are property of their respective owners and used for identification purposes only.

## License Compliance

- Official logos are downloaded from public sources
- Fallback icons are original creations
- No logos are redistributed in the repository
- Logos are generated during build process
- Users download logos directly from official sources

## Future Improvements

Planned enhancements:
- SVG support for scalable logos
- Animated icons for active processes
- Theme variants (light/dark)
- User-selectable icon packs
- High-DPI (2x, 3x) icon support
