#!/bin/bash
# NexusUSB Main Menu

DIALOG_HEIGHT=20
DIALOG_WIDTH=70

while true; do
    choice=$(dialog --clear --backtitle "NexusUSB v1.0" \
        --title "Main Menu" \
        --menu "Select a category:" $DIALOG_HEIGHT $DIALOG_WIDTH 12 \
        1 "Malware Scanning & Security" \
        2 "System Recovery & Repair" \
        3 "Disk Management" \
        4 "Password Tools" \
        5 "Network Diagnostics" \
        6 "Remote Access & Control" \
        7 "System Information" \
        8 "File Manager" \
        9 "Terminal" \
        10 "Reboot" \
        0 "Shutdown" \
        2>&1 >/dev/tty)

    case $choice in
        1) /usr/local/bin/nexus-security.sh ;;
        2) /usr/local/bin/nexus-recovery.sh ;;
        3) /usr/local/bin/nexus-disk.sh ;;
        4) /usr/local/bin/nexus-password.sh ;;
        5) /usr/local/bin/nexus-network.sh ;;
        6) /usr/local/bin/nexus-remote.sh ;;
        7) /usr/local/bin/nexus-sysinfo.sh ;;
        8) pcmanfm & ;;
        9) lxterminal & ;;
        10) reboot ;;
        0) poweroff ;;
        *) break ;;
    esac
done
