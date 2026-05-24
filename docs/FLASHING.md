# Flashing NexUSB to USB Drive

## Method 1: Ventoy (Recommended)

Ventoy allows you to copy multiple ISOs to a single USB drive and boot from them.

### Installation

1. Download Ventoy from https://www.ventoy.net/
2. Install Ventoy to your USB drive:
   ```bash
   sudo sh Ventoy2Disk.sh -i /dev/sdX
   ```
   Replace `/dev/sdX` with your USB device

3. Copy NexUSB.iso to the USB drive:
   ```bash
   cp dist/NexUSB.iso /path/to/usb/
   ```

4. Boot from USB and select NexUSB from Ventoy menu

### Advantages
- Keep multiple ISOs on one USB
- No need to reformat when updating
- Supports persistence

## Method 2: Rufus (Windows)

1. Download Rufus from https://rufus.ie/
2. Insert your USB drive
3. Open Rufus
4. Select your USB device
5. Click "SELECT" and choose NexUSB.iso
6. Partition scheme: GPT (for UEFI) or MBR (for Legacy BIOS)
7. Click "START"

## Method 3: dd (Linux/Mac)

### Linux
```bash
sudo dd if=dist/NexUSB.iso of=/dev/sdX bs=4M status=progress && sync
```

### macOS
```bash
sudo dd if=dist/NexUSB.iso of=/dev/rdiskX bs=1m
```

Replace `/dev/sdX` or `/dev/rdiskX` with your USB device.

### Finding Your USB Device

Linux:
```bash
lsblk
```

macOS:
```bash
diskutil list
```

## Method 4: Etcher (Cross-platform)

1. Download balenaEtcher from https://www.balena.io/etcher/
2. Select NexUSB.iso
3. Select your USB drive
4. Click "Flash!"

## Verification

After flashing, verify the USB is bootable:

1. Safely eject the USB
2. Reboot your computer
3. Enter BIOS/UEFI boot menu (F2, F12, Del, or Esc)
4. Select the USB drive
5. You should see the NexUSB boot menu

## Troubleshooting

### USB not detected
- Try a different USB port
- Use USB 2.0 port instead of 3.0
- Check if USB is properly formatted

### Boot fails
- Disable Secure Boot in BIOS
- Try different partition scheme (GPT vs MBR)
- Verify ISO integrity with checksum

### Slow boot
- USB 2.0 drives are slower than 3.0
- Consider using a faster USB drive
