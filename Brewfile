# NexUSB build prerequisites (macOS).
#
# These are the host tools the containerised Linux build needs. Install with:
#   brew bundle --file=Brewfile
#
# Note: the build runs amd64 containers under QEMU emulation. Rosetta cannot
# run the amd64 dpkg/debootstrap reliably, so colima must be started with
# --vm-type qemu:
#   colima start --vm-type qemu --cpu 4 --memory 8 --disk 60

brew "colima"   # lightweight Linux VM + Docker runtime for macOS
brew "docker"   # docker CLI (talks to the colima daemon)
brew "qemu"     # CPU emulation for cross-arch (amd64-on-Apple-Silicon) builds
