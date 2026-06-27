#!/bin/bash
# Disk Management Menu

# --- Input validation helpers ---------------------------------------------
# Validate a whole-disk device name (e.g. /dev/sda, /dev/nvme0n1, /dev/vda)
validate_disk() {
    local dev="$1"
    if [[ ! "$dev" =~ ^/dev/(sd[a-z]|nvme[0-9]+n[0-9]+|vd[a-z])$ ]]; then
        echo "Error: Invalid disk name format: '$dev'"
        echo "Expected something like /dev/sda, /dev/nvme0n1, or /dev/vda"
        return 1
    fi
    if [ ! -b "$dev" ]; then
        echo "Error: $dev does not exist or is not a block device"
        return 1
    fi
    return 0
}

choice=$(dialog --clear --backtitle "NexUSB - Disk Tools" \
    --title "Disk Management" \
    --menu "Select a tool:" 15 60 6 \
    1 "GParted - Partition Editor (GUI)" \
    2 "fdisk - Partition Manager" \
    3 "SMART Disk Health Check" \
    4 "Disk Usage Analyzer" \
    5 "Secure Erase (shred)" \
    0 "Back to Main Menu" \
    2>&1 >/dev/tty)

case $choice in
    1)
        gparted &
        ;;
    2)
        clear
        lsblk
        echo ""
        read -p "Enter disk (e.g., /dev/sda): " disk
        if validate_disk "$disk"; then
            fdisk "$disk"
        fi
        read -p "Press Enter..."
        ;;
    3)
        clear
        lsblk
        echo ""
        read -p "Enter disk (e.g., /dev/sda): " disk
        if validate_disk "$disk"; then
            smartctl -a "$disk"
        fi
        read -p "Press Enter..."
        ;;
    4)
        clear
        df -h
        echo ""
        du -sh /*
        read -p "Press Enter..."
        ;;
    5)
        clear
        echo "WARNING: This will permanently erase data!"
        lsblk
        echo ""
        read -p "Enter device: " dev
        if ! validate_disk "$dev"; then
            read -p "Press Enter..."
            exit 1
        fi
        if mount | grep -q "^$dev"; then
            echo "Error: $dev (or one of its partitions) is currently mounted."
            echo "Unmount it before erasing."
            read -p "Press Enter..."
            exit 1
        fi
        echo ""
        echo "This will PERMANENTLY erase ALL data on $dev:"
        lsblk "$dev"
        echo ""
        read -p "Type 'ERASE' to confirm: " confirm
        if [ "$confirm" = "ERASE" ]; then
            shred -vfz -n 3 "$dev"
        else
            echo "Operation cancelled."
        fi
        read -p "Press Enter..."
        ;;
esac
