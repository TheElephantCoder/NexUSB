#!/bin/bash
# password tools

# partition name (/dev/sda2, nvme0n1p3) + must be a real block dev
validate_partition() {
    local part="$1"
    if [[ ! "$part" =~ ^/dev/(sd[a-z][0-9]+|nvme[0-9]+n[0-9]+p[0-9]+|vd[a-z][0-9]+)$ ]]; then
        echo "Error: Invalid partition name format: '$part'"
        echo "Expected something like /dev/sda2 or /dev/nvme0n1p3"
        return 1
    fi
    if [ ! -b "$part" ]; then
        echo "Error: $part does not exist or is not a block device"
        return 1
    fi
    return 0
}

choice=$(dialog --clear --backtitle "NexUSB - Password Tools" \
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

        if ! validate_partition "$part"; then
            read -p "Press Enter..."
            exit 1
        fi

        MOUNT_POINT="/mnt/windows-$$"
        mkdir -p "$MOUNT_POINT"

        echo "Mounting $part..."
        if ! mount "$part" "$MOUNT_POINT" 2>/dev/null; then
            echo "Error: Failed to mount $part"
            echo "The partition may be encrypted, corrupted, or the wrong type."
            rmdir "$MOUNT_POINT" 2>/dev/null
            read -p "Press Enter..."
            exit 1
        fi

        CONFIG_DIR="$MOUNT_POINT/Windows/System32/config"
        if [ ! -d "$CONFIG_DIR" ]; then
            echo "Error: This does not appear to be a Windows partition."
            echo "Could not find Windows/System32/config."
            umount "$MOUNT_POINT"
            rmdir "$MOUNT_POINT" 2>/dev/null
            read -p "Press Enter..."
            exit 1
        fi

        if cd "$CONFIG_DIR"; then
            chntpw -i SAM
            cd /
        else
            echo "Error: Could not access $CONFIG_DIR"
        fi

        umount "$MOUNT_POINT" || echo "Warning: failed to unmount $MOUNT_POINT"
        rmdir "$MOUNT_POINT" 2>/dev/null
        read -p "Press Enter..."
        ;;
    2)
        clear
        echo "Linux Password Reset"
        lsblk
        echo ""
        read -p "Enter root partition: " part

        if ! validate_partition "$part"; then
            read -p "Press Enter..."
            exit 1
        fi

        MOUNT_POINT="/mnt/linux-$$"
        mkdir -p "$MOUNT_POINT"

        echo "Mounting $part..."
        if ! mount "$part" "$MOUNT_POINT" 2>/dev/null; then
            echo "Error: Failed to mount $part"
            rmdir "$MOUNT_POINT" 2>/dev/null
            read -p "Press Enter..."
            exit 1
        fi

        if [ ! -d "$MOUNT_POINT/etc" ]; then
            echo "Error: This does not appear to be a Linux root partition."
            umount "$MOUNT_POINT"
            rmdir "$MOUNT_POINT" 2>/dev/null
            read -p "Press Enter..."
            exit 1
        fi

        chroot "$MOUNT_POINT" passwd
        umount "$MOUNT_POINT" || echo "Warning: failed to unmount $MOUNT_POINT"
        rmdir "$MOUNT_POINT" 2>/dev/null
        read -p "Press Enter..."
        ;;
    3)
        clear
        lsblk -f | grep ntfs
        read -p "Press Enter..."
        ;;
esac
