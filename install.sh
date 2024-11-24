#!/bin/bash

# Check if running as root
if [ "$(id -u)" -ne 0 ]; then
  echo "Only a root user may run this. Please login as root."
  exit 1
fi

echo ""
read -p "This script will auto install selected programs on Debian 12. View the README file to see what gets installed." -t 6
echo ""

# Update system and install required packages
echo "Getting system ready for packages to be installed..."
dpkg --configure -a
apt-get update
apt-get upgrade -y
apt-get install -f -y
apt-get clean
apt-get autoclean

# Install necessary packages
apt-get install -y curl gufw git gdebi gnome-tweaks gparted htop openvpn rkhunter synaptic tilix wget zip zsh apt-transport-https flatpak

# Fix broken dependencies
echo "Fixing any broken dependencies..."
apt-get --fix-broken install -y

# Install VeraCrypt and Balena Etcher
echo "Installing VeraCrypt and Balena Etcher..."
wget https://launchpad.net/veracrypt/trunk/1.26.14/+download/veracrypt-1.26.14-Debian-12-amd64.deb
wget https://github.com/balena-io/etcher/releases/download/v1.19.25/balena-etcher_1.19.25_amd64.deb
dpkg -i veracrypt*.deb
dpkg -i balena*.deb
rm veracrypt*.deb balena*.deb

# Install Flatpak packages
echo "Installing FlatPak packages..."
flatpak install -y flathub org.gnome.DejaDup org.bleachbit.BleachBit com.brave.Browser com.google.Chrome org.deluge_torrent.deluge com.github.johnfactotum.Foliate org.mozilla.firefox org.gimp.GIMP org.libreoffice.LibreOffice io.github.hvdwofl.jExifToolGUI com.nordpass.NordPass org.telegram.desktop com.visualstudio.code org.videolan.VLC io.webtorrent.WebTorrent

# Download and set up rkhunter-check script & download backup script (needs config)
echo "Downloading and setting up rkhunter-check script..."
wget https://raw.githubusercontent.com/AmirIqbal1/rkhunter-script/master/rkhunter-check.sh
chmod +x rkhunter-check.sh

echo "Downloading backup script..."
git clone https://github.com/AmirIqbal1/backup-script

# Clean up and fix any remaining issues
echo "Cleaning up and fixing any remaining issues..."
dpkg --configure -a
apt install -f -y
apt clean
apt autoclean
apt autoremove -y

echo ""
echo -e "\e[42mrkhunter has been installed, please configure it using link in README.md file."

echo ""
echo ""
echo "All done! You should check above to see if any errors occurred. A system reboot is recommended."
