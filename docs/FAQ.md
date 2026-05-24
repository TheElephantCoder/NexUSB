# Frequently Asked Questions

## General

### What is NexUSB?
NexUSB is a bootable USB toolkit for system recovery, malware scanning, and diagnostics. It's similar to Medicat USB but open-source.

### How large is the ISO?
The final ISO is approximately 4-6GB. When flashed to USB, we recommend a 32GB drive for additional storage space.

### Is NexUSB free?
Yes, NexUSB is completely free and open-source under the MIT License.

## Building

### What Linux distribution should I use to build?
Ubuntu 22.04 LTS or newer is recommended. Debian 11+ also works well.

### How long does the build take?
Initial build takes 30-60 minutes depending on your internet speed and system specs.

### Can I build on Windows?
Not directly. Use WSL2 (Windows Subsystem for Linux) with Ubuntu.

## Usage

### How do I boot from the USB?
1. Insert the USB drive
2. Restart your computer
3. Enter BIOS/UEFI (usually F2, F12, Del, or Esc)
4. Select the USB drive as boot device
5. Choose NexUSB from the boot menu

### Does it work on UEFI systems?
Yes, NexUSB supports both Legacy BIOS and UEFI boot modes.

### Can I use this on Mac?
Yes, but you may need to hold Option/Alt during boot to access the boot menu.

### Will this erase my hard drive?
No, NexUSB runs entirely from the USB drive and doesn't modify your system unless you explicitly use tools to do so.

## Troubleshooting

### Boot menu doesn't appear
- Check BIOS boot order
- Disable Secure Boot if enabled
- Try a different USB port
- Recreate the bootable USB

### Tools aren't working
Make sure you're running as root. Most tools require elevated privileges.

### Network isn't working
Use the Network Configuration tool from the main menu to set up your connection.

## Customization

### Can I add my own tools?
Yes! Edit `config/tools.conf` and rebuild the ISO.

### Can I change the theme?
Absolutely. Modify files in the `theme/` directory.

### How do I add custom scripts?
Place them in the `autorun/` directory and add menu entries to the appropriate menu script.
