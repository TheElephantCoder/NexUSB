#!/bin/bash
# Password Tools Menu

choice=$(dialog --clear --backtitle "NexusUSB - Password Tools" \
    --title "Password Reset & Recovery" \
    --menu "Select a tool:" 12 60 4 \
    1 "chntpw - Windows Password Reset" \
    2 "Linux Password Reset" \
    3 "Show Available Windows Partitions" \
    0 "Back to Main Menu" \
    2>&1 >/dev/tty)

case $choice in
    1)
        clear
        echo "Scanning for Windows installations..."
        lsblk -f
        echo ""
        read -p "Enter Windows partition (e.g., /dev/sda2): " part
        mkdir -p /mnt/windows
        mount "$part" /mnt/windows
        cd /mnt/windows/Windows/System32/config
        chntpw -i SAM
        cd /
        umount /mnt/windows
        read -p "Press Enter..."
        ;;
    2)
        clear
        echo "Linux Password Reset"
        lsblk
        echo ""
        read -p "Enter root partition: " part
        mkdir -p /mnt/linux
        mount "$part" /mnt/linux
        chroot /mnt/linux passwd
        umount /mnt/linux
        read -p "Press Enter..."
        ;;
    3)
        clear
        lsblk -f | grep ntfs
        read -p "Press Enter..."
        ;;
esac
