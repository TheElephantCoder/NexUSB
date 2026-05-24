#!/bin/bash
# System Information Menu

choice=$(dialog --clear --backtitle "NexusUSB - System Info" \
    --title "System Information" \
    --menu "Select information to view:" 15 60 7 \
    1 "Hardware Summary" \
    2 "CPU Information" \
    3 "Memory Information" \
    4 "Disk Information" \
    5 "PCI Devices" \
    6 "USB Devices" \
    0 "Back to Main Menu" \
    2>&1 >/dev/tty)

case $choice in
    1) clear; lshw -short; read -p "Press Enter..." ;;
    2) clear; lscpu; read -p "Press Enter..." ;;
    3) clear; free -h; echo ""; cat /proc/meminfo; read -p "Press Enter..." ;;
    4) clear; lsblk -f; echo ""; df -h; read -p "Press Enter..." ;;
    5) clear; lspci; read -p "Press Enter..." ;;
    6) clear; lsusb; read -p "Press Enter..." ;;
esac
