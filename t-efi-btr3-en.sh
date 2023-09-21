#!/bin/bash
setfont ter-v32b
echo "Color" >> /etc/pacman.conf
echo "VerbosePkgLists" >> /etc/pacman.conf
echo "IloveCandy" >> /etc/pacman.conf
echo "ParallelDownloads = 5" >> /etc/pacman.conf

DIALOG=${DIALOG=dialog}
tempfile=`tempfile 2>/dev/null` || tempfile=/tmp/test$$
trap "rm -f $tempfile" 0 1 2 5 15

#-----------  Adding the locale and language of the system

echo "en_US.UTF-8 UTF-8" > /etc/locale.gen
locale-gen
echo 'LANG="en_US.UTF-8"' > /etc/locale.conf 
echo "KEYMAP=us" >> /etc/vconsole.conf
# echo "FONT=cyr-sun16" >> /etc/vconsole.conf

#-----------  Creating user and root passwords --------------

$DIALOG --title " COMPUTER NAME " --clear \
    --inputbox "
  Come up with and enter the computer name (hostname)" 10 60 2> $tempfile
        hostname=`cat $tempfile`
        echo $hostname > /etc/hostname
	    
$DIALOG --title " USER NAME " --clear \
    --inputbox "
  Come up with and enter the user name (user)" 10 60 2> $tempfile
        username=`cat $tempfile`
        useradd -m -g users -G wheel -s /bin/bash $username

clear
        echo ""
        echo -e "  Come up with and enter the ROOT password :"
        echo ""
        passwd

clear
        echo ""
        echo -e "  Create and enter a USER password :"
    	  echo ""
        passwd $username

#-----------------   Localization 

      clear
      tzz=`tzselect`
      ln -sf /usr/share/zoneinfo/$tzz /etc/localtime
      
#-----------  Creating a bootable RAM disk

mkinitcpio -p linux

#-----   Uncomment the multilib repository For running 32-bit applications on a 64-bit system

echo '[multilib]' >> /etc/pacman.conf
echo 'Include = /etc/pacman.d/mirrorlist' >> /etc/pacman.conf
pacman -Syy

#----------------   Wi-fi

pacman -S wpa_supplicant --noconfirm 

#------------     SUDO

echo '%wheel ALL=(ALL) ALL' >> /etc/sudoers

#-----------  Reflector

pacman -Sy reflector --noconfirm

#------------------    Mirrors  2     ----------------------

if (whiptail --title  " MIRRORS " --yesno  "
  You can now update the mirrors in the newly installed system, but this will take some time.

        Run the atomic mirror selection ?" 12 60)  
 then
    clear
         pacman -Sy reflector --noconfirm
         reflector --verbose -a1 -f10 -l70 -p https -p http --sort rate --save /etc/pacman.d/mirrorlist
         pacman -Sy --noconfirm
    else
    clear
         pacman -Sy --noconfirm
fi

#------------  VIRTUAL MACHINE

$DIALOG --title " VIRTUAL MACHINE " --clear \
        --yesno "
  Is the system being installed on a virtual machine ?" 8 60
case $? in
    0)
         clear
         pacman -S xorg-server xorg-drivers xorg-xinit virtualbox-guest-utils
        ;;
    1)
         clear
         pacman -S xorg-server xorg-drivers xorg-xinit
        ;;
    255)
         echo " ESC.";;
esac

#--------------     DE  ------------------------------------------

$DIALOG --clear --title " INSTALLING THE GRAPHICAL ENVIRONMENT " \
        --menu "
   " 15 60 7 \
        "KDE" ""\
        "XFCE" ""\
        "GNOME" "" \
        "LXDE" ""\
        "DEEPIN" ""\
        "MATE" ""\
        "LXQT" "" 2> $tempfile
 
retval=$?
 
choice=`cat $tempfile`
 
case $choice in
                "KDE")
                clear
                pacman -S plasma plasma-meta plasma-pa plasma-desktop kde-system-meta kde-utilities-meta kio-extras kwalletmanager latte-dock  konsole  kwalletmanager --noconfirm
                pacman -R konqueror --noconfirm
                pacman -S sddm sddm-kcm --noconfirm
                systemctl enable sddm.service -f
             break
             ;;
                "XFCE")
                clear
                pacman -S xfce4 pavucontrol xfce4-goodies  --noconfirm
                pacman -S lxdm --noconfirm
                systemctl enable lxdm.service
             break
             ;;
                "GNOME")
                clear
                pacman -S gnome gnome-extra --noconfirm
                pacman -S gdm --noconfirm
                systemctl enable gdm.service -f
             break
             ;;
                "LXDE")
                clear
                pacman -S lxde --noconfirm
                pacman -S lxdm --noconfirm
                systemctl enable lxdm.service
              break
             ;;
                "DEEPIN")
                clear
                pacman -S deepin 
                pacman -S deepin-extra 
                pacman -S lxdm --noconfirm
                systemctl enable lxdm.service
                echo "greeter-session=lightdm-deepin-greeter" >> /etc/lightdm/lightdm.conf
             break
             ;;
                "MATE")
                clear
                pacman -S  mate mate-extra  --noconfirm
                pacman -S lxdm --noconfirm
                systemctl enable lxdm.service
              break
             ;;
                "LXQT")
                clear
                pacman -S lxqt lxqt-qtplugin lxqt-themes --noconfirm
                pacman -S sddm sddm-kcm --noconfirm
                systemctl enable sddm.service -f
             break
             ;;
            255)
            echo " ESC.";;
esac


#-----------    Fonts
clear
pacman -S ttf-arphic-ukai git ttf-liberation ttf-dejavu ttf-arphic-uming ttf-fireflysung ttf-sazanami --noconfirm

#-------------- Net
clear
pacman -S networkmanager networkmanager-openvpn network-manager-applet ppp openssh --noconfirm
systemctl enable NetworkManager.service
systemctl enable dhcpcd.service
systemctl enable sshd.service

#-------------  Sound
clear
pacman -S pulseaudio-bluetooth alsa-utils pulseaudio-equalizer-ladspa   --noconfirm
systemctl enable bluetooth.service

#--------  Bash & Btrfs

pacman -S bash-completion grub-btrfs --noconfirm

#-------------  Ntfs & FAT + gvfs

clear
pacman -S exfat-utils ntfs-3g gvfs --noconfirm

#----------------   Apps

clear
pacman -S file-roller gparted p7zip unace lrzip gvfs-afc htop xterm gvfs-mtp neofetch blueman flameshot firefox firefox-i18n-ru  --noconfirm 

#------------------------ Дополнительное ПО

$DIALOG --title " ADDITIONAL APPS " --clear \
        --yesno "
  Install additional apps (YAY, PAMAC)" 10 60
 
case $? in
            0)
#----------------  YAY
            clear
            cd /home/$username
            git clone https://aur.archlinux.org/yay.git
            chown -R $username:users /home/$username/yay
            chown -R $username:users /home/$username/yay/PKGBUILD 
            cd /home/$username/yay  
            sudo -u $username  makepkg -si --noconfirm  
            rm -Rf /home/$username/yay

#-------------------  PAMAC-AUR
            clear
            cd /home/$username
            git clone https://aur.archlinux.org/pamac-aur.git
            chown -R $username:users /home/$username/pamac-aur
            chown -R $username:users /home/$username/pamac-aur/PKGBUILD 
            cd /home/$username/pamac-aur
            sudo -u $username  makepkg -si --noconfirm  
            rm -Rf /home/$username/pamac-aur
            ;;
            1)
            clear
            ;;
            255)
            echo " ESC.";;
esac

#-----------  User 

mkdir /home/$username/{Downloads,Music,Pictures,Videos,Documents,time}   
chown -R $username:users  /home/$username/{Downloads,Music,Pictures,Videos,Documents,time}

#-------------  Grub 

pacman -Syy
pacman -S grub efibootmgr os-prober --noconfirm 
grub-install --target=x86_64-efi --efi-directory=/boot/efi --bootloader-id=grub
grub-mkconfig -o /boot/grub/grub.cfg

 
$DIALOG --title " OK ! " --clear \
        --yesno "
  SYSTEM INSTALLATION IS COMPLETE. RESTART YOUR COMPUTER " 10 60
 
case $? in
    0)
         umount -R /mnt
         reboot;;
    1)
         clear
        exit;;
    255)
         echo " ESC.";;
esac

   clear
echo " SYSTEM INSTALLATION IS COMPLETE. "
exit
