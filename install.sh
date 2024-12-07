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
apt-get install -y curl gufw git gdebi gnome-tweaks gparted htop openvpn rkhunter synaptic tilix wget zip apt-transport-https flatpak

# Fix broken dependencies
echo "Fixing any broken dependencies..."
apt-get --fix-broken install -y

# Install VeraCrypt and Balena Etcher
echo "Installing VeraCrypt and Balena Etcher..."
wget -q https://launchpad.net/veracrypt/trunk/1.26.14/+download/veracrypt-1.26.14-Debian-12-amd64.deb
wget -q https://github.com/balena-io/etcher/releases/download/v1.19.25/balena-etcher_1.19.25_amd64.deb
dpkg -i veracrypt*.deb --force-confnew
dpkg -i balena*.deb --force-confnew
rm veracrypt*.deb balena*.deb

# Install FlatPak packages
echo "Installing FlatPak packages..."
flatpak install -y --no-upgrade flathub org.gnome.DejaDup org.bleachbit.BleachBit com.brave.Browser io.github.celluloid_player.Celluloid com.google.Chrome org.deluge_torrent.deluge com.github.johnfactotum.Foliate org.mozilla.firefox org.gimp.GIMP org.libreoffice.LibreOffice io.github.hvdwofl.jExifToolGUI com.nordpass.NordPass org.telegram.desktop com.visualstudio.code org.videolan.VLC io.webtorrent.WebTorrent

# Download and set up rkhunter-check script & download backup script (needs config)
echo "Downloading and setting up rkhunter-check script..."
wget -q https://raw.githubusercontent.com/AmirIqbal1/rkhunter-script/master/rkhunter-check.sh
chmod +x rkhunter-check.sh

echo "Downloading GitHub Repos (these will need configuring):"
git clone -q https://github.com/AmirIqbal1/backup-script
git clone -q https://github.com/AmirIqbal1/bluelight-filter
git clone -q https://github.com/AmirIqbal1/hardening-debian

# Clean up and fix any remaining issues
echo "Cleaning up and fixing any remaining issues..."
apt-get autoremove -y

echo ""
echo -e "\e[42mrkhunter has been installed, please configure it using link in README.md file."

echo ""
echo ""
echo "All done! You should check above to see if any errors occurred. A system reboot is recommended."
