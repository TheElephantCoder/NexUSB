# Using Windows Tools from NexUSB

## How Windows Tools Work

NexUSB includes Windows portable applications (like Malwarebytes, CPU-Z, etc.) that can be used in two ways:

### Method 1: Boot into Windows PE Environment (Recommended)

**What is Windows PE?**
Windows PE (Preinstallation Environment) is a minimal Windows system that boots from USB, similar to how NexUSB's Linux environment works.

**Using Hiren's BootCD PE (Included in NexUSB):**

1. Boot NexUSB USB drive
2. From GRUB menu, select "Hiren's BootCD PE"
3. Boots into Windows PE environment
4. Navigate to NexUSB partition (usually D: or E:)
5. Go to `Windows-Tools` folder
6. Run Malwarebytes or other Windows tools
7. Scan the infected Windows installation (usually C:)

**Advantages:**
- Windows tools run natively
- Full functionality
- Can scan offline Windows installations
- Malware can't interfere (Windows PE is clean)

### Method 2: Boot into Infected Windows (Less Safe)

1. Boot into your regular Windows installation
2. Insert NexUSB USB drive
3. Navigate to USB drive in File Explorer
4. Go to `Windows-Tools\Antivirus` folder
5. Run Malwarebytes portable
6. Scan system

**Disadvantages:**
- Malware is running and can interfere
- Some malware blocks antivirus tools
- Less effective than offline scanning

### Method 3: Use Wine in Linux (Limited)

Some Windows tools can run in Linux using Wine, but with limitations:

```bash
# Install Wine (if not already installed)
sudo apt install wine

# Run Windows tool
wine /path/to/tool.exe
```

**Note:** Not all tools work well with Wine, especially antivirus software.

## Using Malwarebytes

### Option A: From Hiren's BootCD PE (Best Method)

**Step-by-step:**

1. **Boot NexUSB**
   - Insert USB and restart
   - Select NexUSB from boot menu

2. **Select Hiren's BootCD PE**
   - From GRUB menu, choose "Hiren's BootCD PE"
   - Wait for Windows PE to load

3. **Locate Malwarebytes**
   - Open File Explorer
   - Navigate to NexUSB partition (D: or E:)
   - Go to `Windows-Tools\Antivirus\`
   - Find `Malwarebytes.exe` or `mbam-setup.exe`

4. **Run Malwarebytes**
   - Double-click to launch
   - If installer, install to RAM disk (X:\)
   - Update definitions (if internet available)

5. **Scan Infected System**
   - Select "Scan" or "Threat Scan"
   - Choose C: drive (infected Windows installation)
   - Wait for scan to complete (30-60 minutes)

6. **Remove Threats**
   - Review detected threats
   - Click "Quarantine" or "Remove"
   - Restart to Windows

**Why This Works:**
- Windows PE is clean and isolated
- Malware on C: drive isn't running
- Malwarebytes has full access to scan
- Malware can't defend itself or hide

### Option B: From Regular Windows (If System Still Boots)

**Step-by-step:**

1. **Boot into Windows**
   - Boot your regular Windows (if possible)

2. **Insert NexUSB**
   - Plug in NexUSB drive
   - Open in File Explorer

3. **Navigate to Malwarebytes**
   - Go to `Windows-Tools\Antivirus\`
   - Find Malwarebytes portable

4. **Run as Administrator**
   - Right-click Malwarebytes
   - Select "Run as Administrator"

5. **Update and Scan**
   - Update definitions
   - Run "Threat Scan" or "Custom Scan"
   - Remove detected threats

**Limitations:**
- Active malware may interfere
- Some rootkits can hide from scanners
- Less effective than offline scanning

### Option C: Malwarebytes Bootable (If Available)

Some versions of Malwarebytes offer bootable rescue environments:

1. Download Malwarebytes Bootable from another PC
2. Add ISO to NexUSB ISO collection
3. Boot from Malwarebytes ISO
4. Scan infected system

## Other Windows Tools Usage

### Antivirus Tools

**AdwCleaner (Adware Removal):**
- Location: `Windows-Tools\Antivirus\adwcleaner.exe`
- Use: Boot Windows PE or regular Windows
- Run: Double-click, click "Scan Now"
- Purpose: Removes adware, PUPs, browser hijackers

**Kaspersky Virus Removal Tool:**
- Location: `Windows-Tools\Antivirus\KVRT.exe`
- Use: Boot Windows PE or regular Windows
- Run: Double-click, accept EULA, click "Start Scan"
- Purpose: Detects and removes viruses, trojans

**McAfee Stinger:**
- Location: `Windows-Tools\Antivirus\stinger.exe`
- Use: Boot Windows PE or regular Windows
- Run: Double-click, click "Scan Now"
- Purpose: Removes specific virus families

**Norton Power Eraser:**
- Location: `Windows-Tools\Antivirus\NPE.exe`
- Use: Boot Windows PE or regular Windows
- Run: Double-click, click "Scan for Risks"
- Purpose: Aggressive malware removal

### System Information Tools

**CPU-Z:**
- Location: `Windows-Tools\SystemInfo\cpu-z.exe`
- Use: Boot Windows PE or regular Windows
- Run: Double-click
- Purpose: View CPU information

**GPU-Z:**
- Location: `Windows-Tools\SystemInfo\GPU-Z.exe`
- Use: Boot Windows PE or regular Windows
- Run: Double-click
- Purpose: View GPU information

**CrystalDiskInfo:**
- Location: `Windows-Tools\SystemInfo\CrystalDiskInfo.exe`
- Use: Boot Windows PE or regular Windows
- Run: Double-click
- Purpose: Check hard drive health (SMART)

**HWiNFO:**
- Location: `Windows-Tools\SystemInfo\hwinfo.exe`
- Use: Boot Windows PE or regular Windows
- Run: Double-click
- Purpose: Comprehensive hardware information

### Data Recovery Tools

**Recuva:**
- Location: `Windows-Tools\Recovery\recuva.exe`
- Use: Boot Windows PE or regular Windows
- Run: Double-click, follow wizard
- Purpose: Recover deleted files

**TestDisk (Windows version):**
- Location: `Windows-Tools\Recovery\testdisk_win.exe`
- Use: Boot Windows PE or regular Windows
- Run: From command prompt
- Purpose: Recover lost partitions

### Utilities

**7-Zip:**
- Location: `Windows-Tools\Utilities\7zip.exe`
- Use: Boot Windows PE or regular Windows
- Run: Double-click
- Purpose: Extract compressed files

**Rufus:**
- Location: `Windows-Tools\Utilities\rufus.exe`
- Use: Boot regular Windows
- Run: Double-click
- Purpose: Create bootable USB drives

**Everything Search:**
- Location: `Windows-Tools\Utilities\Everything.exe`
- Use: Boot Windows PE or regular Windows
- Run: Double-click
- Purpose: Fast file search

## Hiren's BootCD PE Details

**What's Included:**
- Windows 10 PE environment
- 100+ portable tools pre-installed
- Network support
- Disk tools
- Recovery tools
- Antivirus tools

**How to Access:**
1. Boot NexUSB
2. Select "Hiren's BootCD PE" from menu
3. Wait for Windows PE to load (2-3 minutes)
4. Desktop appears with tool shortcuts

**Pre-installed Tools in Hiren's:**
- Malwarebytes
- AdwCleaner
- Many tools already included
- Plus access to NexUSB Windows-Tools partition

**Network Access:**
- Windows PE includes network drivers
- Can connect to internet
- Update antivirus definitions
- Download additional tools

## Comparison: Linux vs Windows PE Scanning

| Feature | Linux (ClamAV) | Windows PE (Malwarebytes) |
|---------|----------------|---------------------------|
| Boot Time | Fast (30-60s) | Slower (2-3 min) |
| Malware Detection | Good (8M+ signatures) | Excellent (specialized) |
| Windows Malware | Good | Excellent |
| Linux Malware | Excellent | Limited |
| Rootkit Detection | Good | Excellent |
| Adware/PUP Detection | Limited | Excellent |
| Resource Usage | Low | Higher |
| Ease of Use | Command-line | GUI |

**Recommendation:**
- Use **both** for comprehensive scanning
- Start with ClamAV in Linux (fast, safe)
- Follow up with Malwarebytes in Windows PE (thorough)

## Workflow: Complete Malware Removal

**Step 1: Boot NexUSB Linux**
1. Boot NexUSB
2. Select "NexUSB Live Environment"
3. Run ClamAV scan from Security menu
4. Remove detected threats
5. Note any suspicious files

**Step 2: Boot Hiren's BootCD PE**
1. Reboot NexUSB
2. Select "Hiren's BootCD PE"
3. Run Malwarebytes from NexUSB partition
4. Scan C: drive
5. Remove additional threats

**Step 3: Boot Regular Windows**
1. Reboot to Windows
2. Run Windows Defender full scan
3. Update all software
4. Change passwords
5. Monitor for suspicious activity

**Total Time:** 2-3 hours for thorough cleaning

## Troubleshooting

### Malwarebytes Won't Run in Windows PE
- Check if file is corrupted
- Try different version (portable vs installer)
- Some versions require full Windows
- Use alternative: AdwCleaner, Kaspersky VRT

### Can't Find Windows-Tools Partition
- In Windows PE, check all drive letters (D:, E:, F:)
- Look for partition labeled "WINTOOLS"
- Use Disk Management to view all partitions

### Tools Require Internet
- Windows PE includes network drivers
- Connect ethernet cable or WiFi
- Some tools work offline with older definitions

### Tool Says "Not Compatible"
- Some tools require full Windows
- Try in regular Windows instead of PE
- Check tool requirements

## Adding Your Own Windows Tools

1. Download portable version of tool
2. Copy to `Windows-Tools\[Category]\` folder
3. Organize by category:
   - Antivirus
   - Recovery
   - SystemInfo
   - Utilities
   - Network

4. Rebuild NexUSB or copy directly to USB

## Best Practices

**For Malware Scanning:**
1. Always scan offline (Windows PE or Linux)
2. Update definitions before scanning
3. Use multiple scanners for thoroughness
4. Save scan logs for reference
5. Quarantine before deleting (in case of false positives)

**For System Recovery:**
1. Boot Windows PE for Windows tools
2. Use Linux environment for cross-platform tools
3. Always backup before making changes
4. Test tools on clean system first

**For Security:**
1. Don't boot infected Windows if avoidable
2. Use offline scanning when possible
3. Change passwords from clean system
4. Verify tools are from official sources

## Summary

**Windows tools in NexUSB work best when:**
- Used from Hiren's BootCD PE environment
- Scanning offline Windows installations
- Combined with Linux-based ClamAV scanning
- Updated with latest definitions

**Malwarebytes specifically:**
- Excellent for Windows malware, adware, PUPs
- Best used from Windows PE environment
- Complements ClamAV scanning
- Industry-leading detection rates

This dual-environment approach (Linux + Windows PE) gives you the best of both worlds for comprehensive system rescue and malware removal.
