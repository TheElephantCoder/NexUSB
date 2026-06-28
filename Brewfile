# NexUSB build prerequisites (macOS).
#
# These are the host tools the containerised Linux build needs. Install with:
#   brew bundle --file=Brewfile
# The NexUSB Flasher app runs this automatically before a build.
#
# Note: the build runs amd64 containers under QEMU emulation. Rosetta cannot
# run the amd64 dpkg/debootstrap reliably, so colima must be started with
# --vm-type qemu (the Flasher does this for you).

brew "colima"   # lightweight Linux VM + Docker runtime for macOS
brew "docker"   # docker CLI (talks to the colima daemon)
brew "qemu"     # CPU emulation for cross-arch (amd64-on-Apple-Silicon) builds
