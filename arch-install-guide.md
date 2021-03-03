# INSTALACJA ARCH na IDEAPAD 100S-14IBR


Poniżej znajduje się instrukcja instalacji czystego Linux Arch na komputerze Lenovo Ideapad 100S-14IBR. Wykonuj komendy po kolei zgodne z poniższymi wskazówkami oraz opisem.

1. Ściągnij i nagraj na Pendrive ISO z systemem Linux Arch (np. używające Balena Etcher) - [https://archlinux.org/](https://archlinux.org/download/)

3. Ustaw układ klawiatury i wyświetlanie polskich znaków:

   ```sh
   loadkeys pl
   setfont Lat2-Terminus16.psfu.gz -m 8859-2
   ```
   
3. Podłącz się do sieci (słowo *haslodowifi* zastąp prawdziwym hasłem:

   ```sh
   bash
   iwctl station wlan0 scan
   iwctl --passphrase haslodowifi station wlan0 connect MM5
   ping archlinux.org (CTRL+C - żeby przerwać)
   ```

5. Zaktualizuj zegar systemowy:

   ```sh
   timedatectl set-ntp true
   ```
   
5. Formatowanie i montowanie partycji (są już stworzone):

   ```sh
   mkfs.fat -F32 /dev/mmcblk1p1
   mkswap /dev/mmcblk1p4
   swapon /dev/mmcblk1p4
   mkfs.ext4 /dev/mmcblk1p2
   mount /dev/mmcblk1p2 /mnt
   ```

6. Instalacja sterowników i pluginów do obsługi dźwięku:

   ```sh
   pacstrap /mnt base linux linux-firmware
   ```

7. Generowanie fstab i wejście do chroot:

   ```sh
   genfstab -U /mnt >> /mnt/etc/fstab
   arch-chroot /mnt
   ```

8. Ustawianie strefy czasowej i języka:

   ```sh
   ln -sf /usr/share/zoneinfo/Europe/Warsaw /etc/localtime
   hwclock --systohc
   pacman -S micro
   micro /etc/locale.gen - usuń znak # w linijkach en_US.UTF-8 UTF-8 i pl_PL.UTF-8 UTF-8
   locale-gen
   micro /etc/locale.conf  - dodaj: LANG=pl_PL.UTF-8
   micro /etc/vconsole.conf - dodaj: KEYMAP=pl
   ```

9. Ustawianie nazwy hosta i tworzenie użytkownika:

   ```sh
   micro /etc/hostname - dodaj archLenovo
   micro /etc/hosts - dodaj:
   	127.0.0.1		localhost
   	::1				localhost
   	127.0.1.1		archLenovo.localdomain	archLenovo
   passwd - ustaw hasło root'a
   useradd -m mm
   passwd mm - ustaw hasło dla mm
   usermod -aG wheel,audio,video,optical,storage mm
   pacman -S sudo
   EDITOR=micro visudo - usuń # przy linijce %wheel ALL=(ALL) ALL
   ```

10. Instalacja i ustawienie grub:

    ```sh
    pacman -S grub efibootmgr dosfstools os-prober mtools
    mkdir /boot/EFI
    mount /dev/mmcblk1p1 /boot/EFI
    grub-install --target=x86_64-efi --bootloader-id=grub_uefi --recheck
    grub-mkconfig -o /boot/grub/grub.cfg
    ```

11. Instalacja i uruchomienie Network Manager'a:

    ```sh
    pacman -S networkmanager
    systemctl enable NetworkManager
    ```

12. Wyjście i restart komputera:

    ```sh
    exit
    umount -R /mnt
    shutdown now
    ```

13. Po restarcie i zalogowaniu się podłączenie się do sieci:

    ```sh
    nmtui
    ```

14. System zainstalowany i podłączony do Internetu - zainstaluj odpowiednie środowisko graficzne.