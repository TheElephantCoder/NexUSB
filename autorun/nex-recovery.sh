#!/bin/bash
# System Recovery Menu

validate_partition() {
    local part="$1"
    if [[ ! "$part" =~ ^/dev/(sd[a-z][0-9]+|nvme[0-9]+n[0-9]+p[0-9]+|vd[a-z][0-9]+)$ ]]; then
        echo "Error: Invalid partition name format: '$part'"
        return 1
    fi
    if [ ! -b "$part" ]; then
        echo "Error: $part does not exist or is not a block device"
        return 1
    fi
    return 0
}

choice=$(dialog --clear --backtitle "NexUSB - Recovery" \
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
    4)
        clear
        lsblk
        echo ""
        read -p "Enter partition (e.g., /dev/sda1): " part
        if validate_partition "$part"; then
            fsck -y "$part"
        fi
        read -p "Press Enter..."
        ;;
    5) clear; echo "Boot Repair coming soon..."; read -p "Press Enter..." ;;
    6) clear; echo "Windows System Restore coming soon..."; read -p "Press Enter..." ;;
esac
