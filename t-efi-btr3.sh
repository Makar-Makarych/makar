#!/bin/bash

loadkeys ru
setfont cyr-sun16
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

# -----------   Часовой пояс NEW  

time_zone=$(curl -s https://ipinfo.io/timezone)  # Определяет место положения по IP

#timedatectl set-timezone $time_zone

ln -sf /usr/share/zoneinfo/$time_zone /etc/localtime

#                 Москва

#                 ln -sf /usr/share/zoneinfo/Europe/Moscow /etc/localtime

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



# clear
#         echo ""
#         echo -e "  Придумайте и введите пароль ROOT :"
#         echo ""
#         passwd
#
# clear
#         echo ""
#         echo -e "  Придумайте и введите пароль ПОЛЬЗОВАТЕЛЯ :"
#         echo ""
#         passwd $username



#-----------------   Часовые пояса утилита на англ. 

# $DIALOG --title " ЧАСОВОЙ ПОЯС " --clear \
#         --yesno "
#   На следующем шаге можно установить часовой пояс. Либо вы можете его поменять в настройках после установки системы.

#             Установить часовой пояс сейчас ?" 10 60
 
# case $? in
#     0)  
#       clear
#       tzz=`tzselect`
#       ln -sf /usr/share/zoneinfo/$tzz /etc/localtime
#       ;;
#     1)
#         echo "Выбрано 'Нет'.";;
#     255)
#         echo "Нажата клавиша ESC.";;
# esac

#-----------  Создадим загрузочный RAM диск
mkinitcpio -p linux

#-----    Раскомментируем репозиторий multilib Для работы 32-битных приложений в 64-битной системе
echo '[multilib]' >> /etc/pacman.conf
echo 'Include = /etc/pacman.d/mirrorlist' >> /etc/pacman.conf
pacman -Syy


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
        pacman -S xorg-server xorg-drivers xorg-xinit virtualbox-guest-utils
        ;;
    1)
        clear
        pacman -S xorg-server xorg-drivers xorg-xinit
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
                pacman -Sy cinnamon  cinnamon-translations gnome-terminal xorg gdm nemo-fileroller gnome-system-monitor faenza-icon-theme --noconfirm
                systemctl enable gdm.service
                systemctl start gdm.service
                
              ;;
                "KDE")
                clear
                pacman -Sy plasma plasma-meta plasma-pa plasma-desktop kde-system-meta kde-utilities-meta kio-extras kwalletmanager latte-dock  konsole  kwalletmanager --noconfirm
                pacman -R konqueror --noconfirm
                pacman -S sddm sddm-kcm --noconfirm
                systemctl enable sddm.service -f
             
             ;;
                "XFCE")
                clear
                pacman -Sy xfce4 pavucontrol xfce4-goodies  --noconfirm
                pacman -S lxdm --noconfirm
                systemctl enable lxdm.service
             
             ;;
                "GNOME")
                clear
                pacman -Sy gnome --noconfirm
                pacman -S gnome-extra --noconfirm
                pacman -S gdm --noconfirm
                systemctl enable gdm.service -f
             
             ;;
                "LXDE")
                clear
                pacman -Sy lxde lxde-common lxsession lxdm --noconfirm
                systemctl enable lxdm.service
              
             ;;
                "DEEPIN")
                clear
                pacman -Sy deepin
                pacman -S deepin-extra 
                pacman -S lxdm --noconfirm
                systemctl enable lxdm.service
                echo "greeter-session=lightdm-deepin-greeter" >> /etc/lightdm/lightdm.conf
             
             ;;
                "MATE")
                clear
                pacman -Sy  mate mate-extra  --noconfirm
                pacman -S lxdm --noconfirm
                systemctl enable lxdm.service
             ;;
                "LXQT")
                clear
                pacman -Sy lxqt lxqt-qtplugin lxqt-themes --noconfirm
                pacman -S sddm sddm-kcm --noconfirm
                systemctl enable sddm.service -f
             
             ;;
            255)
            echo "Нажата клавиша ESC.";;
esac


#-----------    Шрифты
pacman -S ttf-arphic-ukai git ttf-liberation ttf-dejavu ttf-arphic-uming ttf-fireflysung ttf-sazanami --noconfirm

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

#----------------   ПО
pacman -S file-roller gparted p7zip unace lrzip gvfs-afc htop xterm gvfs-mtp neofetch blueman flameshot firefox firefox-i18n-ru  --noconfirm 

#------------------------ Дополнительное ПО

$DIALOG --title " ДОПОЛНИТЕЛНОЕ ПО ( Нужно ввести пароль )" --clear \
        --yesno "
  Установить YAY ?" 10 60
 
case $? in
            0)
#----------------  YAY
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

#-----------  Папки пользователя 
mkdir /home/"$username"/{Downloads,Music,Pictures,Videos,Documents}   
chown -R "$username":users  /home/"$username"/{Downloads,Music,Pictures,Videos,Documents}

#-------------  ЗАГРУЗЧИК 
pacman -S grub efibootmgr os-prober --noconfirm 
grub-install --target=x86_64-efi --efi-directory=/boot/efi --bootloader-id=arch
grub-mkconfig -o /boot/grub/grub.cfg

 
$DIALOG --title " ПЕРЕЗАГРУЗКА " --clear \
        --yesno " УСТАНОВКА СИСТЕМЫ ЗАВЕРШЕНА. ПЕРЕЗАГРУЗИТЬ КОМПЬЮТЕР ?" 10 40

case $? in
    0)
    shutdown -r now
    ;;
    1)
    clear
	;;
    255)
	echo "Нажата клавиша ESC.";;
esac

