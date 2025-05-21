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

# Update system and upgrade packages
echo "Getting system ready for packages to be installed..."
apt-get update
apt-get upgrade -y

# Install necessary packages
echo "Installing necessary packages..."
apt-get install -y curl gufw git gdebi gnome-tweaks gparted htop openvpn rkhunter synaptic tilix vlc wget zip apt-transport-https flatpak util-linux zram-config 

# Fix broken dependencies
echo "Fixing any broken dependencies..."
apt-get --fix-broken install -y

# Install VeraCrypt and Balena Etcher
echo "Installing VeraCrypt and Balena Etcher..."
wget -q https://launchpad.net/veracrypt/trunk/1.26.20/+download/veracrypt-1.26.20-Debian-12-amd64.deb
wget -q https://github.com/balena-io/etcher/releases/download/v2.1.0/balena-etcher_2.1.0_amd64.deb
dpkg -i veracrypt*.deb --force-confnew
dpkg -i balena*.deb --force-confnew
rm veracrypt*.deb balena*.deb

# Install FlatPak packages
echo "Installing FlatPak packages..."
flatpak install -y --no-upgrade flathub org.gnome.DejaDup org.bleachbit.BleachBit com.google.Chrome org.deluge_torrent.deluge com.github.johnfactotum.Foliate org.mozilla.firefox org.kde.ghostwriter org.gimp.GIMP org.libreoffice.LibreOffice io.github.hvdwofl.jExifToolGUI com.nordpass.NordPass org.telegram.desktop com.github.unrud.VideoDownloader com.visualstudio.code io.github.flattool.Warehouse io.webtorrent.WebTorrent

# Download Github Raw files and Chmod them
echo "Downloading and setting up rkhunter-check script..."
wget -q https://raw.githubusercontent.com/AmirIqbal1/rkhunter-script/master/rkhunter-check.sh
wget -q https://raw.githubusercontent.com/AmirIqbal1/Flatpak-cleaner/refs/heads/main/flatpak_cleanup.sh
chmod +x rkhunter-check.sh flatpak_cleanup.sh

echo "Downloading GitHub Repos (these will need configuring):"
git clone -q https://github.com/AmirIqbal1/bluelight-filter
git clone -q https://github.com/AmirIqbal1/hardening-debian

echo "Running manual SSD TRIM..."
fstrim -av

echo "Setting up periodic SSD TRIM with systems & tlp (for sys performance)"
systemctl enable fstrim.timer
systemctl start fstrim.timer

echo "Installing tlp"
apt install tlp
systemctl enable tlp

# Clean up and fix any remaining issues
echo "Cleaning up and fixing any remaining issues..."
apt-get autoremove -y

echo ""
echo -e "\e[42mrkhunter has been installed, please configure it using link in README.md file."

echo ""
echo ""
echo "All done! You should check above to see if any errors occurred. A system reboot is recommended."
