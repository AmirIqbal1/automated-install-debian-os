# install.sh

This bash script will automatically install selected desktop programs on Debian OS. It is specifically tested on Debian 12.

## Instructions

To start the download and installation of this script, please run as root:

```bash
chmod +x install.sh
./install.sh
```

## Installed Applications

### Via `apt` and `dpkg`
- Balena Etcher
- curl
- flatpak
- gdebi
- git
- gnome-tweak-tool
- gparted
- gufw
- htop
- openvpn
- rkhunter
- synaptic
- tilix
- unrar
- VeraCrypt (for Debian 12)
- virtualbox
- wget
- y-ppa-manager
- zip

### Via `wget` and `dpkg`
- Balena Etcher
- VeraCrypt

### Via Flatpak
- Déjà Dup (backup)
- BleachBit
- Brave Browser
- Chrome
- Deluge
- Foliate
- Firefox
- GIMP
- LibreOffice
- jExifToolGUI
- NordPass
- Telegram
- Visual Studio Code
- VLC
- WebTorrent

## Additional Scripts
- Downloads and sets up the rkhunter-check script from [GitHub](https://github.com/AmirIqbal1/rkhunter-script).
- Get my backup script from [GitHub](https://github.com/AmirIqbal1/backup-script).
- Gets my bluelight_filter repo from [GitHub](https://github.com/AmirIqbal1/bluelight-filter).
- Toughen your debain install with this from [GitHub](https://github.com/AmirIqbal1/hardening-debian).

## Additional Information
- **Rkhunter** (a rootkit hunter) can be configured using this [guide](https://docs.vultr.com/how-to-install-rkhunter-on-debian-10).

This script aims to streamline the installation process of essential applications and configurations on Debian 12.
