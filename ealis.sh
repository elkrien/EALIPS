#!/bin/sh
#
# Elkrien's Arch Linux Installation Script (EALIS)
# by MM <elkrien@gmail.com>
# based & inspired on LARBS by Luke Smith (thanx)
# License: GNU GPLv3
#


## VARIABLES:
dotfilesrepo="https://github.com/elkrien/dotfiles.git"
progsfile="https://raw.githubusercontent.com/elkrien/EALIS/main/packages.csv"
aurhelper="paru"
repobranch="master"
name=$(id -un)

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
	--title " WELCOME $name ! " \
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

# Final Confirmation function
preinstallmsg() { \
	dialog \
	--backtitle "Elkrien's Arch Linux Installation Script" \
	--title " LET'S START! " \
	--yes-label "Let's go!" \
	--no-label "No, nevermind!" \
	--yesno "\\nThe rest of the installation will now be totally automated, so you can sit back and relax.\\n\\nPlease be patient - depending on Your's computer it will take some time.\\n\\nNow just press <Let's go!> and the system will begin installation!" \
	14 60 || { clear; exit 1; }
	}	

# Refreshing Arch Linux Keyring function
refreshkeys() { \
	dialog \
	--backtitle "Elkrien's Arch Linux Installation Script" \
	--infobox "\\nRefreshing Arch Keyring..." 5 40
	sudo pacman --noconfirm -S archlinux-keyring >/dev/null 2>&1
	}

# Installation of packages using pacman function
installpkg() { 
	sudo pacman --noconfirm --needed -S "$1" >/dev/null 2>&1 
	}

# Installation of AUR helper function
manualinstall() {
	[ -f "/usr/bin/$1" ] || (
	dialog \
	--backtitle "Elkrien's Arch Linux Installation Script" \
	--infobox "\\nInstalling \"$1\", an AUR helper..." 5 50
	cd /tmp || exit 1
	sudo rm -rf /tmp/"$1"*
	sudo curl -sO https://aur.archlinux.org/cgit/aur.git/snapshot/"$1".tar.gz &&
	sudo tar -xvf "$1".tar.gz >/dev/null 2>&1 &&
	cd "$1" &&
	sudo makepkg --noconfirm -si >/dev/null 2>&1
	cd /tmp || return 1) ;}

# Installation of packages for ARCH Linux repositories function
maininstall() { 
	dialog \
	--backtitle "Elkrien's Arch Linux Installation Script" \
	--title " EALIS Installation " \
	--infobox "\\nInstalling \`$1\` ($n of $total) $2" 5 70
	installpkg "$1"
	}

# Installation of packages from AUR repositories function
aurinstall() { \
	dialog \
	--backtitle "Elkrien's Arch Linux Installation Script" \
	--title " EALIS Installation " \
	--infobox "\\nInstalling \`$1\` ($n of $total) from the AUR $2" 6 70
	echo "$aurinstalled" | grep -q "^$1$" && return 1
	$aurhelper -S --noconfirm --needed "$1" >/dev/null 2>&1
	}	

# Installation function for GNOME 
installationloopgnome() { \
	([ -f "$progsfile" ] && cp "$progsfile" /tmp/progs.csv) || curl -Ls "$progsfile" | sed '/^#/d' > /tmp/progs.csv
	let total=$(grep -c "A," /tmp/progs.csv)+$(grep -c "AG," /tmp/progs.csv)+$(grep -c "P," /tmp/progs.csv)+$(grep -c "PG," /tmp/progs.csv)
	aurinstalled=$(sudo pacman -Qqm)
	while IFS=, read -r tag program comment; do
		n=$((n+1))
		echo "$comment" | grep -q "^\".*\"$" && comment="$(echo "$comment" | sed "s/\(^\"\|\"$\)//g")"
		case "$tag" in
			"A") aurinstall "$program" "$comment" ;;
			"AG") aurinstall "$program" "$comment" ;;
			#"G") gitmakeinstall "$program" "$comment" ;;
			"P") maininstall "$program" "$comment" ;;
			"PG") maininstall "$program" "$comment" ;;
		esac
	done < /tmp/progs.csv ;}

# Installation function for XFCE 
installationloopxfce() { \
	([ -f "$progsfile" ] && cp "$progsfile" /tmp/progs.csv) || curl -Ls "$progsfile" | sed '/^#/d' > /tmp/progs.csv
	let total=$(grep -c "A," /tmp/progs.csv)+$(grep -c "AX," /tmp/progs.csv)+$(grep -c "P," /tmp/progs.csv)+$(grep -c "PX," /tmp/progs.csv)
	aurinstalled=$(sudo pacman -Qqm)
	while IFS=, read -r tag program comment; do
		n=$((n+1))
		echo "$comment" | grep -q "^\".*\"$" && comment="$(echo "$comment" | sed "s/\(^\"\|\"$\)//g")"
		case "$tag" in
			"A") aurinstall "$program" "$comment" ;;
			"AX") aurinstall "$program" "$comment" ;;
			#"G") gitmakeinstall "$program" "$comment" ;;
			"P") maininstall "$program" "$comment" ;;
			"PX") maininstall "$program" "$comment" ;;
		esac
	done < /tmp/progs.csv ;}
	
# TLP installation function
tlpinstall() { \
	dialog \
	--backtitle "Elkrien's Arch Linux Installation Script" \
	--title " EALIS Installation " \
	--infobox "\\nInstalling and enabling TLP (battery management for laptops)" 6 70
	installpkg "tlp"
	sudo systemctl enable tlp.service
	}	

# Bluetooth installation function
bthinstall() { \
	dialog \
	--backtitle "Elkrien's Arch Linux Installation Script" \
	--title " EALIS Installation " \
	--infobox "\\nInstalling and enabling Bluetooth" 6 60
	for x in pulseaudio-bluetooth bluez bluez-libs bluez-utils blueberry; do
	installpkg "$x"
	done
	sudo systemctl enable bluetooth.service
	sudo systemctl start bluetooth.service
	sudo sed -i 's/'#AutoEnable=false'/'AutoEnable=true'/g' /etc/bluetooth/main.conf
	}	

# Enabling services function
serviceinstall() {
	dialog \
	--backtitle "Elkrien's Arch Linux Installation Script" \
	--title " EALIS Installation " \
	--infobox "\\nEnabling services (desktop environment, printers, network etc.)" 6 70
	# desktop environment:
	case "$DE" in 						
   		"GNOME") sudo systemctl enable gdm ;;
   		"XFCE") sudo systemctl enable lightdm.service -f ;; 
	esac
	# printers:
	sudo systemctl enable cups.service 	
	# setting nsswitch.conf:
	sudo sed -i 's/files mymachines myhostname/files mymachines/g' /etc/nsswitch.conf #first part
	sudo sed -i 's/\[\!UNAVAIL=return\] dns/\[\!UNAVAIL=return\] mdns dns wins myhostname/g' /etc/nsswitch.conf #last part
	# disable systemd-resolved (not working with avahi) and enable avahi:
	sudo systemctl disable systemd-resolved.service 
	sudo systemctl enable avahi-daemon.service
	}


# Copy dotfiles function

gitdotfiles() { # Downloads a gitrepo $1 and places the files in $2 only overwriting conflicts # zahashować
	dialog \
	--backtitle "Elkrien's Arch Linux Installation Script" \
	--title " EALIS Installation " \
	--infobox "\\nDownloading and installing config files..." 6 60
	[ -z "$3" ] && branch="master" || branch="$repobranch"
	dir=$(mktemp -d)
	[ ! -d "$2" ] && mkdir -p "$2"
	chown "$name":wheel "$dir" "$2"
	sudo -u "$name" git clone --recursive -b "$branch" --depth 1 --recurse-submodules "$1" "$dir" >/dev/null 2>&1
	
	####### - uaktualnić bo Miki jeczy i musze mu oddac kompa
	rm -f "/home/$name/README.md" "/home/$name/LICENSE"
	
	sudo -u "$name" cp -rfT "$dir" "$2"
	}

### THE ACTUAL SCRIPT ###

# Allow user to run sudo without password - to not interrupt script when password is needed

#[ -f /etc/sudoers.pacnew ] && cp /etc/sudoers.pacnew /etc/sudoers # Just in case
#sudo sed -i "/%wheel/d" /etc/sudoers
sudo bash -c 'echo "%wheel ALL=(ALL) NOPASSWD: ALL #EALIS" >> /etc/sudoers'

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

# Final confirmation

preinstallmsg || error "User exited."

# Make pacman and paru colorful

grep -q "^Color" /etc/pacman.conf || sed -i "s/^#Color$/Color/" /etc/pacman.conf
grep -q "ILoveCandy" /etc/pacman.conf || sed -i "/#VerbosePkgLists/a ILoveCandy" /etc/pacman.conf

# Refresh Arch keyrings and install required programs 

refreshkeys || error "Error automatically refreshing Arch keyring. Consider doing so manually."

# Install and configure required programs to follow next steps

for x in curl base-devel git; do		# install dev tools
	dialog \
	--backtitle "Elkrien's Arch Linux Installation Script" \
	--title " EALIS Installation " \
	--infobox "\\nInstalling \`$x\` which is required to install and configure other programs." 6 70
	installpkg "$x"
done

#sed -i "s/-j2/-j$(nproc)/;s/^#MAKEFLAGS/MAKEFLAGS/" /etc/makepkg.conf # use all cores for compilation

# Install AUR helper defined in variables

manualinstall $aurhelper || error "Failed to install AUR helper." 

# Install all packages for chosen desktop environment

case "$DE" in
   "GNOME") installationloopgnome ;;
   "XFCE") installationloopxfce ;; 
esac

# Install TLP and enable TLP service if selected

case "$LAPTOP" in
   "YES") tlpinstall ;; 
esac

# Install and enable Bluetooth

case "$BTH" in
   "YES") bthinstall ;; 
esac

# Enable services

serviceinstall

# Install the dotfiles in the user's home directory - zahashować
gitdotfiles "$dotfilesrepo" "/home/$name" "$repobranch"

# make git ignore deleted LICENSE & README.md files
#git update-index --assume-unchanged "/home/$name/README.md" "/home/$name/LICENSE" "/home/$name/FUNDING.yml"

# Overwrite sudoers back and allow the user to run
# serveral important commands, `shutdown`, `reboot`, updating, etc. without a password.

sudo sed -i "/#EALIS/d" /etc/sudoers
sudo bash -c 'echo "%wheel ALL=(ALL) ALL
%wheel ALL=(ALL) NOPASSWD: /usr/bin/shutdown,/usr/bin/reboot,/usr/bin/wifi-menu,/usr/bin/mount,/usr/bin/umount,/usr/bin/pacman -Syu,/usr/bin/pacman -Syyu,/usr/bin/systemctl restart NetworkManager,/usr/bin/pacman -Syyu --noconfirm,/usr/bin/loadkeys,/usr/bin/paru,/usr/bin/pacman -Syyuw --noconfirm" >> /etc/sudoers'
