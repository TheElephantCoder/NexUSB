#!/bin/bash
# Network Diagnostics Menu

choice=$(dialog --clear --backtitle "NexusUSB - Network" \
    --title "Network Diagnostics" \
    --menu "Select a tool:" 15 60 7 \
    1 "Network Configuration" \
    2 "Ping Test" \
    3 "nmap - Network Scanner" \
    4 "Wireshark - Packet Analyzer" \
    5 "netcat - Network Utility" \
    6 "WiFi Connection Manager" \
    0 "Back to Main Menu" \
    2>&1 >/dev/tty)

case $choice in
    1) clear; ip addr; echo ""; ip route; read -p "Press Enter..." ;;
    2) clear; read -p "Enter host to ping: " host; ping -c 4 "$host"; read -p "Press Enter..." ;;
    3) clear; read -p "Enter target IP/network: " target; nmap "$target"; read -p "Press Enter..." ;;
    4) wireshark & ;;
    5) clear; echo "netcat usage: nc [options] host port"; read -p "Press Enter..." ;;
    6) nmtui & ;;
esac
