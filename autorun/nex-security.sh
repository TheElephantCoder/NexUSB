#!/bin/bash
# NexusUSB Security & Malware Scanning Menu
# Professional malware detection and removal

DIALOG_HEIGHT=22
DIALOG_WIDTH=75
SCAN_LOG_DIR="/home/nexus-scans"
mkdir -p "$SCAN_LOG_DIR"

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m'

# Function to show scan progress
show_progress() {
    echo -e "${BLUE}[SCANNING]${NC} $1"
}

# Function to show results
show_result() {
    local infected=$1
    if [ "$infected" -gt 0 ]; then
        echo -e "${RED}[INFECTED]${NC} Found $infected infected file(s)"
    else
        echo -e "${GREEN}[CLEAN]${NC} No threats detected"
    fi
}

while true; do
    choice=$(dialog --clear --backtitle "NexusUSB - Professional Malware Scanner" \
        --title "🛡️  Security & Malware Scanning" \
        --menu "Select scanning option:" $DIALOG_HEIGHT $DIALOG_WIDTH 13 \
        1 "🖥️  Auto-Scan Windows (Recommended)" \
        2 "🐧 Auto-Scan Linux" \
        3 "⚡ Quick Scan (5-10 min)" \
        4 "🔍 Deep Scan (1-2 hours)" \
        5 "📁 Custom Folder Scan" \
        6 "🦠 Rootkit Detection" \
        7 "🔐 Security Audit" \
        8 "🔄 Update Virus Definitions" \
        9 "📊 View Scan Reports" \
        10 "💾 Quarantine Manager" \
        11 "🔧 Mount Drive Manually" \
        12 "ℹ️  Scan Statistics" \
        0 "← Back to Main Menu" \
        2>&1 >/dev/tty)

    case $choice in
        1)
            clear
            echo -e "${BLUE}╔════════════════════════════════════════════════════════╗${NC}"
            echo -e "${BLUE}║        Auto-Scan Windows Drive (Recommended)          ║${NC}"
            echo -e "${BLUE}╚════════════════════════════════════════════════════════╝${NC}"
            echo ""
            
            # Auto-detect Windows partition
            show_progress "Detecting Windows partitions..."
            part=$(lsblk -f -n -o NAME,FSTYPE | grep ntfs | head -1 | awk '{print "/dev/"$1}')
            
            if [ -z "$part" ]; then
                echo -e "${YELLOW}No Windows partition auto-detected.${NC}"
                echo "Available drives:"
                lsblk -f
                echo ""
                read -p "Enter partition manually (e.g., /dev/sda1) or Enter to skip: " part
            else
                echo -e "${GREEN}✓ Found Windows partition: $part${NC}"
                read -p "Scan this partition? (Y/n): " confirm
                [ "$confirm" = "n" ] && continue
            fi
            
            if [ -n "$part" ]; then
                MOUNT_POINT="/mnt/windows-scan"
                mkdir -p "$MOUNT_POINT"
                
                show_progress "Mounting $part..."
                if mount -o ro "$part" "$MOUNT_POINT" 2>/dev/null; then
                    echo -e "${GREEN}✓ Mounted successfully (read-only)${NC}"
                    
                    # Update definitions
                    show_progress "Updating virus definitions..."
                    freshclam 2>&1 | grep -E "updated|Database"
                    
                    # Scan
                    TIMESTAMP=$(date +%Y%m%d_%H%M%S)
                    LOG_FILE="$SCAN_LOG_DIR/windows_${TIMESTAMP}.log"
                    
                    echo ""
                    echo -e "${BLUE}Starting comprehensive Windows scan...${NC}"
                    echo "Target: $MOUNT_POINT"
                    echo "Log: $LOG_FILE"
                    echo "Estimated time: 30-60 minutes"
                    echo ""
                    
                    # Scan with progress
                    clamscan -r -i --bell \
                        --exclude-dir="^/mnt/windows-scan/Windows/WinSxS" \
                        --exclude-dir="^/mnt/windows-scan/\$Recycle.Bin" \
                        --log="$LOG_FILE" \
                        "$MOUNT_POINT" | tee /tmp/scan_output.txt
                    
                    # Parse results
                    INFECTED=$(grep "Infected files:" /tmp/scan_output.txt | awk '{print $3}')
                    SCANNED=$(grep "Scanned files:" /tmp/scan_output.txt | awk '{print $3}')
                    
                    echo ""
                    echo -e "${GREEN}╔════════════════════════════════════════════════════════╗${NC}"
                    echo -e "${GREEN}║                  Scan Complete                         ║${NC}"
                    echo -e "${GREEN}╚════════════════════════════════════════════════════════╝${NC}"
                    echo "Files scanned: $SCANNED"
                    show_result "${INFECTED:-0}"
                    echo "Full report: $LOG_FILE"
                    echo ""
                    
                    if [ "${INFECTED:-0}" -gt 0 ]; then
                        read -p "Quarantine infected files? (y/n): " quarantine
                        if [ "$quarantine" = "y" ]; then
                            mkdir -p "$SCAN_LOG_DIR/quarantine"
                            umount "$MOUNT_POINT"
                            mount "$part" "$MOUNT_POINT" 2>/dev/null
                            clamscan -r -i --move="$SCAN_LOG_DIR/quarantine" "$MOUNT_POINT"
                            echo -e "${GREEN}✓ Infected files quarantined${NC}"
                        fi
                    fi
                    
                    umount "$MOUNT_POINT"
                else
                    echo -e "${RED}✗ Failed to mount $part${NC}"
                fi
            fi
            read -p "Press Enter to continue..."
            ;;
        2)
            clear
            echo "=== Scan Linux Drive ==="
            echo ""
            echo "Available Linux drives:"
            lsblk -f | grep -E "ext4|ext3|btrfs"
            echo ""
            read -p "Enter Linux partition (e.g., /dev/sda2): " part
            
            if [ -n "$part" ]; then
                echo "Mounting $part..."
                mkdir -p /mnt/linux-scan
                mount "$part" /mnt/linux-scan 2>/dev/null
                
                if [ $? -eq 0 ]; then
                    echo ""
                    echo "Updating virus definitions..."
                    freshclam
                    echo ""
                    echo "Starting scan of Linux drive..."
                    clamscan -r -i --bell --log=/home/linux-scan.log /mnt/linux-scan
                    echo ""
                    echo "Scan complete! Log saved to /home/linux-scan.log"
                    umount /mnt/linux-scan
                else
                    echo "Error: Could not mount $part"
                fi
            fi
            read -p "Press Enter to continue..."
            ;;
        3)
            clear
            echo "=== Quick Scan (Common Malware Locations) ==="
            echo ""
            echo "Updating virus definitions..."
            freshclam
            echo ""
            echo "Scanning common malware locations..."
            echo "This will take 5-10 minutes."
            echo ""
            
            # Scan common locations
            for location in /home /tmp /var/tmp /mnt/*/Users/*/Downloads /mnt/*/Windows/Temp; do
                if [ -d "$location" ]; then
                    echo "Scanning $location..."
                    clamscan -r -i --bell "$location"
                fi
            done
            
            echo ""
            echo "Quick scan complete!"
            read -p "Press Enter to continue..."
            ;;
        4)
            clear
            echo "=== Full System Scan ==="
            echo ""
            echo "WARNING: This will scan ALL mounted drives and may take 1-2 hours."
            read -p "Continue? (y/n): " confirm
            
            if [ "$confirm" = "y" ]; then
                echo ""
                echo "Updating virus definitions..."
                freshclam
                echo ""
                echo "Starting full system scan..."
                clamscan -r -i --bell --log=/home/full-scan.log /
                echo ""
                echo "Full scan complete! Log saved to /home/full-scan.log"
            fi
            read -p "Press Enter to continue..."
            ;;
        5)
            clear
            echo "=== Custom Scan ==="
            echo ""
            echo "Mounted drives:"
            df -h | grep -E "/mnt|/media"
            echo ""
            read -p "Enter path to scan (e.g., /mnt/windows/Users): " scanpath
            
            if [ -d "$scanpath" ]; then
                echo ""
                echo "Updating virus definitions..."
                freshclam
                echo ""
                echo "Scanning $scanpath..."
                clamscan -r -i --bell --log=/home/custom-scan.log "$scanpath"
                echo ""
                echo "Scan complete! Log saved to /home/custom-scan.log"
            else
                echo "Error: Path not found: $scanpath"
            fi
            read -p "Press Enter to continue..."
            ;;
        6)
            clear
            echo "=== chkrootkit - Rootkit Detection ==="
            echo ""
            echo "Scanning for rootkits..."
            echo "This checks for hidden malware and system modifications."
            echo ""
            chkrootkit | tee /home/chkrootkit.log
            echo ""
            echo "Scan complete! Log saved to /home/chkrootkit.log"
            read -p "Press Enter to continue..."
            ;;
        7)
            clear
            echo "=== rkhunter - Advanced Rootkit Hunter ==="
            echo ""
            echo "Updating rkhunter database..."
            rkhunter --update
            echo ""
            echo "Running comprehensive rootkit scan..."
            rkhunter --check --skip-keypress --report-warnings-only | tee /home/rkhunter.log
            echo ""
            echo "Scan complete! Log saved to /home/rkhunter.log"
            read -p "Press Enter to continue..."
            ;;
        8)
            clear
            echo "=== Lynis - Security Audit ==="
            echo ""
            echo "Running system security audit..."
            lynis audit system --quick | tee /home/lynis.log
            echo ""
            echo "Audit complete! Log saved to /home/lynis.log"
            read -p "Press Enter to continue..."
            ;;
        8)
            clear
            echo -e "${BLUE}╔════════════════════════════════════════════════════════╗${NC}"
            echo -e "${BLUE}║           Update Virus Definitions                     ║${NC}"
            echo -e "${BLUE}╚════════════════════════════════════════════════════════╝${NC}"
            echo ""
            echo "Checking for updates..."
            echo ""
            
            if freshclam; then
                echo ""
                echo -e "${GREEN}✓ Virus definitions updated successfully${NC}"
                echo ""
                echo "Current database info:"
                clamscan --version | grep -E "ClamAV|signatures"
                echo ""
                sigtool --info /var/lib/clamav/daily.cvd 2>/dev/null | grep -E "Build time|Signatures"
            else
                echo ""
                echo -e "${YELLOW}⚠ Update failed. Check internet connection.${NC}"
                echo "You can still scan with existing definitions."
            fi
            echo ""
            read -p "Press Enter to continue..."
            ;;
        
        10)
            clear
            echo -e "${BLUE}╔════════════════════════════════════════════════════════╗${NC}"
            echo -e "${BLUE}║              Quarantine Manager                        ║${NC}"
            echo -e "${BLUE}╚════════════════════════════════════════════════════════╝${NC}"
            echo ""
            
            QUARANTINE_DIR="$SCAN_LOG_DIR/quarantine"
            if [ -d "$QUARANTINE_DIR" ] && [ "$(ls -A $QUARANTINE_DIR 2>/dev/null)" ]; then
                echo "Quarantined files:"
                ls -lh "$QUARANTINE_DIR"
                echo ""
                echo "Options:"
                echo "  1) View file details"
                echo "  2) Delete all quarantined files"
                echo "  3) Restore a file (use with caution)"
                echo "  0) Back"
                echo ""
                read -p "Choice: " qchoice
                
                case $qchoice in
                    1) ls -laR "$QUARANTINE_DIR" | less ;;
                    2) 
                        read -p "Delete ALL quarantined files? (yes/no): " confirm
                        if [ "$confirm" = "yes" ]; then
                            rm -rf "$QUARANTINE_DIR"/*
                            echo -e "${GREEN}✓ Quarantine cleared${NC}"
                        fi
                        ;;
                    3)
                        read -p "Enter filename to restore: " filename
                        read -p "Restore to path: " restore_path
                        if [ -f "$QUARANTINE_DIR/$filename" ] && [ -d "$restore_path" ]; then
                            mv "$QUARANTINE_DIR/$filename" "$restore_path/"
                            echo -e "${GREEN}✓ File restored${NC}"
                        fi
                        ;;
                esac
            else
                echo "Quarantine is empty."
            fi
            echo ""
            read -p "Press Enter to continue..."
            ;;
        
        12)
            clear
            echo -e "${BLUE}╔════════════════════════════════════════════════════════╗${NC}"
            echo -e "${BLUE}║              Scan Statistics                           ║${NC}"
            echo -e "${BLUE}╚════════════════════════════════════════════════════════╝${NC}"
            echo ""
            
            if [ -d "$SCAN_LOG_DIR" ]; then
                TOTAL_SCANS=$(ls -1 "$SCAN_LOG_DIR"/*.log 2>/dev/null | wc -l)
                echo "Total scans performed: $TOTAL_SCANS"
                echo ""
                
                if [ $TOTAL_SCANS -gt 0 ]; then
                    echo "Recent scans:"
                    ls -lht "$SCAN_LOG_DIR"/*.log 2>/dev/null | head -5
                    echo ""
                    
                    TOTAL_INFECTED=0
                    for log in "$SCAN_LOG_DIR"/*.log; do
                        INF=$(grep "Infected files:" "$log" 2>/dev/null | awk '{print $3}')
                        TOTAL_INFECTED=$((TOTAL_INFECTED + ${INF:-0}))
                    done
                    
                    echo "Total threats detected: $TOTAL_INFECTED"
                    
                    if [ -d "$SCAN_LOG_DIR/quarantine" ]; then
                        QUARANTINED=$(ls -1 "$SCAN_LOG_DIR/quarantine" 2>/dev/null | wc -l)
                        echo "Files in quarantine: $QUARANTINED"
                    fi
                fi
            else
                echo "No scan history found."
            fi
            echo ""
            read -p "Press Enter to continue..."
            ;;
        10)
            clear
            echo "=== Scan Logs ==="
            echo ""
            echo "Available scan logs:"
            ls -lh /home/*.log 2>/dev/null
            echo ""
            read -p "Enter log file to view (or press Enter to skip): " logfile
            
            if [ -n "$logfile" ] && [ -f "$logfile" ]; then
                less "$logfile"
            elif [ -n "$logfile" ] && [ -f "/home/$logfile" ]; then
                less "/home/$logfile"
            fi
            ;;
        11)
            clear
            echo "=== Mount Drive for Scanning ==="
            echo ""
            echo "Available drives:"
            lsblk -f
            echo ""
            read -p "Enter partition to mount (e.g., /dev/sda1): " part
            read -p "Mount point name (e.g., windows): " mountname
            
            if [ -n "$part" ] && [ -n "$mountname" ]; then
                mkdir -p "/mnt/$mountname"
                mount "$part" "/mnt/$mountname"
                
                if [ $? -eq 0 ]; then
                    echo ""
                    echo "Successfully mounted $part to /mnt/$mountname"
                    echo ""
                    ls -la "/mnt/$mountname"
                else
                    echo ""
                    echo "Error: Could not mount $part"
                fi
            fi
            read -p "Press Enter to continue..."
            ;;
        0|"")
            break
            ;;
    esac
done
