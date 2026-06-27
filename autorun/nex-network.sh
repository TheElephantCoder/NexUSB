#!/bin/bash
# Network Diagnostics Menu

# --- Validation helpers ----------------------------------------------------
validate_host() {
    [[ "$1" =~ ^[A-Za-z0-9._-]+$ ]] || return 1
    return 0
}

validate_ip_or_cidr() {
    local target="$1"
    if [[ ! "$target" =~ ^([0-9]{1,3}\.){3}[0-9]{1,3}(/[0-9]{1,2})?$ ]]; then
        return 1
    fi
    local ip="${target%%/*}"
    local IFS='.'
    read -ra octets <<< "$ip"
    for o in "${octets[@]}"; do
        [ "$o" -le 255 ] || return 1
    done
    return 0
}

choice=$(dialog --clear --backtitle "NexUSB - Network" \
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
    2)
        clear
        read -p "Enter host to ping: " host
        if validate_host "$host"; then
            ping -c 4 -- "$host"
        else
            echo "Error: Invalid host. Use a hostname or IPv4 address."
        fi
        read -p "Press Enter..."
        ;;
    3)
        clear
        read -p "Enter target IP/network: " target
        if validate_ip_or_cidr "$target"; then
            nmap -- "$target"
        else
            echo "Error: Invalid target. Use an IPv4 address or CIDR (e.g., 192.168.1.0/24)."
        fi
        read -p "Press Enter..."
        ;;
    4)
        if command -v wireshark &> /dev/null; then
            wireshark &
        else
            clear
            echo "Wireshark is not installed."
            echo "Install with: sudo apt install wireshark"
            read -p "Press Enter..."
        fi
        ;;
    5) clear; echo "netcat usage: nc [options] host port"; read -p "Press Enter..." ;;
    6) nmtui & ;;
esac
