#!/bin/bash
loadkeys ru
###setfont cyr-sun16
setfont ter-v32b

DIALOG=${DIALOG=dialog}
tempfile=`tempfile 2>/dev/null` || tempfile=/tmp/test$$
trap "rm -f $tempfile" 0 1 2 5 15

clear

#------------------ YAY

            cd /home/
            git clone https://aur.archlinux.org/yay.git
            chown -R /home/yay
            chown -R /home/yay/PKGBUILD
            cd /home/yay
            sudo -u makepkg -si --noconfirm
            rm -Rf /home/yay


#-------------------  Pamac-aur

            clear
            cd /home/$username
            git clone https://aur.archlinux.org/pamac-aur.git
            chown -R $username:users /home/$username/pamac-aur
            chown -R $username:users /home/$username/pamac-aur/PKGBUILD
            cd /home/$username/pamac-aur
            sudo -u $username  makepkg -si --noconfirm
            rm -Rf /home/$username/pamac-aur

#----------------------  archlinux-appstream-data-pamac

            cd /home/
            git clone https://aur.archlinux.org/archlinux-appstream-data-pamac.git
            chown -R /home/archlinux-appstream-data-pamac
            chown -R /home/archlinux-appstream-data-pamac/PKGBUILD
            cd /home/archlinux-appstream-data-pamac
            sudo -u makepkg -si --noconfirm
            rm -Rf /home/archlinux-appstream-data-pamac
