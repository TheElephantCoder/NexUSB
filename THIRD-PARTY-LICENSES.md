# Third-Party License Review

**Not legal advice.** This is a license/compliance assessment by tool, not a
lawyer's review. "Redistributable" below means "may be included in a NexUSB
image that you give to others." Before distributing — especially commercially —
confirm each tool's current license and, for the proprietary ones, get counsel.

Two recurring points:

- **Use vs. redistribute.** Running these tools is almost always allowed. The
  constraint is *bundling* them in an image you hand to others (e.g. sharing the
  ISO). That's where proprietary licenses bite.
- **Listed vs. bundled.** `config/tools.conf`, `config/windows-tools.conf` and
  `config/iso-collection.conf` are *manifests*. Many of those `apt` names don't
  exist in Ubuntu's repos and simply fail to install; the Windows tools and ISOs
  are *downloaded from the vendor at build time*, not stored in this repo.

---

## 1. Minimal build (`build-minimal.sh`) — what actually ships today

All FOSS and redistributable in a **free, open-source** image. Obligations:
preserve copyright/license notices, and for GPL/LGPL binaries either ship the
source or a written offer for it (using Ubuntu's unmodified binaries, you can
point to Ubuntu's source archives / provide a written offer).

| Tool | Package | License | Bundle in a free image? |
|---|---|---|---|
| ClamAV | clamav, clamav-freshclam | GPL-2.0 | Yes |
| chkrootkit | chkrootkit | BSD-2-Clause | Yes |
| TestDisk / PhotoRec | testdisk | GPL-2.0+ | Yes |
| GNU ddrescue | gddrescue | GPL-3.0+ | Yes |
| e2fsprogs | e2fsprogs | GPL-2.0 (libs LGPL/BSD) | Yes |
| GParted | gparted | GPL-2.0+ | Yes |
| util-linux (fdisk) | util-linux | GPL-2.0+/LGPL/BSD | Yes |
| parted | parted | GPL-3.0+ | Yes |
| smartmontools | smartmontools | GPL-2.0+ | Yes |
| **nmap** | nmap | **NPSL** (GPL-2.0-derived) | Yes for a free distro; **commercial redistribution needs a separate license from the Nmap Project** |
| netcat-openbsd | netcat-openbsd | BSD | Yes |
| tcpdump / libpcap | tcpdump | BSD-3-Clause | Yes |
| OpenSSH client | openssh-client | BSD-style (OpenSSH) | Yes |
| Remmina (+RDP/VNC) | remmina, remmina-plugin-* | GPL-2.0+ (OpenSSL exception) | Yes |
| TigerVNC viewer | tigervnc-viewer | GPL-2.0 | Yes |
| xrdp | xrdp | Apache-2.0 | Yes |
| Xorg | xorg | MIT/X11 | Yes |
| Openbox | openbox | GPL-2.0 | Yes |
| LXDM | lxdm | GPL-3.0 | Yes |
| LXTerminal | lxterminal | GPL-2.0+ | Yes |
| PCManFM | pcmanfm | GPL-2.0+ | Yes |
| **Firefox** | firefox | **MPL-2.0** | Yes, but Mozilla's **trademark/distribution policy** applies if you modify it or its config |
| Midnight Commander | mc | GPL-3.0 | Yes |
| nano | nano | GPL-3.0 | Yes |
| Vim (tiny) | vim-tiny | Vim license (charityware, GPL-compatible) | Yes |
| htop | htop | GPL-2.0 | Yes |
| PyGObject / GTK 3 | python3-gi, gir1.2-gtk-3.0, … | LGPL-2.1+ | Yes |
| Papirus icons | papirus-icon-theme | GPL-3.0 | Yes |
| DejaVu fonts | fonts-dejavu | Bitstream Vera / permissive | Yes |
| Liberation fonts | fonts-liberation | SIL OFL-1.1 | Yes |
| ImageMagick | imagemagick | ImageMagick License (Apache-2.0-style) | Yes |
| wget | wget | GPL-3.0 | Yes |
| Ubuntu base + kernel | debootstrap set, linux, live-boot, systemd | GPL-2.0 + many | Yes (Ubuntu remix; don't misuse Ubuntu/Canonical trademarks) |

**Verdict for the minimal ISO:** redistributable as a free, open-source project.
Action items: ship a NOTICE/licenses folder, keep notices intact, provide GPL
source availability, and if you ever *sell* NexUSB, resolve nmap's NPSL
commercial clause (and re-check Firefox branding).

---

## 2. Full build (`config/tools.conf`) — additional Linux packages

FOSS additions beyond the minimal set (all redistributable in a free image):

| Tool | License | Notes |
|---|---|---|
| rkhunter | GPL-2.0+ | Yes |
| Lynis | GPL-3.0 | Yes |
| AIDE | GPL-2.0+ | Yes |
| Fail2ban | GPL-2.0+ | Yes |
| Nikto | GPL-2.0 | Yes |
| John the Ripper | GPL-2.0+ | Yes |
| Hashcat | MIT | Yes |
| Aircrack-ng | GPL-2.0+ | Yes |
| OWASP ZAP (zaproxy) | Apache-2.0 | Yes (may not be in Ubuntu repos) |
| Foremost / Scalpel / extundelete | GPL-2.0 | Yes |
| Clonezilla / Partclone | GPL-2.0/3.0 | Yes |
| Sleuth Kit / Autopsy | IPL/CPL + GPL | Yes (verify Autopsy packaging) |
| Volatility | GPL-2.0 / Volatility SLA | Verify (v3 is custom) |
| Binwalk, bulk-extractor, guymager | MIT/GPL | Yes |
| gdisk, hdparm, sdparm, nvme-cli | GPL-2.0+ | Yes |
| gnome-disk-utility, baobab, partitionmanager, ncdu, duf | GPL/MIT | Yes |
| chntpw, ophcrack | GPL-2.0 | Yes (ophcrack tables are separate downloads) |
| Wireshark | GPL-2.0+ | Yes |
| netcat, iftop, nethogs, iperf3, mtr, traceroute, ethtool, wavemon | GPL/BSD | Yes |
| kismet | GPL-2.0 | Yes |
| hwinfo, lshw, inxi, dmidecode, lm-sensors, stress(-ng), memtest86+, memtester | GPL-2.0+ | Yes (memtest86+ is GPL; the proprietary "MemTest86" is different) |
| neofetch, CPU-X, hardinfo | MIT/GPL | Yes |
| Thunar/Nautilus/ranger/nnn, editors (vim/emacs/gedit/kate/nano), VSCodium | GPL/MIT/MPL | Yes (use **VSCodium**, the MIT build — not Microsoft's "VS Code" binary, whose EULA restricts redistribution) |
| Chromium | BSD-3-Clause | Yes |
| p7zip, unzip, tar, gzip, bzip2, xz-utils | LGPL/GPL/public-domain | Yes |
| rsync, Timeshift, Duplicity, BorgBackup, Restic, rclone | GPL/BSD/MIT | Yes |
| QEMU | GPL-2.0 | Yes |
| Wine | LGPL-2.1+ | Yes |
| git, build-essential, gcc, make, cmake, gdb, python3, nodejs | GPL/MIT/etc. | Yes |
| SQLite, MySQL/PostgreSQL/Redis clients | public-domain/GPL/BSD | Yes (client libs; mysql-client is GPL) |
| VLC, mpv, FFmpeg, GIMP, Inkscape, Audacity | GPL/LGPL | Yes (FFmpeg/VLC: if you enable certain codecs, **patent/codec** concerns exist in some countries) |
| LibreOffice, AbiWord, Gnumeric, Evince, Okular | GPL/MPL | Yes |
| Docker (docker.io) | Apache-2.0 | Yes |

**Problem entries in `tools.conf` — do NOT bundle (proprietary), and most also
don't exist as Ubuntu packages so `apt` skips them:**

| Listed | Reality |
|---|---|
| TeamViewer, AnyDesk, NoMachine, Chrome Remote Desktop | Proprietary EULA — no redistribution. Not in Ubuntu repos. |
| Kon-Boot, PCUnlocker | Commercial, paid. No redistribution. |
| R-Linux (r-linux) | Proprietary freeware (R-TT). No bundling. |
| Burp Suite (burpsuite) | Proprietary (PortSwigger). Not in repos. |
| Metasploit (metasploit-framework) | Framework core is BSD-3-Clause + Rapid7 marks; **not in Ubuntu repos** (needs Rapid7's own repo). Verify before bundling. |
| OpenVAS (openvas) | Now Greenbone; GPL but renamed/repackaged — package won't resolve as-is. |
| unrar | **Non-free** UnRAR license (redistribution allowed but with restrictions; Debian puts it in non-free). Prefer `unar`/`p7zip` for extraction. |
| VirtualBox (virtualbox) | Base is GPL-2.0 (OSE) — OK. **Do not** add the Extension Pack (proprietary PUEL). |
| RustDesk, Guacamole | Actually FOSS (AGPL-3.0 / Apache-2.0) but package names won't resolve in Ubuntu repos as written. |
| SystemRescue, Trinity Rescue Kit, Boot-Repair | These are whole distros/PPA tools, not Ubuntu packages — won't `apt install`. |

---

## 3. `config/windows-tools.conf` — Windows portable apps (download manifest)

These are **downloaded from each vendor at build time** into a Windows-readable
partition; they are not stored in this repo. The list is **overwhelmingly
proprietary freeware/shareware/commercial**. I will not invent per-EULA terms
for ~120 commercial products — the safe rule is:

- **Do NOT bundle any of these in an image you distribute.** Almost every
  freeware EULA here forbids redistribution/repackaging.
- **Microsoft Sysinternals** (Autoruns, Process Explorer/Monitor, TCPView,
  Sysinternals Suite): the license **explicitly prohibits redistribution**.
- **Commercial/trial** (no redistribution): WinRAR, AIDA64, Acronis True Image,
  Macrium Reflect, EaseUS *, MiniTool *, AOMEI *, Paragon, R-Studio, GetDataBack,
  Stellar, Passware, Elcomsoft, HD Tune, Samsung Magician, O&O Defrag, Total
  Commander, IObit/Driver Booster, DriverPack, HitmanPro, Emsisoft, RogueKiller,
  Veeam, etc.
- **Free-but-no-bundle** vendor tools: CCleaner/Recuva/Speccy/Defraggler
  (Piriform), Malwarebytes/AdwCleaner, the AV vendors' removal tools (Kaspersky,
  Bitdefender, ESET, Sophos, Dr.Web, Norton, McAfee, Trend Micro, F-Secure,
  Avast, AVG, Avira), Snappy Driver Installer (check its mixed terms), NirSoft
  utilities (free but redistribution restricted), CPU-Z/GPU-Z/HWMonitor/HWiNFO
  (free, redistribution needs permission).
- **Actually FOSS here (could be bundled with notices):** 7-Zip (LGPL/BSD),
  PeaZip (LGPL), Notepad++ (GPL), SumatraPDF (GPL), HandBrake (GPL), VLC (GPL),
  GIMP (GPL), Audacity (GPL), Ventoy (GPL), Rufus (GPL), UNetbootin (GPL),
  Etcher (Apache-2.0), BleachBit (GPL), Wireshark (GPL), PuTTY (MIT), WinSCP
  (GPL), FileZilla *client* (GPL — not the proprietary "Pro"), WinDirStat (GPL),
  RegShot (GPL/LGPL), MPC-HC (GPL), Git (GPL), Python (PSF), Node.js (MIT).
  VS Code: prefer **VSCodium** (MIT) over Microsoft's branded build.

## 4. `config/iso-collection.conf` — bootable ISO library (download manifest)

Also downloaded from vendors at build time. Verdicts:

- **NEVER redistribute (Microsoft licensing):** Windows 10 / 11 / Server install
  media, and **Hiren's BootCD PE** (it *is* a Windows PE image). Provide a link
  or a user-run downloader only.
- **NEVER redistribute (proprietary AV):** Kaspersky, Bitdefender, AVG, Avira,
  ESET, F-Secure, Sophos, Dr.Web rescue disks. Vendor EULAs forbid it.
- **Proprietary OS / verify:** TrueNAS/pfSense/OPNsense (mostly BSD/Apache, OK,
  but check trademark), commercial NAS/firewall builds, MemTest86 (the paid
  PassMark one — free edition has its own terms; MemTest86**+** is GPL).
- **Generally redistributable FOSS distros (mind trademarks):** Ubuntu/Mint/
  Debian/Fedora*/Manjaro/Pop!_OS/Kali/Parrot/Tails/Clonezilla/GParted Live/
  SystemRescue/Rescuezilla/Redo/ShredOS/DBAN/Alpine/Arch/Gentoo/FreeBSD, etc.
  Most allow redistribution under their licenses, but some (Fedora, Kali, Ubuntu)
  restrict use of their **names/logos** on modified or rebundled media.

---

## Recommendation

For anything you distribute, bundle **only** Section 1/2 FOSS. Treat Sections 3
and 4 as *links the end user fetches themselves*, never as pre-bundled payload —
and never ship Windows PE, Windows installers, commercial AV rescue disks, or
Sysinternals. Add a `licenses/` directory with each bundled tool's license text
and a NOTICE file before publishing.
