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





### THE ACTUAL SCRIPT ###

# Clear terminal
clear
 
# Download and install dependancies to run actual script

tput setaf 3
echo
echo "######################################################################################"
echo 
echo " Before we start the actual script we need to download and install some dependancies "
echo
echo "        Make sure that You have sudo privillages and connected to Internet"
echo
echo " 		    In next step You will be asked for Your sudo password"
echo 
echo "			 And if everything is OK we will start"
echo 
echo "######################################################################################"
echo
echo
tput sgr0

sudo pacman --noconfirm --needed -Sy dialog || error "Something is wrong - make sure You are on fresh Arch Linux and have an internet connection"
curl -o ~/.dialogrc https://raw.githubusercontent.com/elkrien/EALIS/main/dialogrc

# Welcome screen

# ... work in progress
