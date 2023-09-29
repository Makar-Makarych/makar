#!/bin/bash

loadkeys ru
###setfont cyr-sun16
setfont ter-v32b

clear

DIALOG=${DIALOG=dialog}
tempfile=`tempfile 2>/dev/null` || tempfile=/tmp/test$$
trap "rm -f $tempfile" 0 1 2 5 15

#-----------  Добавляем русскую локаль  и язык системы

echo "en_US.UTF-8 UTF-8" > /etc/locale.gen
echo "ru_RU.UTF-8 UTF-8" >> /etc/locale.gen

    locale-gen

echo 'LANG="ru_RU.UTF-8"' > /etc/locale.conf 
echo "KEYMAP=ru" >> /etc/vconsole.conf
echo "FONT=cyr-sun16" >> /etc/vconsole.conf

#------------------------- Обновление ключей ---------------------------------------

#         pacman-key --init
#         pacman-key --populate archlinux

# -----------   Часовой пояс NEW

time_zone=$(curl -s https://ipinfo.io/timezone)  # Определяет место положения по IP
ln -sf /usr/share/zoneinfo/$time_zone /etc/localtime

#-----------  Создание паролей, пользователя и --------------

$DIALOG --title " ИМЯ КОМПЬЮТЕРА " --clear \
    --inputbox "
  Придумайте и введите имя компьютера ( hostname )" 10 60 2> $tempfile
        hostname=`cat $tempfile`
        echo $hostname > /etc/hostname

$DIALOG --title " ИМЯ ПОЛЬЗОВАТЕЛЯ " --clear \
    --inputbox "
  Придумайте и введите имя пользователя ( user )" 10 60 2> $tempfile
        username=`cat $tempfile`
        useradd -m -g users -G wheel -s /bin/bash $username

$DIALOG --title " ПАРОЛЬ ROOT " --clear \
    --inputbox "
  Придумайте и введите пароль администратора ( ROOT )" 10 60 2> $tempfile
        rootpass=`cat $tempfile`
        (
	echo $rootpass
	echo $rootpass
) | passwd

$DIALOG --title " ПАРОЛЬ USER " --clear \
    --inputbox "
  Придумайте и введите пароль пользователя ( USER )" 10 60 2> $tempfile
        userpass=`cat $tempfile`

        (
	echo $userpass
	echo $userpass
) | passwd $username

#-----------  Создадим загрузочный RAM диск

mkinitcpio -p linux

#-----    Раскомментируем репозиторий multilib Для работы 32-битных приложений в 64-битной системе

echo '[multilib]' >> /etc/pacman.conf
echo 'Include = /etc/pacman.d/mirrorlist' >> /etc/pacman.conf
pacman -Syy

#-------------- Pacman.conf

#echo "Color" >> /etc/pacman.conf
#echo "VerbosePkgLists" >> /etc/pacman.conf
#echo "IloveCandy" >> /etc/pacman.conf
#echo "ParallelDownloads = 5" >> /etc/pacman.conf
sed -i 's/#Color/Color/' /etc/pacman.conf
sed -i 's/#VerbosePkgLists/VerbosePkgLists/' /etc/pacman.conf
sed -i 's/#ParallelDownloads = 5/ParallelDownloads = 5/' /etc/pacman.conf
#----------------   Ставим программу для Wi-fi

pacman -S wpa_supplicant --noconfirm 

#------------    Настраиваем  SUDO

echo '%wheel ALL=(ALL) ALL' >> /etc/sudoers

#-----------  Reflector

pacman -S reflector --noconfirm

#------------  Виртуалка или нет

$DIALOG --title " ВИРТУАЛЬНАЯ МАШИНА " --clear \
        --yesno "
    Это виртуальная машина?" 8 60
case $? in
    0)
         clear
         pacman -S xorg-server xf86-input-libinput xf86-video-vesa xf86-video-ati xf86-video-amdgpu xf86-video-intel xf86-video-vmware xorg-xinit virtualbox-guest-utils --noconfirm
        ;;
    1)
         clear
         pacman -S xorg-server xf86-input-libinput xf86-video-vesa xf86-video-ati xf86-video-amdgpu xf86-video-intel xorg-xinit --noconfirm
        ;;
    255)
         echo "Нажата клавиша ESC.";;
esac

# ------------   Установка DE

$DIALOG --clear --title " УСТАНОВКА ГРАФИЧЕСКОГО ОКРУЖЕНИЯ  " \
        --menu "
  Выберите из списка : " 15 60 8 \
        "Cinnamon" ""\
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
                "Cinnamon")
                clear
                pacman -S cinnamon  cinnamon-translations gnome-terminal xorg gdm nemo-fileroller gnome-system-monitor faenza-icon-theme --noconfirm
                systemctl enable gdm.service
                systemctl start gdm.service
                
              ;;
                "KDE")
                clear
                pacman -S plasma plasma-meta plasma-pa plasma-desktop kde-system-meta kde-utilities-meta kio-extras kwalletmanager latte-dock  konsole  kwalletmanager --noconfirm
                pacman -R konqueror --noconfirm
                pacman -S sddm sddm-kcm --noconfirm
                systemctl enable sddm.service -f
             
             ;;
                "XFCE")
                clear
                pacman -S xfce4 pavucontrol xfce4-goodies  --noconfirm
                pacman -S lightdm lightdm-gtk-greeter --noconfirm
                systemctl enable lightdm.service
             
             ;;
                "GNOME")
                clear
                pacman -S gnome gnome-extra --noconfirm
                pacman -S gdm --noconfirm
                systemctl enable gdm.service -f
             
             ;;
                "LXDE")
                clear
                pacman -S lxde lxde-common lxsession lxdm --noconfirm
                systemctl enable lxdm.service
              
             ;;
                "DEEPIN")
                clear
                pacman -S deepin 
                pacman -S deepin-extra 
                pacman -S lxdm --noconfirm
                systemctl enable lxdm.service
                echo "greeter-session=lightdm-deepin-greeter" >> /etc/lightdm/lightdm.conf
             
             ;;
                "MATE")
                clear
                pacman -S  mate mate-extra  --noconfirm
                pacman -S lxdm --noconfirm
                systemctl enable lxdm.service
             ;;
                "LXQT")
                clear
                pacman -S lxqt lxqt-qtplugin lxqt-themes --noconfirm
                pacman -S sddm sddm-kcm --noconfirm
                systemctl enable sddm.service -f
             
             ;;
            255)
            echo "Нажата клавиша ESC.";;
esac

#-----------    Шрифты

pacman -S ttf-ubuntu-font-family noto-fonts noto-fonts-cjk noto-fonts-emoji ttf-arphic-ukai ttf-liberation ttf-dejavu ttf-arphic-uming ttf-fireflysung ttf-sazanami --noconfirm

#-------------- Сеть

pacman -S networkmanager networkmanager-openvpn network-manager-applet ppp openssh --noconfirm
systemctl enable NetworkManager.service
systemctl enable dhcpcd.service
systemctl enable sshd.service

#-------------  Звук

pacman -S pulseaudio-bluetooth alsa-utils pulseaudio-equalizer-ladspa   --noconfirm
systemctl enable bluetooth.service

#--------  Для Bash и Btrfs

pacman -S bash-completion grub-btrfs --noconfirm

#-------------  Ntfs & FAT + gvfs

pacman -S exfat-utils ntfs-3g gvfs --noconfirm

#------------------------ Дополнительное ПО YAY

$DIALOG --title " ДОПОЛНИТЕЛНОЕ ПО " --clear \
        --yesno "
 Установить YAY ? ( Нужно будет вводить пароль ROOT )" 10 60
case $? in
            0)
            clear
            cd /home/"$username" || exit
            git clone https://aur.archlinux.org/yay.git
            chown -R "$username":users /home/"$username"/yay
            chown -R "$username":users /home/"$username"/yay/PKGBUILD
            cd /home/"$username"/yay || exit
            sudo -u "$username"  makepkg -si --noconfirm
            rm -Rf /home/"$username"/yay
            ;;
            1)
            clear
            ;;
            255)
            echo "Нажата клавиша ESC.";;

esac

#----------------   ПО

pacman -S xdg-user-dirs gparted p7zip unace unrar lrzip gvfs-afc htop gvfs-mtp neofetch blueman --noconfirm


#-----------  Папки пользователя 
#mkdir /home/"$username"/{Downloads,Music,Pictures,Videos,Documents,time}   
#chown -R "$username":users  /home/"$username"/{Downloads,Music,Pictures,Videos,Documents,time}

#-------------  Загрузчик

grubd=$(lsblk -p -n -l -o NAME -e 7,11)       
            options=()
            for chd in ${grubd}; do
                options+=("${chd}" "")
            done
            grub=$(whiptail --title " GRUB " --menu "Выберите диск для установки GRUB" 0 0 0 \
                "none" "-" \
                "${options[@]}" \
                3>&1 1>&2 2>&3)
            if ! make mytarget; then
                echo ""
            else
                if [ "${grub}" = "none" ]; then
                    grub=
                fi
            fi
        pacman -S grub os-prober --noconfirm
        grub-install "$grub"
        grub-mkconfig -o /boot/grub/grub.cfg
        
#-----------------------   ВСЁ !!!!

$DIALOG --title " ПЕРЕЗАГРУЗКА " --clear --msgbox " УСТАНОВКА СИСТЕМЫ ЗАВЕРШЕНА. ПЕРЕЗАГРУЗИТЕ КОМПЬЮТЕР " 10 40
