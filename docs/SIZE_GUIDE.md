# NexUSB Size Guide

## Size Breakdown

### Minimal Build (8-10GB)
- Base Linux system: 2GB
- Essential tools: 1GB
- Boot environment: 500MB
- Windows tools (essential): 2GB
- Core rescue ISOs: 3GB
- Free space: 1.5GB

**Includes:**
- NexUSB live environment
- Basic malware scanning (ClamAV)
- System recovery (TestDisk, PhotoRec)
- Disk tools (GParted)
- Essential Windows portables
- 3-5 rescue ISOs

### Standard Build (20-24GB)
- Base Linux system: 3GB
- Full tool collection: 3GB
- Boot environment: 1GB
- Windows tools (full): 5GB
- ISO collection: 8GB
- Free space: 4GB

**Includes:**
- Everything from minimal
- Full antivirus suite
- Penetration testing tools
- 100+ Windows portable apps
- 15-20 bootable ISOs
- Kali Linux or Parrot Security

### Full Build (32GB)
- Base Linux system: 4GB
- Complete tool suite: 4GB
- Boot environment: 1GB
- Windows tools (complete): 8GB
- Large ISO collection: 12GB
- Free space: 3GB

**Includes:**
- Everything from standard
- Multiple security distros
- Full Windows installation media
- Complete antivirus collection
- 30+ bootable ISOs
- Specialized forensics tools

### Maximum Build (64GB)
- Base Linux system: 5GB
- All tools + extras: 5GB
- Boot environment: 2GB
- Windows tools (all): 12GB
- Massive ISO collection: 35GB
- Persistent storage: 5GB

**Includes:**
- Everything from full build
- 50+ Linux distributions
- Multiple Windows versions
- Complete security toolkit
- Gaming and entertainment ISOs
- Large persistent storage area

## Recommended Configurations

### For Personal Use (32GB)
Best balance of tools and portability. Includes all essential recovery and security tools with room for customization.

### For IT Professionals (64GB)
Complete toolkit with every major distribution and tool. Suitable for professional system administration and security work.

### For Quick Rescue (16GB)
Streamlined version with just the essentials. Fast to build and deploy, perfect for emergency situations.

## Customizing Your Build

Edit `build.sh` to specify size:
```bash
sudo ./build.sh 32  # For 32GB build
sudo ./build.sh 64  # For 64GB build
```

### Reducing Size

Remove unwanted tools from:
- `config/tools.conf` - Linux tools
- `config/windows-tools.conf` - Windows applications
- `config/iso-collection.conf` - Bootable ISOs

### Increasing Size

Add more ISOs to the collection:
- Download additional distributions
- Include specialized tools
- Add Windows installation media
- Include game emulation systems

## Storage Breakdown by Category

### Linux Tools (2-4GB)
- Security: 800MB
- Recovery: 600MB
- Disk tools: 400MB
- Network: 500MB
- Utilities: 700MB

### Windows Tools (5-12GB)
- Antivirus: 2-4GB
- Recovery: 1-2GB
- System utilities: 1-2GB
- Portable apps: 1-2GB
- Drivers: 500MB-1GB

### ISO Collection (3-35GB)
- Rescue tools: 2-4GB
- Security distros: 4-10GB
- Linux distributions: 10-20GB
- Windows media: 6-12GB
- Specialized: 2-5GB

## Tips for Managing Size

1. Use compression for tools when possible
2. Remove duplicate functionality
3. Download ISOs on-demand rather than pre-loading
4. Use persistent storage for downloaded content
5. Regularly update and remove outdated tools
6. Consider cloud storage for rarely-used ISOs
