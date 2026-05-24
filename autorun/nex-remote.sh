#!/bin/bash
# Remote Access Tools Menu

choice=$(dialog --clear --backtitle "NexusUSB - Remote Access" \
    --title "Remote Access & Control" \
    --menu "Select a tool:" 20 70 12 \
    1 "Remmina - RDP/VNC Client" \
    2 "xrdp - Start RDP Server" \
    3 "x11vnc - Start VNC Server" \
    4 "TeamViewer" \
    5 "AnyDesk" \
    6 "SSH Client" \
    7 "SSH Server - Start" \
    8 "View Network Information" \
    9 "Configure Network" \
    10 "Test Connection (ping)" \
    11 "Port Scanner (nmap)" \
    0 "Back to Main Menu" \
    2>&1 >/dev/tty)

case $choice in
    1)
        remmina &
        ;;
    2)
        clear
        echo "Starting xrdp server..."
        systemctl start xrdp
        ip addr | grep "inet "
        echo ""
        echo "RDP server started. Connect using:"
        echo "  Protocol: RDP"
        echo "  Address: [IP address above]"
        echo "  Port: 3389"
        echo "  Username: root (or create user)"
        read -p "Press Enter to continue..."
        ;;
    3)
        clear
        echo "Starting x11vnc server..."
        x11vnc -display :0 -auth guess -forever -loop -noxdamage -repeat -rfbauth /tmp/vncpasswd -shared &
        ip addr | grep "inet "
        echo ""
        echo "VNC server started. Connect using:"
        echo "  Protocol: VNC"
        echo "  Address: [IP address above]"
        echo "  Port: 5900"
        read -p "Press Enter to continue..."
        ;;
    4)
        if command -v teamviewer &> /dev/null; then
            teamviewer &
        else
            clear
            echo "TeamViewer not installed."
            echo "Download from: https://www.teamviewer.com/"
            read -p "Press Enter to continue..."
        fi
        ;;
    5)
        if command -v anydesk &> /dev/null; then
            anydesk &
        else
            clear
            echo "AnyDesk not installed."
            echo "Download from: https://anydesk.com/"
            read -p "Press Enter to continue..."
        fi
        ;;
    6)
        clear
        read -p "Enter SSH host (user@hostname): " sshhost
        ssh "$sshhost"
        read -p "Press Enter to continue..."
        ;;
    7)
        clear
        echo "Starting SSH server..."
        systemctl start ssh
        ip addr | grep "inet "
        echo ""
        echo "SSH server started. Connect using:"
        echo "  ssh root@[IP address above]"
        echo ""
        echo "Set root password if not already set:"
        passwd
        read -p "Press Enter to continue..."
        ;;
    8)
        clear
        echo "=== Network Information ==="
        echo ""
        echo "IP Addresses:"
        ip addr show | grep "inet "
        echo ""
        echo "Routing Table:"
        ip route
        echo ""
        echo "DNS Servers:"
        cat /etc/resolv.conf | grep nameserver
        echo ""
        echo "Active Connections:"
        ss -tuln
        read -p "Press Enter to continue..."
        ;;
    9)
        nmtui
        ;;
    10)
        clear
        read -p "Enter host to ping: " host
        ping -c 4 "$host"
        read -p "Press Enter to continue..."
        ;;
    11)
        clear
        read -p "Enter target IP/network to scan: " target
        echo "Scanning $target..."
        nmap -sV "$target"
        read -p "Press Enter to continue..."
        ;;
esac
