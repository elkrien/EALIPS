#!/bin/sh
#
# Elkrien's Arch Linux Installation Script (EALIS)
# by MM <elkrien@gmail.com>
# based & inspired on LARBS by Luke Smith (thanx)
# License: GNU GPLv3
#


## VARIABLES:

#[ -z "$dotfilesrepo" ] && dotfilesrepo="https://github.com/lukesmithxyz/voidrice.git"
[ -z "$progsfile" ] && progsfile="https://raw.githubusercontent.com/elkrien/EALIS/main/packages.csv"
[ -z "$aurhelper" ] && aurhelper="paru"
[ -z "$repobranch" ] && repobranch="main"

### FUNCTIONS ###

# Error function

error() { \
	clear 
	tput setaf 1 
	printf "ERROR:\\n%s\\n" "$1" >&2 
	echo 
	tput sgr0 
	exit 1
	}

# Welcome function

welcome() { \
	dialog \
	--backtitle "Elkrien's Arch Linux Installation Script" \
	--title " WELCOME! " \
	--msgbox "\\n\\nWelcome to Elkrien's Arch Linux Installation Script!\\n\\nThis script will automatically install a selected desktop environment and all programs needed to have a nice and ready Arch Linux :)\\n\\nJust answer few questions on next screens and we can start..." \
	14 75

	dialog \
	--backtitle "Elkrien's Arch Linux Installation Script" \
	--title " IMPORTANT NOTE! " \
	--yes-label "Ready!" \
	--no-label "Exit..." \
	--yesno "\\nBe sure the computer you are using has current pacman updates and refreshed Arch keyrings.\\n\\nIf it does not, the installation of some programs might fail.\\n" \
	10 70
	}

# Questions function

questions() { \
	DE=$(dialog \
	--backtitle "Elkrien's Arch Linux Installation Script" \
	--title " DESKTOP ENVIRONMENT " \
	--clear \
	--menu "\\nPlease select Desktop Environment You want to use:" 10 60 5 \
	"XFCE"  "with LightDM greeter" \
	"GNOME" "with GDM greeter" \
	3>&1 1>&2 2>&3 3>&1) || { clear; exit 1; }
	
	if (dialog \
	--backtitle "Elkrien's Arch Linux Installation Script" \
	--title " LAPTOP BATTERY POWER MANAGEMENT " \
	--clear \
	--yesno "\\nDo You want to install TLP (Laptop Battery Power Management)?" 7 65); then LAPTOP=YES; else LAPTOP=NO; fi 

	if (dialog \
	--backtitle "Elkrien's Arch Linux Installation Script" \
	--title " BLUETOOTH " \
	--clear \
	--yesno "\\nDo You want to install Bluetooth service?" 7 55); then BTH=YES; else BTH=NO; fi 
	}

# Final Confirmation

preinstallmsg() { \ 
	dialog \
	--backtitle "Elkrien's Arch Linux Installation Script" \
	--title " LET'S START! " \
	--yes-label "Let's go!" \
	--no-label "No, nevermind!" \
	--yesno "\\nThe rest of the installation will now be totally automated, so you can sit back and relax.\\n\\nPlease be patient - depending on Your's computer it will take some time.\\n\\nNow just press <Let's go!> and the system will begin installation!" \
	14 60 || { clear; exit 1; }
	}	

### THE ACTUAL SCRIPT ###

# Allow user to run sudo without password - to not interrupt script when password is needed

[ -f /etc/sudoers.pacnew ] && cp /etc/sudoers.pacnew /etc/sudoers # Just in case
sudo sed -i "/%wheel/d" /etc/sudoers
sudo bash -c 'echo "%wheel ALL=(ALL) NOPASSWD: ALL" >> /etc/sudoers'

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

# Asking some questions

questions || error "User exited"

# Make pacman and paru colorful

grep -q "^Color" /etc/pacman.conf || sed -i "s/^#Color$/Color/" /etc/pacman.conf
grep -q "ILoveCandy" /etc/pacman.conf || sed -i "/#VerbosePkgLists/a ILoveCandy" /etc/pacman.conf


# Overwrite sudoers back and allow the user to run
# serveral important commands, `shutdown`, `reboot`, updating, etc. without a password.

sudo sed -i "/%wheel/d" /etc/sudoers
sudo bash -c 'echo "%wheel ALL=(ALL) ALL #LARBS
%wheel ALL=(ALL) NOPASSWD: /usr/bin/shutdown,/usr/bin/reboot,/usr/bin/wifi-menu,/usr/bin/mount,/usr/bin/umount,/usr/bin/pacman -Syu,/usr/bin/pacman -Syyu,/usr/bin/systemctl restart NetworkManager,/usr/bin/pacman -Syyu --noconfirm,/usr/bin/loadkeys,/usr/bin/paru,/usr/bin/pacman -Syyuw --noconfirm" >> etc/sudoers'


