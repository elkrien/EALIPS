#!/bin/sh
#
# Elkrien's Arch Linux Installation Script (EALIS)
# by MM <elkrien@gmail.com>
# based on LARBS by Luke Smith (thanx)
# License: GNU GPLv3
#

### FUNCTIONS ###

# Error function

error() { clear; tput setaf 1; printf "ERROR:\\n%s\\n" "$1" >&2; echo; tput sgr0; exit 1;}

# Welcome

welcome() { \
	dialog --backtitle "Elkrien's Arch Linux Installation Script" --title " Welcome! " --msgbox "\\n\\nWelcome to Elkrien's Arch Linux Installation Script!\\n\\nThis script will automatically install a selected desktop environment and all programs needed to have a nice and ready Arch Linux :)\\n\\nJust answer few questions on next screens and we can start..." 14 75

	dialog --backtitle "Elkrien's Arch Linux Installation Script" --title " Important Note! " --yes-label "All ready!" --no-label "Return..." --yesno "\\nBe sure the computer you are using has current pacman updates and refreshed Arch keyrings.\\n\\nIf it does not, the installation of some programs might fail.\\n" 10 70
	}

# Questions

questions() { \
	de=$(dialog --backtitle "Elkrien's Arch Linux Installation Script" --title " DESKTOP ENVIRONMENT " --clear --radiolist "\\nPlease select Desktop Environment You want to use (select with SPACE key):  " 12 61 5 "XFCE"  "with LightDM greeter" ON "GNOME"    "with GDM greeter" off)

	



### THE ACTUAL SCRIPT ###

# Allow user to run sudo without password - to not interrupt script when password is needed

#[ -f /etc/sudoers.pacnew ] && cp /etc/sudoers.pacnew /etc/sudoers # Just in case
#sudo sed -i "/%wheel/d" /etc/sudoers
#sudo bash -c 'echo "%wheel ALL=(ALL) NOPASSWD: ALL" >> /etc/sudoers'

# Clear terminal
clear
 
# Download and install dialog to run actual script

tput setaf 3
echo
echo "######################################################################################"
echo 
echo "       Installing packages needed to run actual script - please wait a moment  "
echo 
echo "######################################################################################"
echo
echo
tput sgr0

sudo pacman --noconfirm --needed -Sy dialog || error "Something is wrong - make sure You are on fresh Arch Linux and have an internet connection"
curl -o ~/.dialogrc https://raw.githubusercontent.com/elkrien/EALIS/main/dialogrc


# Welcome screen

welcome || error "User exited"

# Make pacman and paru colorful

grep -q "^Color" /etc/pacman.conf || sed -i "s/^#Color$/Color/" /etc/pacman.conf
grep -q "ILoveCandy" /etc/pacman.conf || sed -i "/#VerbosePkgLists/a ILoveCandy" /etc/pacman.conf

# ... work in progress


# Overwrite sudoers back and allow the user to run
# serveral important commands, `shutdown`, `reboot`, updating, etc. without a password.

#sudo sed -i "/%wheel/d" /etc/sudoers
#sudo bash -c 'echo "%wheel ALL=(ALL) ALL #LARBS
#%wheel ALL=(ALL) NOPASSWD: /usr/bin/shutdown,/usr/bin/reboot,/usr/bin/wifi-menu,/usr/bin/mount,/usr/bin/umount,/usr/bin/pacman -Syu,/usr/bin/pacman -Syyu,/usr/bin/systemctl restart NetworkManager,/usr/bin/pacman -Syyu --noconfirm,/usr/bin/loadkeys,/usr/bin/paru,/usr/bin/pacman -Syyuw --noconfirm" >> etc/sudoers'


