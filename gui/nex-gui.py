#!/usr/bin/env python3
"""NexUSB GTK toolkit launcher."""

import gi
gi.require_version('Gtk', '3.0')
from gi.repository import Gtk, Gdk, GdkPixbuf, Gio
import subprocess
import os

ICON_PATH = "/usr/share/NexUSB/icons/tools"
ICON_SIZE = 64

class NexUSBApp(Gtk.Window):
    def __init__(self):
        Gtk.Window.__init__(self, title="NexUSB Toolkit")
        self.set_default_size(1000, 700)
        self.set_position(Gtk.WindowPosition.CENTER)
        
        # window icon, ignore if missing
        try:
            self.set_icon_from_file("/usr/share/NexUSB/icons/nex-icon.png")
        except:
            pass
        
        self.apply_custom_style()
        
        main_box = Gtk.Box(orientation=Gtk.Orientation.VERTICAL, spacing=0)
        self.add(main_box)
        
        header = self.create_header()
        main_box.pack_start(header, False, False, 0)
        
        # sidebar + content
        content_box = Gtk.Box(orientation=Gtk.Orientation.HORIZONTAL, spacing=0)
        main_box.pack_start(content_box, True, True, 0)
        
        sidebar = self.create_sidebar()
        content_box.pack_start(sidebar, False, False, 0)
        
        self.content_stack = Gtk.Stack()
        self.content_stack.set_transition_type(Gtk.StackTransitionType.SLIDE_LEFT_RIGHT)
        content_box.pack_start(self.content_stack, True, True, 0)
        
        # pages
        self.add_home_page()
        self.add_security_page()
        self.add_recovery_page()
        self.add_disk_page()
        self.add_network_page()
        self.add_remote_page()
        self.add_system_page()
        
        # status bar
        statusbar = self.create_statusbar()
        main_box.pack_start(statusbar, False, False, 0)
    
    def load_icon(self, icon_name, size=ICON_SIZE):
        """Load tool icon, fall back to theme."""
        icon_path = f"{ICON_PATH}/{icon_name}.png"
        
        try:
            if os.path.exists(icon_path):
                pixbuf = GdkPixbuf.Pixbuf.new_from_file_at_scale(icon_path, size, size, True)
                return Gtk.Image.new_from_pixbuf(pixbuf)
        except Exception as e:
            print(f"Error loading icon {icon_name}: {e}")
        
        # try icon theme
        try:
            return Gtk.Image.new_from_icon_name(icon_name, Gtk.IconSize.DIALOG)
        except:
            # last resort generic icon
            return Gtk.Image.new_from_icon_name("application-x-executable", Gtk.IconSize.DIALOG)
    
    def apply_custom_style(self):
        """Load the CSS theme."""
        css_provider = Gtk.CssProvider()
        css = b"""
        window {
            background: linear-gradient(135deg, #001a33 0%, #000814 100%);
        }
        
        .header {
            background: linear-gradient(90deg, #001a33 0%, #003366 100%);
            border-bottom: 3px solid #0066cc;
            padding: 20px;
            box-shadow: 0 2px 10px rgba(0, 102, 204, 0.3);
        }
        
        .header-title {
            color: #ffffff;
            font-size: 28px;
            font-weight: bold;
            text-shadow: 0 2px 4px rgba(0,0,0,0.5);
        }
        
        .sidebar {
            background: linear-gradient(180deg, #001a33 0%, #001122 100%);
            border-right: 2px solid #0066cc;
            min-width: 220px;
            box-shadow: 2px 0 10px rgba(0, 0, 0, 0.3);
        }
        
        .sidebar button {
            background: transparent;
            border: none;
            border-left: 3px solid transparent;
            padding: 18px 25px;
            color: #99ccff;
            text-align: left;
            font-size: 15px;
            font-weight: 500;
            transition: all 0.3s ease;
        }
        
        .sidebar button:hover {
            background: linear-gradient(90deg, rgba(0, 102, 204, 0.3) 0%, transparent 100%);
            color: #ffffff;
            border-left-color: #66b3ff;
            padding-left: 30px;
        }
        
        .sidebar button:active {
            background: linear-gradient(90deg, #0066cc 0%, rgba(0, 102, 204, 0.5) 100%);
            color: #ffffff;
            border-left-color: #66b3ff;
            border-left-width: 4px;
        }
        
        .content-area {
            background: #000814;
            padding: 30px;
        }
        
        .tool-card {
            background: linear-gradient(135deg, #002244 0%, #001a33 100%);
            border: 2px solid #0066cc;
            border-radius: 12px;
            padding: 25px;
            margin: 12px;
            min-width: 220px;
            box-shadow: 0 4px 15px rgba(0, 102, 204, 0.2);
            transition: all 0.3s ease;
        }
        
        .tool-card:hover {
            background: linear-gradient(135deg, #003366 0%, #002244 100%);
            border-color: #66b3ff;
            box-shadow: 0 8px 25px rgba(0, 102, 204, 0.4);
            transform: translateY(-5px);
        }
        
        .tool-title {
            color: #ffffff;
            font-size: 16px;
            font-weight: bold;
            margin-bottom: 8px;
        }
        
        .tool-description {
            color: #99ccff;
            font-size: 13px;
            line-height: 1.4;
        }
        
        .category-title {
            color: #66b3ff;
            font-size: 24px;
            font-weight: bold;
            margin: 25px 0 15px 0;
            border-bottom: 3px solid #0066cc;
            padding-bottom: 12px;
        }
        
        .action-button {
            background: linear-gradient(135deg, #0066cc 0%, #0052a3 100%);
            border: 2px solid #66b3ff;
            border-radius: 8px;
            color: #ffffff;
            padding: 12px 24px;
            font-weight: bold;
            font-size: 14px;
            box-shadow: 0 2px 8px rgba(0, 102, 204, 0.3);
            transition: all 0.3s ease;
        }
        
        .action-button:hover {
            background: linear-gradient(135deg, #0080ff 0%, #0066cc 100%);
            box-shadow: 0 4px 15px rgba(0, 102, 204, 0.6);
            transform: translateY(-2px);
        }
        
        .action-button:active {
            transform: translateY(0px);
            box-shadow: 0 2px 8px rgba(0, 102, 204, 0.4);
        }
        
        .statusbar {
            background: linear-gradient(90deg, #001a33 0%, #001122 100%);
            border-top: 2px solid #0066cc;
            padding: 10px 20px;
            color: #99ccff;
            font-size: 12px;
            box-shadow: 0 -2px 10px rgba(0, 0, 0, 0.3);
        }
        
        scrolledwindow {
            background: transparent;
        }
        
        .welcome-text {
            color: #66b3ff;
            font-size: 32px;
            font-weight: bold;
            text-shadow: 0 2px 8px rgba(0, 102, 204, 0.5);
        }
        """
        css_provider.load_from_data(css)
        Gtk.StyleContext.add_provider_for_screen(
            Gdk.Screen.get_default(),
            css_provider,
            Gtk.STYLE_PROVIDER_PRIORITY_APPLICATION
        )
    
    def create_header(self):
        header = Gtk.Box(orientation=Gtk.Orientation.HORIZONTAL, spacing=15)
        header.get_style_context().add_class('header')
        
        # logo, fall back to text label
        try:
            logo_pixbuf = GdkPixbuf.Pixbuf.new_from_file_at_scale(
                "/usr/share/NexUSB/icons/nex-logo.png", 200, 40, True
            )
            logo = Gtk.Image.new_from_pixbuf(logo_pixbuf)
            header.pack_start(logo, False, False, 0)
        except:
            title = Gtk.Label()
            title.set_markup('<span size="x-large" weight="bold" color="#66b3ff">NexUSB</span>')
            header.pack_start(title, False, False, 0)
        
        subtitle = Gtk.Label()
        subtitle.set_markup('<span color="#99ccff">Professional System Rescue Toolkit</span>')
        header.pack_start(subtitle, False, False, 0)
        
        # spacer
        header.pack_start(Gtk.Box(), True, True, 0)
        
        status = Gtk.Label()
        status.set_markup('<span color="#66b3ff">v1.0 | Ready</span>')
        header.pack_end(status, False, False, 0)
        
        return header
    
    def create_sidebar(self):
        sidebar = Gtk.Box(orientation=Gtk.Orientation.VERTICAL, spacing=0)
        sidebar.get_style_context().add_class('sidebar')
        
        buttons = [
            ("Home", "home"),
            ("Security", "security"),
            ("Recovery", "recovery"),
            ("Disk Tools", "disk"),
            ("Network", "network"),
            ("Remote Access", "remote"),
            ("System Info", "system"),
        ]
        
        for label, page_name in buttons:
            btn = Gtk.Button(label=label)
            btn.connect("clicked", self.on_sidebar_clicked, page_name)
            sidebar.pack_start(btn, False, False, 0)
        
        sidebar.pack_start(Gtk.Box(), True, True, 0)
        
        separator = Gtk.Separator(orientation=Gtk.Orientation.HORIZONTAL)
        sidebar.pack_start(separator, False, False, 5)
        
        reboot_btn = Gtk.Button(label="Reboot")
        reboot_btn.connect("clicked", self.on_reboot)
        sidebar.pack_start(reboot_btn, False, False, 0)
        
        shutdown_btn = Gtk.Button(label="Shutdown")
        shutdown_btn.connect("clicked", self.on_shutdown)
        sidebar.pack_start(shutdown_btn, False, False, 0)
        
        return sidebar
    
    def create_statusbar(self):
        statusbar = Gtk.Box(orientation=Gtk.Orientation.HORIZONTAL, spacing=10)
        statusbar.get_style_context().add_class('statusbar')
        
        status = Gtk.Label(label="System: Ready")
        statusbar.pack_start(status, False, False, 0)
        
        statusbar.pack_start(Gtk.Label(label="|"), False, False, 0)
        
        network = Gtk.Label(label="Network: Connected")
        statusbar.pack_start(network, False, False, 0)
        
        statusbar.pack_start(Gtk.Box(), True, True, 0)
        
        version = Gtk.Label(label="NexUSB v1.0")
        statusbar.pack_end(version, False, False, 0)
        
        return statusbar
    
    def create_tool_card(self, icon_name, title, description, command):
        """Build one tool card (icon, title, desc, launch button)."""
        card = Gtk.Box(orientation=Gtk.Orientation.VERTICAL, spacing=10)
        card.get_style_context().add_class('tool-card')
        
        icon = self.load_icon(icon_name, 64)
        card.pack_start(icon, False, False, 0)
        
        title_label = Gtk.Label()
        title_label.set_markup(f'<span weight="bold" size="large" color="#ffffff">{title}</span>')
        card.pack_start(title_label, False, False, 0)
        
        desc_label = Gtk.Label(label=description)
        desc_label.set_line_wrap(True)
        desc_label.set_max_width_chars(25)
        desc_label.get_style_context().add_class('tool-description')
        card.pack_start(desc_label, False, False, 0)
        
        btn = Gtk.Button(label="Launch")
        btn.get_style_context().add_class('action-button')
        btn.connect("clicked", self.launch_tool, command)
        card.pack_start(btn, False, False, 0)
        
        return card

    
    def add_home_page(self):
        """Home page: welcome + quick-action cards."""
        scroll = Gtk.ScrolledWindow()
        box = Gtk.Box(orientation=Gtk.Orientation.VERTICAL, spacing=20)
        box.set_margin_start(30)
        box.set_margin_end(30)
        box.set_margin_top(30)
        
        welcome = Gtk.Label()
        welcome.set_markup(
            '<span size="x-large" weight="bold" color="#66b3ff">Welcome to NexUSB</span>\n'
            '<span color="#99ccff">Select a tool category from the sidebar</span>'
        )
        box.pack_start(welcome, False, False, 20)
        
        grid = Gtk.FlowBox()
        grid.set_valign(Gtk.Align.START)
        grid.set_max_children_per_line(4)
        grid.set_selection_mode(Gtk.SelectionMode.NONE)
        
        quick_actions = [
            ("clamav", "Malware Scan", "Scan for viruses", "clamtk"),
            ("testdisk", "Data Recovery", "Recover lost files", "testdisk"),
            ("gparted", "Disk Manager", "Manage partitions", "gparted"),
            ("wireshark", "Network Tools", "Analyze traffic", "wireshark"),
            ("remmina", "Remote Access", "Connect remotely", "remmina"),
            ("hardinfo", "System Info", "View hardware", "hardinfo"),
        ]
        
        for icon, title, desc, cmd in quick_actions:
            card = self.create_tool_card(icon, title, desc, cmd)
            grid.add(card)
        
        box.pack_start(grid, True, True, 0)
        scroll.add(box)
        self.content_stack.add_titled(scroll, "home", "Home")
    
    def add_security_page(self):
        # security tools
        scroll = Gtk.ScrolledWindow()
        box = Gtk.Box(orientation=Gtk.Orientation.VERTICAL, spacing=20)
        box.set_margin_start(30)
        box.set_margin_end(30)
        box.set_margin_top(30)
        
        title = Gtk.Label()
        title.set_markup('<span size="large" weight="bold" color="#66b3ff">Security & Malware Scanning</span>')
        title.set_halign(Gtk.Align.START)
        box.pack_start(title, False, False, 0)
        
        grid = Gtk.FlowBox()
        grid.set_valign(Gtk.Align.START)
        grid.set_max_children_per_line(4)
        grid.set_selection_mode(Gtk.SelectionMode.NONE)
        
        tools = [
            ("clamav", "ClamAV", "Antivirus scanner", "clamtk"),
            ("chkrootkit", "Rootkit Hunter", "Detect rootkits", "x-terminal-emulator -e 'sudo chkrootkit; read'"),
            ("lynis", "Security Audit", "System security check", "x-terminal-emulator -e 'sudo lynis audit system; read'"),
            ("nmap", "Network Scanner", "Scan for threats", "zenmap"),
            ("aircrack", "WiFi Security", "Wireless auditing", "x-terminal-emulator -e aircrack-ng"),
            ("metasploit", "Metasploit", "Penetration testing", "x-terminal-emulator -e msfconsole"),
        ]
        
        for icon, title, desc, cmd in tools:
            card = self.create_tool_card(icon, title, desc, cmd)
            grid.add(card)
        
        box.pack_start(grid, True, True, 0)
        scroll.add(box)
        self.content_stack.add_titled(scroll, "security", "Security")
    
    def add_recovery_page(self):
        # recovery / repair tools
        scroll = Gtk.ScrolledWindow()
        box = Gtk.Box(orientation=Gtk.Orientation.VERTICAL, spacing=20)
        box.set_margin_start(30)
        box.set_margin_end(30)
        box.set_margin_top(30)
        
        title = Gtk.Label()
        title.set_markup('<span size="large" weight="bold" color="#66b3ff">System Recovery & Repair</span>')
        title.set_halign(Gtk.Align.START)
        box.pack_start(title, False, False, 0)
        
        grid = Gtk.FlowBox()
        grid.set_valign(Gtk.Align.START)
        grid.set_max_children_per_line(4)
        grid.set_selection_mode(Gtk.SelectionMode.NONE)
        
        tools = [
            ("testdisk", "TestDisk", "Recover partitions", "x-terminal-emulator -e 'sudo testdisk; read'"),
            ("photorec", "PhotoRec", "Recover files", "x-terminal-emulator -e 'sudo photorec; read'"),
            ("bootrepair", "Boot Repair", "Fix boot problems", "boot-repair"),
            ("clonezilla", "Clonezilla", "Clone disk", "x-terminal-emulator -e clonezilla"),
            ("foremost", "Foremost", "File carving", "x-terminal-emulator -e foremost"),
            ("ddrescue", "ddrescue", "Rescue damaged drives", "x-terminal-emulator -e ddrescue"),
        ]
        
        for icon, title, desc, cmd in tools:
            card = self.create_tool_card(icon, title, desc, cmd)
            grid.add(card)
        
        box.pack_start(grid, True, True, 0)
        scroll.add(box)
        self.content_stack.add_titled(scroll, "recovery", "Recovery")
    
    def add_disk_page(self):
        # disk tools
        scroll = Gtk.ScrolledWindow()
        box = Gtk.Box(orientation=Gtk.Orientation.VERTICAL, spacing=20)
        box.set_margin_start(30)
        box.set_margin_end(30)
        box.set_margin_top(30)
        
        title = Gtk.Label()
        title.set_markup('<span size="large" weight="bold" color="#66b3ff">Disk Management</span>')
        title.set_halign(Gtk.Align.START)
        box.pack_start(title, False, False, 0)
        
        grid = Gtk.FlowBox()
        grid.set_valign(Gtk.Align.START)
        grid.set_max_children_per_line(4)
        grid.set_selection_mode(Gtk.SelectionMode.NONE)
        
        tools = [
            ("gparted", "GParted", "Partition editor", "gparted"),
            ("baobab", "Disk Usage", "Analyze space", "baobab"),
            ("smart", "SMART Check", "Check disk health", "gnome-disks"),
            ("crystaldiskinfo", "CrystalDiskInfo", "Disk health (Win)", "wine /path/to/CrystalDiskInfo.exe"),
            ("crystaldiskmark", "CrystalDiskMark", "Disk benchmark", "gnome-disks"),
            ("fdisk", "fdisk", "Partition tool", "x-terminal-emulator -e 'sudo fdisk -l; read'"),
        ]
        
        for icon, title, desc, cmd in tools:
            card = self.create_tool_card(icon, title, desc, cmd)
            grid.add(card)
        
        box.pack_start(grid, True, True, 0)
        scroll.add(box)
        self.content_stack.add_titled(scroll, "disk", "Disk Tools")
    
    def add_network_page(self):
        # network tools
        scroll = Gtk.ScrolledWindow()
        box = Gtk.Box(orientation=Gtk.Orientation.VERTICAL, spacing=20)
        box.set_margin_start(30)
        box.set_margin_end(30)
        box.set_margin_top(30)
        
        title = Gtk.Label()
        title.set_markup('<span size="large" weight="bold" color="#66b3ff">Network Diagnostics</span>')
        title.set_halign(Gtk.Align.START)
        box.pack_start(title, False, False, 0)
        
        grid = Gtk.FlowBox()
        grid.set_valign(Gtk.Align.START)
        grid.set_max_children_per_line(4)
        grid.set_selection_mode(Gtk.SelectionMode.NONE)
        
        tools = [
            ("wireshark", "Wireshark", "Packet analyzer", "wireshark"),
            ("nmap", "Nmap", "Network scanner", "zenmap"),
            ("iftop", "Bandwidth Monitor", "Monitor traffic", "x-terminal-emulator -e 'sudo iftop; read'"),
            ("kismet", "WiFi Analyzer", "Analyze WiFi", "kismet"),
            ("nethogs", "Network Config", "Configure network", "nm-connection-editor"),
            ("tcpdump", "tcpdump", "Packet capture", "x-terminal-emulator -e 'sudo tcpdump; read'"),
        ]
        
        for icon, title, desc, cmd in tools:
            card = self.create_tool_card(icon, title, desc, cmd)
            grid.add(card)
        
        box.pack_start(grid, True, True, 0)
        scroll.add(box)
        self.content_stack.add_titled(scroll, "network", "Network")
    
    def add_remote_page(self):
        # remote access tools
        scroll = Gtk.ScrolledWindow()
        box = Gtk.Box(orientation=Gtk.Orientation.VERTICAL, spacing=20)
        box.set_margin_start(30)
        box.set_margin_end(30)
        box.set_margin_top(30)
        
        title = Gtk.Label()
        title.set_markup('<span size="large" weight="bold" color="#66b3ff">Remote Access & Control</span>')
        title.set_halign(Gtk.Align.START)
        box.pack_start(title, False, False, 0)
        
        grid = Gtk.FlowBox()
        grid.set_valign(Gtk.Align.START)
        grid.set_max_children_per_line(4)
        grid.set_selection_mode(Gtk.SelectionMode.NONE)
        
        tools = [
            ("remmina", "Remmina", "RDP/VNC client", "remmina"),
            ("vnc", "VNC Server", "Share screen", "x-terminal-emulator -e 'x11vnc -display :0; read'"),
            ("ssh", "SSH Client", "Secure shell", "x-terminal-emulator"),
            ("teamviewer", "TeamViewer", "Remote support", "teamviewer"),
            ("anydesk", "AnyDesk", "Remote desktop", "anydesk"),
            ("xrdp", "RDP Server", "Accept RDP", "x-terminal-emulator -e 'sudo systemctl start xrdp; read'"),
        ]
        
        for icon, title, desc, cmd in tools:
            card = self.create_tool_card(icon, title, desc, cmd)
            grid.add(card)
        
        box.pack_start(grid, True, True, 0)
        scroll.add(box)
        self.content_stack.add_titled(scroll, "remote", "Remote Access")
    
    def add_system_page(self):
        # system info tools
        scroll = Gtk.ScrolledWindow()
        box = Gtk.Box(orientation=Gtk.Orientation.VERTICAL, spacing=20)
        box.set_margin_start(30)
        box.set_margin_end(30)
        box.set_margin_top(30)
        
        title = Gtk.Label()
        title.set_markup('<span size="large" weight="bold" color="#66b3ff">System Information</span>')
        title.set_halign(Gtk.Align.START)
        box.pack_start(title, False, False, 0)
        
        grid = Gtk.FlowBox()
        grid.set_valign(Gtk.Align.START)
        grid.set_max_children_per_line(4)
        grid.set_selection_mode(Gtk.SelectionMode.NONE)
        
        tools = [
            ("hardinfo", "Hardware Info", "View hardware", "hardinfo"),
            ("htop", "System Monitor", "Monitor resources", "x-terminal-emulator -e htop"),
            ("cpuz", "CPU-Z", "CPU details (Win)", "wine /path/to/cpuz.exe"),
            ("memtest", "Memory Test", "Test RAM", "x-terminal-emulator -e memtester"),
            ("sensors", "Sensors", "Temperature & fans", "psensor"),
            ("lshw", "System Report", "Generate report", "x-terminal-emulator -e 'sudo lshw; read'"),
        ]
        
        for icon, title, desc, cmd in tools:
            card = self.create_tool_card(icon, title, desc, cmd)
            grid.add(card)
        
        box.pack_start(grid, True, True, 0)
        scroll.add(box)
        self.content_stack.add_titled(scroll, "system", "System Info")
    
    def on_sidebar_clicked(self, button, page_name):
        self.content_stack.set_visible_child_name(page_name)
    
    def launch_tool(self, button, command):
        try:
            subprocess.Popen(command, shell=True)
        except Exception as e:
            dialog = Gtk.MessageDialog(
                transient_for=self,
                flags=0,
                message_type=Gtk.MessageType.ERROR,
                buttons=Gtk.ButtonsType.OK,
                text="Error launching tool"
            )
            dialog.format_secondary_text(str(e))
            dialog.run()
            dialog.destroy()
    
    def on_reboot(self, button):
        dialog = Gtk.MessageDialog(
            transient_for=self,
            flags=0,
            message_type=Gtk.MessageType.QUESTION,
            buttons=Gtk.ButtonsType.YES_NO,
            text="Reboot System?"
        )
        dialog.format_secondary_text("Are you sure you want to reboot?")
        response = dialog.run()
        if response == Gtk.ResponseType.YES:
            subprocess.run(["reboot"])
        dialog.destroy()
    
    def on_shutdown(self, button):
        dialog = Gtk.MessageDialog(
            transient_for=self,
            flags=0,
            message_type=Gtk.MessageType.QUESTION,
            buttons=Gtk.ButtonsType.YES_NO,
            text="Shutdown System?"
        )
        dialog.format_secondary_text("Are you sure you want to shutdown?")
        response = dialog.run()
        if response == Gtk.ResponseType.YES:
            subprocess.run(["poweroff"])
        dialog.destroy()

if __name__ == "__main__":
    app = NexUSBApp()
    app.connect("destroy", Gtk.main_quit)
    app.show_all()
    Gtk.main()
