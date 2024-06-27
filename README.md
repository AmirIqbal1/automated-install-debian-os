# install.sh

This bash script will auto install selected desktop programs on Debian OS. Working on Debian 12.

To start the download of this script, please run as root:


chmod +x install.sh
./install.sh

Installs the below apps via apt and dpkg;

balena etcher, curl, flatpak, gdebi, git, gnome-tweak-tool, gparted, gufw, htop, openvpn, rkhunter, synaptic, tilix, unrar, veracrypt (for debian 12), virtualbox, wget, y-ppa-manager, zip, zsh.


Installs via wget and dpkg: balenaetcher & veracrypt.


It will auto install all the below apps using FlatPak:

backup (Déjà Dup), bleachbit, brave browser, chrome, deluge, foliate, firefox, gimp, libreoffice, jExifToolGUI, nordpass, telegram, visual studio code, vlc, webtorrent.


Get's my other scripts (rkhunter-script)

oh my zsh is a great add-on to zsh: https://github.com/ohmyzsh/ohmyzsh

Also installs rkhunter (a rootkit hunter) which can be configured with the below link:

https://docs.vultr.com/how-to-install-rkhunter-on-debian-10


Remember to setup zsh, and add this to your root zshrc file (nano ~/.zshrc) & in your user home folder (/home/$USER/.zshrc).

alias l='ls'  
alias la='ls -a'  
alias ll='ls -al'   
alias aptupdate='dpkg --configure -a && apt update && apt upgrade -y && apt install -f && apt clean && apt autoclean && apt autoremove -y'      
alias sudo='su -'  
alias servicestat='service --status-all'  

then (source /root/.zshrc) & (source /home/$USER/.zshrc) to apply changes.
