# install.sh — Debian 12 Auto Setup Script

![Debian](https://img.shields.io/badge/Debian-12-red?logo=debian)
![Shell Script](https://img.shields.io/badge/script-bash-1f425f.svg)
![Maintained](https://img.shields.io/badge/maintained-yes-brightgreen)

A bash script that automates the installation of essential desktop apps, developer tools, security enhancements, and performance optimizations for **Debian 12**.

---

## TL;DR

This script:

- Installs popular apps (Firefox, Chrome, VS Code, GIMP, etc.) using APT or .deb
- Adds SSD and RAM performance optimizations
- Configures swap compression (zram) and filesystem cache
- Installs TLP for better laptop battery life
- Downloads extra scripts for hardening and maintenance
- Uses Flatpak only where no APT alternative is ideal

---

## How to Use

Run the following commands as **root**:

```bash
chmod +x install.sh
./install.sh
```
## APT Installed Applications

curl, wget, zip, gdebi

apt-transport-https, software-properties-common

ca-certificates, gnupg, lsb-release

htop, gparted, gufw, gnome-tweaks

synaptic, tilix, openvpn, vlc

rkhunter, preload, zram-tools

util-linux, flatpak

## Flatpak Apps Replaced with APT/.deb Versions

Firefox (via official Mozilla APT repository)

Google Chrome (via .deb)

Visual Studio Code (via Microsoft APT repository)

GIMP

Deluge

BleachBit

Foliate

## Other .deb Installed Packages (via wget)
VeraCrypt (Debian 12-specific)

Balena Etcher

Google Chrome

## Flatpak Applications

LibreOffice

jExifToolGUI

NordPass

Telegram

Video Downloader

Warehouse (Flatpak Manager)

WebTorrent

## System Enhancements
SSD TRIM Support
Executes fstrim -av (trims SSD)

Enables fstrim.timer with systemd

TLP (Battery Optimization)
Installed with apt

Automatically enabled on boot

## Memory & Cache Tweaks
Installs zram-tools to compress swap in RAM

Runs swapon --show to confirm active swap

Applies vm.vfs_cache_pressure=50 for better file caching

Persists setting in /etc/sysctl.conf

## Additional Scripts & Repositories
| Tool/Repo                                                             | Description                           |
| --------------------------------------------------------------------- | ------------------------------------- |
| [`rkhunter-check`](https://github.com/AmirIqbal1/rkhunter-script)     | Automates security scans via rkhunter |
| [`flatpak_cleanup.sh`](https://github.com/AmirIqbal1/Flatpak-cleaner) | Removes unused Flatpak data           |
| [`bluelight-filter`](https://github.com/AmirIqbal1/bluelight-filter)  | Blue light screen tint Python script  |
| [`hardening-debian`](https://github.com/AmirIqbal1/hardening-debian)  | Security hardening tools for Debian   |

## Rootkit Hunter (rkhunter)
rkhunter is installed to check for backdoors and rootkits.

[`How to configure rkhunter`](https://tecadmin.net/how-to-install-rkhunter-on-ubuntu)


## After installation completes, a system reboot is recommended.

