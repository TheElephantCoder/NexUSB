#!/bin/bash
# Disk Management Menu

choice=$(dialog --clear --backtitle "NexusUSB - Disk Tools" \
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
    1) gparted & ;;
    2) clear; lsblk; echo ""; read -p "Enter disk (e.g., /dev/sda): " disk; fdisk "$disk"; read -p "Press Enter..." ;;
    3) clear; smartctl -a /dev/sda; read -p "Press Enter..." ;;
    4) clear; df -h; echo ""; du -sh /*; read -p "Press Enter..." ;;
    5) clear; echo "WARNING: This will permanently erase data!"; lsblk; read -p "Enter device: " dev; shred -vfz -n 3 "$dev"; read -p "Press Enter..." ;;
esac
