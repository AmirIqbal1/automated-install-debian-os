#!/bin/bash

#checks if your root
## get UID 
uid=$(id -u)
 
[ $uid -ne 0 ] && { echo "Only a root user may run this. Please login as root."; exit 1; }

echo ""
read -p "This script will auto install selected programs on Ubuntu OS. View the README file to see what gets installed." -t 6
echo ""

#updates system ready for script
echo "getting system ready for packages to be installed"
dpkg --configure -a &&
apt update &&
apt upgrade -y &&
apt install -f &&
apt clean &&
apt autoclean 

apt install curl dconf-editor gufw git gdebi gnome-tweak-tool gparted htop openvpn rkhunter synaptic tilix virtualbox unrar wget zip zsh apt-transport-https -y

echo "installing veracrypt for debian 12 & balenaetcher"
wget https://launchpad.net/veracrypt/trunk/1.26.7/+download/veracrypt-1.26.7-Debian-12-amd64.deb &&
wget https://github.com/balena-io/etcher/releases/download/v1.19.21/balena-etcher_1.19.21_amd64.deb &&
dpkg -i veracrypt*.deb &&
dpkg -i balena*.deb &&
rm veracrypt*.deb balena*.deb

echo "Installing FlatPak packages"
flatpak install flathub org.gnome.DejaDup org.bleachbit.BleachBit com.brave.Browser com.google.Chrome org.deluge_torrent.deluge com.github.johnfactotum.Foliate org.mozilla.firefox org.gimp.GIMP org.libreoffice.LibreOffice io.github.hvdwofl.jExifToolGUI com.nordpass.NordPass org.telegram.desktop com.visualstudio.code org.videolan.VLC io.webtorrent.WebTorrent -y

#auto gets my other script
echo "Grabbing other script: rkhunter-check"
wget https://raw.githubusercontent.com/AmirIqbal1/rkhunter-script/master/rkhunter-check.sh
echo "chmodding above script"
chmod +x rkhunter-check.sh

#fixes any errors and auto cleans packages
echo "auto cleaning now, and fixing any errors."
dpkg --configure -a &&
apt install -f &&
apt clean &&
apt autoclean &&
apt autoremove -y

echo ""
echo -e "\e[42mrkhunter has been installed, please configure it using link in README.md file."

echo ""
echo ""
echo "All done! You should check above to see if any errors occured. A system reboot is recommended."
