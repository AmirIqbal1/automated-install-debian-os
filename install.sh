#!/bin/bash

set -e
set -u
set -o pipefail

# Must be run as root
if [ "$EUID" -ne 0 ]; then
  echo "Please run this script as root using: su -"
  exit 1
fi

echo "This script will auto install selected programs on Debian (Tested on Debian 12). View the README file to see what gets installed."
sleep 5

# Update system
echo "Updating system..."
apt-get update && apt-get upgrade -y

# Install core packages
echo "Installing core packages..."
apt-get install -y \
  curl wget zip gdebi apt-transport-https software-properties-common ca-certificates gnupg lsb-release \
  gufw git gnome-tweaks gparted htop openvpn rkhunter synaptic tilix vlc \
  flatpak util-linux preload zram-tools libreoffice bleachbit deluge foliate gimp code \
  thunderbird plank tlp gnome-software-plugin-flatpak

# Enable Flatpak and Flathub on Debian
echo "Setting up Flatpak support..."
flatpak remote-add --if-not-exists flathub https://dl.flathub.org/repo/flathub.flatpakrepo

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

# Install VeraCrypt and Balena Etcher
echo "Installing VeraCrypt and Balena Etcher..."
wget -q https://launchpad.net/veracrypt/trunk/1.26.20/+download/veracrypt-1.26.20-Debian-12-amd64.deb
wget -q https://github.com/balena-io/etcher/releases/download/v2.1.0/balena-etcher_2.1.0_amd64.deb
dpkg -i veracrypt*.deb balena*.deb || apt-get install -f -y
rm veracrypt*.deb balena*.deb

# Install Firefox via Mozilla APT repo
echo "Installing Firefox from Mozilla APT repo..."
install -d -m 0755 /etc/apt/keyrings
wget -q https://packages.mozilla.org/apt/repo-signing-key.gpg -O- | tee /etc/apt/keyrings/packages.mozilla.org.asc > /dev/null
echo "deb [signed-by=/etc/apt/keyrings/packages.mozilla.org.asc] https://packages.mozilla.org/apt mozilla main" | tee /etc/apt/sources.list.d/mozilla.list > /dev/null
echo 'Package: *
Pin: origin packages.mozilla.org
Pin-Priority: 1000' | tee /etc/apt/preferences.d/mozilla
apt-get update && apt-get install -y firefox

# Install Chrome
echo "Installing Google Chrome..."
wget -q https://dl.google.com/linux/direct/google-chrome-stable_current_amd64.deb
dpkg -i google-chrome*.deb || apt-get install -f -y
rm google-chrome*.deb

# Install VS Code via Microsoft APT repo
echo "Installing VS Code via Microsoft repository..."
wget -qO- https://packages.microsoft.com/keys/microsoft.asc | gpg --dearmor > /etc/apt/keyrings/vscode.gpg
echo "deb [signed-by=/etc/apt/keyrings/vscode.gpg] https://packages.microsoft.com/repos/vscode stable main" \
  | tee /etc/apt/sources.list.d/vscode.list > /dev/null
apt-get update && apt-get install -y code

# Install Spotify via APT repo
echo "Installing Spotify..."
curl -sS https://download.spotify.com/debian/pubkey_C85668DF69375001.gpg | gpg --dearmor --yes -o /etc/apt/trusted.gpg.d/spotify.gpg
echo "deb https://repository.spotify.com stable non-free" | tee /etc/apt/sources.list.d/spotify.list
apt-get update && apt-get install -y spotify-client

# Install WebTorrent Desktop manually from GitHub
echo "Installing WebTorrent Desktop via GitHub .deb..."
wget -q https://github.com/webtorrent/webtorrent-desktop/releases/download/v0.24.0/webtorrent-desktop_0.24.0_amd64.deb
dpkg -i webtorrent-desktop_0.24.0_amd64.deb || apt-get install -f -y
rm webtorrent-desktop_0.24.0_amd64.deb

# Removes Deja Dup Backups APT package
echo "Removing Deja Dup Backups APT package..."
apt-get remove --purge -y deja-dup

# Flatpak apps (minimal, non-duplicated with APT)
echo "Installing remaining Flatpak apps..."
flatpak install -y --no-upgrade flathub \
  org.gnome.DejaDup \
  org.telegram.desktop \
  com.github.unrud.VideoDownloader \
  io.github.flattool.Warehouse \
  io.github.hvdwofl.jExifToolGUI \
  com.nordpass.NordPass \
  org.gnome.DejaDup

# Download additional scripts
echo "Downloading rkhunter-check & flatpak cleanup script..."
wget -q https://raw.githubusercontent.com/AmirIqbal1/rkhunter-script/master/rkhunter-check.sh
wget -q https://raw.githubusercontent.com/AmirIqbal1/Flatpak-cleaner/refs/heads/main/flatpak_cleanup.sh
chmod +x rkhunter-check.sh flatpak_cleanup.sh

# Clone GitHub tools
echo "Cloning GitHub repositories..."
git clone -q https://github.com/AmirIqbal1/hardening-debian

# Enable SSD TRIM
echo "Running SSD TRIM and enabling scheduled TRIM..."
fstrim -av
systemctl enable --now fstrim.timer

# Enable TLP (power management)
echo "Enabling TLP..."
systemctl enable --now tlp

# Add current user to sudo group
CURRENT_USER=$(logname)
echo "Adding user '$CURRENT_USER' to sudo group..."
usermod -aG sudo "$CURRENT_USER"

# Cleanup
echo "Cleaning up..."
apt-get autoremove -y
apt-get clean
apt-get autoclean

echo ""
echo -e "\e[42mInstallation complete. rkhunter and other tools are ready to be configured. A system reboot is recommended.\e[0m"
