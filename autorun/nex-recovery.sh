#!/bin/bash
# System Recovery Menu

choice=$(dialog --clear --backtitle "NexusUSB - Recovery" \
    --title "System Recovery & Repair" \
    --menu "Select a tool:" 15 60 7 \
    1 "TestDisk - Partition Recovery" \
    2 "PhotoRec - File Recovery" \
    3 "ddrescue - Clone Damaged Drive" \
    4 "fsck - File System Check" \
    5 "Boot Repair (GRUB)" \
    6 "Windows System Restore" \
    0 "Back to Main Menu" \
    2>&1 >/dev/tty)

case $choice in
    1) clear; testdisk; read -p "Press Enter..." ;;
    2) clear; photorec; read -p "Press Enter..." ;;
    3) clear; echo "Usage: ddrescue /dev/sdX /dev/sdY logfile"; read -p "Press Enter..." ;;
    4) clear; lsblk; echo ""; read -p "Enter partition (e.g., /dev/sda1): " part; fsck -y "$part"; read -p "Press Enter..." ;;
    5) clear; echo "Boot Repair coming soon..."; read -p "Press Enter..." ;;
    6) clear; echo "Windows System Restore coming soon..."; read -p "Press Enter..." ;;
esac
