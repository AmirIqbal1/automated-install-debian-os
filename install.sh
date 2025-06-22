#!/bin/bash

set -e
set -u
set -o pipefail

# Check if running as root
if [ "$(id -u)" -ne 0 ]; then
  echo "Only a root user may run this. Please run with sudo."
  exit 1
fi

echo ""
read -p "This script will auto install selected programs on Debian (Tested on Debian 12). View the README file to see what gets installed." -t 7
echo ""

# Update system
echo "Updating system..."
apt-get update
apt-get upgrade -y

# Install core packages
echo "Installing core packages..."
apt-get install -y \
  curl wget gufw git gdebi gnome-tweaks gparted htop openvpn rkhunter synaptic tilix vlc zip \
  apt-transport-https flatpak util-linux preload zram-tools software-properties-common ca-certificates gnupg lsb-release

# Show swap info
echo "Verifying swap configuration:"
swapon --show

# Apply sysctl setting for filesystem cache
echo "Applying sysctl tweak for vfs_cache_pressure..."
sysctl vm.vfs_cache_pressure=50
echo "vm.vfs_cache_pressure=50" | tee -a /etc/sysctl.conf

# Fix broken packages if any
echo "Fixing any broken packages..."
apt-get --fix-broken install -y

# VeraCrypt & Balena Etcher (via .deb)
echo "Installing VeraCrypt and Balena Etcher..."
wget -q https://launchpad.net/veracrypt/trunk/1.26.20/+download/veracrypt-1.26.20-Debian-12-amd64.deb
wget -q https://github.com/balena-io/etcher/releases/download/v2.1.0/balena-etcher_2.1.0_amd64.deb
dpkg -i veracrypt*.deb balena*.deb || apt-get install -f -y
rm veracrypt*.deb balena*.deb

# --- APT replacements for Flatpak apps ---

## Firefox official Mozilla build
echo "Installing Firefox from Mozilla APT repo..."
install -d -m 0755 /etc/apt/keyrings
wget -q https://packages.mozilla.org/apt/repo-signing-key.gpg -O- | tee /etc/apt/keyrings/packages.mozilla.org.asc > /dev/null

# Optional: fingerprint verification (manual)
#gpg -n -q --import --import-options import-show /etc/apt/keyrings/packages.mozilla.org.asc | \
#awk '/pub/{getline; gsub(/^ +| +$/,""); if($0 == "35BAA0B33E9EB396F59CA838C0BA5CE6DC6315A3") print "\nThe key fingerprint matches ("$0").\n"; else print "\nVerification failed: the fingerprint ("$0") does not match the expected one.\n"}'

echo "deb [signed-by=/etc/apt/keyrings/packages.mozilla.org.asc] https://packages.mozilla.org/apt mozilla main" | tee /etc/apt/sources.list.d/mozilla.list > /dev/null
echo 'Package: *
Pin: origin packages.mozilla.org
Pin-Priority: 1000' | tee /etc/apt/preferences.d/mozilla

apt-get update
apt-get install -y firefox

## Google Chrome
echo "Installing Google Chrome..."
wget -q https://dl.google.com/linux/direct/google-chrome-stable_current_amd64.deb
dpkg -i google-chrome*.deb || apt-get install -f -y
rm google-chrome*.deb

## GIMP, VS Code, BleachBit, Deluge, Foliate
echo "Installing additional desktop apps..."
apt-get install -y gimp bleachbit deluge foliate

## VS Code (Microsoft APT repo)
echo "Setting up Microsoft VS Code repository..."
wget -qO- https://packages.microsoft.com/keys/microsoft.asc | gpg --dearmor > /etc/apt/keyrings/vscode.gpg
echo "deb [signed-by=/etc/apt/keyrings/vscode.gpg] https://packages.microsoft.com/repos/vscode stable main" \
  | tee /etc/apt/sources.list.d/vscode.list > /dev/null
apt-get update
apt-get install -y code

# Install remaining Flatpak apps
echo "Installing remaining Flatpak apps..."
flatpak install -y --no-upgrade flathub \
  org.gnome.DejaDup \
  org.libreoffice.LibreOffice \
  io.github.hvdwofl.jExifToolGUI \
  com.nordpass.NordPass \
  org.telegram.desktop \
  com.github.unrud.VideoDownloader \
  io.github.flattool.Warehouse \
  io.webtorrent.WebTorrent

# Download additional scripts
echo "Downloading rkhunter-check & flatpak cleanup script..."
wget -q https://raw.githubusercontent.com/AmirIqbal1/rkhunter-script/master/rkhunter-check.sh
wget -q https://raw.githubusercontent.com/AmirIqbal1/Flatpak-cleaner/refs/heads/main/flatpak_cleanup.sh
chmod +x rkhunter-check.sh flatpak_cleanup.sh

# GitHub repo clones
echo "Cloning GitHub repositories..."
git clone -q https://github.com/AmirIqbal1/bluelight-filter
git clone -q https://github.com/AmirIqbal1/hardening-debian

# Enable SSD TRIM
echo "Running SSD TRIM and enabling scheduled TRIM..."
fstrim -av
systemctl enable --now fstrim.timer

# Enable TLP (power management)
echo "Installing and enabling TLP..."
apt install -y tlp
systemctl enable --now tlp

# Cleanup
echo "Cleaning up..."
apt-get autoremove -y
apt-get clean
apt-get autoclean

echo ""
echo -e "\e[42mrkhunter has been installed. Please configure it using the README.md instructions."
echo ""
echo "All done! You should check above to see if any errors occurred. A system reboot is recommended."
