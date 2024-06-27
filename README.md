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
- zsh

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

## Additional Information
- **Oh My Zsh** is a great add-on to the termina: [Oh My Zsh GitHub](https://github.com/ohmyzsh/ohmyzsh)
- **Rkhunter** (a rootkit hunter) can be configured using this [guide](https://docs.vultr.com/how-to-install-rkhunter-on-debian-10).

## Setup Zsh
Remember to set up zsh and add the following to your root `.zshrc` file (`nano ~/.zshrc`) and your user home folder (`/home/$USER/.zshrc`):

```bash
alias l='ls'
alias la='ls -a'
alias ll='ls -al'
alias aptupdate='dpkg --configure -a && apt update && apt upgrade -y && apt install -f && flatpak update -y && apt clean && apt autoclean && apt autoremove -y'
alias sudo='su -'
alias servicestat='service --status-all'
```

Then apply changes by running:

```bash
source /root/.zshrc
source /home/$USER/.zshrc
```

This script aims to streamline the installation process of essential applications and configurations on Debian 12.
