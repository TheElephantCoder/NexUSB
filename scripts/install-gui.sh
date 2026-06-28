#!/bin/bash
# gui components

WORK_DIR=$1

echo "Installing GUI components..."

# python gtk
chroot "$WORK_DIR" apt install -y \
    python3-gi \
    python3-gi-cairo \
    gir1.2-gtk-3.0 \
    gir1.2-gdkpixbuf-2.0

# icons + fonts
chroot "$WORK_DIR" apt install -y \
    papirus-icon-theme \
    fonts-dejavu \
    fonts-liberation \
    imagemagick \
    wget

# icons dir
mkdir -p "$WORK_DIR/usr/share/NexUSB/icons/tools"

# fetch/build tool logos
echo "Downloading and creating tool logos..."
if [ -f "assets/download-logos.sh" ]; then
    chmod +x assets/download-logos.sh
    ./assets/download-logos.sh
else
    echo "Warning: Logo download script not found, using fallbacks"
fi

# copy gui app
mkdir -p "$WORK_DIR/usr/share/NexUSB"
cp -r gui/* "$WORK_DIR/usr/share/NexUSB/"
chmod +x "$WORK_DIR/usr/share/NexUSB/nex-gui.py"

# copy icons
if [ -d "assets/icons" ]; then
    cp -r assets/icons/* "$WORK_DIR/usr/share/NexUSB/icons/"
else
    echo "Warning: Icons directory not found"
fi

# desktop entry
cat > "$WORK_DIR/usr/share/applications/NexUSB.desktop" << 'EOF'
[Desktop Entry]
Version=1.0
Type=Application
Name=NexUSB Toolkit
Comment=Professional System Rescue & Recovery
Exec=/usr/share/NexUSB/nex-gui.py
Icon=/usr/share/NexUSB/icons/nex-icon.png
Terminal=false
Categories=System;Utility;
Keywords=rescue;recovery;malware;disk;network;
EOF

# autostart
mkdir -p "$WORK_DIR/etc/xdg/autostart"
cp "$WORK_DIR/usr/share/applications/NexUSB.desktop" \
   "$WORK_DIR/etc/xdg/autostart/"

# openbox launches the gui
mkdir -p "$WORK_DIR/etc/xdg/openbox"
cat > "$WORK_DIR/etc/xdg/openbox/autostart" << 'EOF'
# Set wallpaper
feh --bg-scale /usr/share/NexUSB/icons/background.png &

# Launch NexUSB GUI
/usr/share/NexUSB/nex-gui.py &
EOF

# --- live login ---
# the rescue tools need root (dd, mount, shred, fdisk, ...), so boot straight
# into the openbox desktop as root via lxdm autologin. a known root password
# is also set so the TTYs / su work. SECURITY: this is a live rescue image with
# a well-known password; do not expose it to untrusted networks or enable the
# RDP/SSH servers on it without changing the password first.
echo "Configuring live autologin..."
echo "root:nexusb" | chroot "$WORK_DIR" chpasswd

mkdir -p "$WORK_DIR/etc/lxdm"
cat > "$WORK_DIR/etc/lxdm/lxdm.conf" << 'EOF'
[base]
# autologin straight into the desktop, no prompt
autologin=root
session=/usr/bin/openbox-session
greeter=/usr/lib/lxdm/lxdm-greeter-gtk

[server]
arg=/usr/bin/X -background vt1

[display]
theme=Industrial
gtk_theme=Adwaita
EOF

# allow root to start a graphical session
if [ -f "$WORK_DIR/etc/pam.d/lxdm" ]; then
    sed -i 's/^\(auth.*pam_succeed_if.*user.*!= *root.*\)/# \1/' \
        "$WORK_DIR/etc/pam.d/lxdm" 2>/dev/null || true
fi

# Brand the greeter: the lxdm GTK themes show a top image (login.png) and have
# no title label, so render a "NexUSB Login" banner and drop it in as login.png
# for every installed theme. Plain text only (no markup/semicolons).
echo "Branding the login greeter..."
nex_login_banner="$WORK_DIR/tmp/nex-login.png"
if convert -size 460x110 xc:none -gravity center \
        -stroke black -strokewidth 2 -fill white -pointsize 38 \
        -annotate 0 "NexUSB Login" "$nex_login_banner" 2>/dev/null; then
    for theme_dir in "$WORK_DIR"/usr/share/lxdm/themes/*/; do
        [ -d "$theme_dir" ] || continue
        if [ -f "$theme_dir/greeter.ui" ] || [ -f "$theme_dir/greeter-gtk3.ui" ]; then
            cp "$nex_login_banner" "$theme_dir/login.png"
        fi
    done
    rm -f "$nex_login_banner"
else
    echo "Warning: could not render login banner (convert failed)"
fi

echo "Professional GUI installed"
