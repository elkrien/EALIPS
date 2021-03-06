# **E**lkrien's **A**rch **L**inux **I**nstallation **S**cript


...work in progress...

EALIS is a shell script that will install fully configured desktop environement (XFCE or GNOME) - by default script will install my personal list of selected applications and dotfiles:
- packages are listed in file `packages.csv` - see instruction below
- dotfiles are downloaded from my dotfiles GitHub

EALIS was created as a modification for my own purpose of LARBS (by Luke Smith) - I was looking for something that will automate my Arch Linux post-installation and found this amazing project that I decided to adopt and modify. 

After the installation a nice looking desktop based on Dracula Theme will be waiting for You - see example screenshots here.

**Requirements:**
- fresh install of Arch Linux
- internet connection
- `curl` installed (`sudo pacman -S curl` if needed)

**Installation:**

1. Start fresh installed Arch Linux
2. Login asd created during installation user
3. Run the following commands:
```sh
   curl -Lo ealis.sh bit.ly/ealis
   sh ealis.sh
   ```
or 
```sh
   curl -LO https://raw.githubusercontent.com/elkrien/EALIS/main/ealis.sh
   sh ealis.sh
```

EALIS will guide You through the rest of installation.


#
**packages.csv**

The list of all programs / applications are different for each Desktop Environment (DE). At the begining of each line there is a special tag:
- P - package installed from Arch Repositories for both DE
- PX - package installed from Arch Repositories for XFCE
- PG - package installed from Arch Repositories for GNOME
- A - package installed from Arch User Repository (AUR) for both DE
- AX - package installed from Arch User Repository (AUR) for XFCE
- AG - package installed from Arch User Repository (AUR) for GNOME
