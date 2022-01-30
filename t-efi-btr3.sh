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

timedatectl set-timezone $time_zone





##-----------------   Часовые пояса

# $DIALOG --clear --title "  ЧАСОВЫЕ ПОЯСА  " \
#         --menu "
#   Выберите Ваш часовой пояс:" 20 51 7 \
#         "Алматы" ""\
#         "Владивосток" ""\
#         "Екатеринбург" ""\
#         "Ереван" "" \
#         "Запарожье" ""\
#         "Иркутск" ""\
#         "Калининград" ""\
#         "Камчатка" ""\
#         "Киев" ""\
#         "Киров" ""\
#         "Красноярск" ""\
#         "Магадан" ""\
#         "Минск" ""\
#         "Москва" ""\
#         "Новокузнецк" ""\
#         "Новосибирск" ""\
#         "Омск" ""\
#         "Самара" ""\
#         "Саратов" ""\
#         "Среднеколымск" ""\
#         "Стамбул" ""\
#         "Ташкент" ""\
#         "Тбилиси" ""\
#         "Томск" ""\
#         "Ульяновск" ""\
#         "Уральск" ""\
#         "Чита" ""\
#         "Якутск" "" 2> $tempfile
#
# retval=$?
#
# choice=`cat $tempfile`
#
# case $choice in
#                 "Алматы")
#                 clear
#                 ln -sf /usr/share/zoneinfo/Asia/Almaty /etc/localtime
#              break
#              ;;
#                   "Владивосток")
#                 clear
#                 ln -sf /usr/share/zoneinfo/Asia/Vladivostok /etc/localtime
#              break
#              ;;
#                 "Екатеринбург")
#                 clear
#                 ln -sf /usr/share/zoneinfo/Asia/Yekaterinburg /etc/localtime
#              break
#              ;;
#                 "Ереван")
#                 clear
#                 ln -sf /usr/share/zoneinfo/Asia/Yerevan /etc/localtime
#              break
#              ;;
#                 "Запарожье")
#                 clear
#                 ln -sf /usr/share/zoneinfo/Europe/Zaporozhye /etc/localtime
#              break
#              ;;
#                 "Иркутск")
#                 clear
#                 ln -sf /usr/share/zoneinfo/Asia/Irkutsk /etc/localtime
#              break
#              ;;
#                 "Калининград")
#                 clear
#                 ln -sf /usr/share/zoneinfo/Europe/Kaliningrad /etc/localtime
#              break
#              ;;
#                 "Камчатка")
#                 clear
#                 ln -sf /usr/share/zoneinfo/Asia/Kamchatka /etc/localtime
#              break
#              ;;
#                 "Киев")
#                 clear
#                 ln -sf /usr/share/zoneinfo/Europe/Kiev /etc/localtime
#              break
#              ;;
#                 "Киров" )
#                 clear
#                 ln -sf /usr/share/zoneinfo/Europe/Kirov /etc/localtime
#              break
#              ;;
#                 "Красноярск")
#                 clear
#                 ln -sf /usr/share/zoneinfo/Asia/Krasnoyarsk /etc/localtime
#              break
#              ;;
#                 "Магадан")
#                 clear
#                 ln -sf /usr/share/zoneinfo/Asia/Magadan /etc/localtime
#              break
#              ;;
#                 "Минск")
#                 clear
#                 ln -sf /usr/share/zoneinfo/Europe/Minsk /etc/localtime
#              break
#              ;;
#                 "Москва")
#                 clear
#                 ln -sf /usr/share/zoneinfo/Europe/Moscow /etc/localtime
#              break
#              ;;
#                 "Новокузнецк")
#                 clear
#                 ln -sf /usr/share/zoneinfo/Asia/Novokuznetsk /etc/localtime
#              break
#              ;;
#                 "Новосибирск")
#                 clear
#                 ln -sf /usr/share/zoneinfo/Asia/Novosibirsk /etc/localtime
#              break
#              ;;
#                 "Омск")
#                 clear
#                 ln -sf /usr/share/zoneinfo/Asia/Omsk /etc/localtime
#              break
#              ;;
#                 "Самара")
#                 clear
#                 ln -sf /usr/share/zoneinfo/Europe/Samara /etc/localtime
#              break
#              ;;
#                 "Саратов")
#                 clear
#                 ln -sf /usr/share/zoneinfo/Europe/Saratov /etc/localtime
#              break
#              ;;
#                 "Среднеколымск")
#                 clear
#                 ln -sf /usr/share/zoneinfo/Asia/Srednekolymsk /etc/localtime
#              break
#              ;;
#                 "Стамбул")
#                 clear
#                 ln -sf /usr/share/zoneinfo/Asia/Istanbul /etc/localtime
#              break
#              ;;
#                 "Ташкент")
#                 clear
#                 ln -sf /usr/share/zoneinfo/Asia/Tashkent /etc/localtime
#              break
#              ;;
#                 "Тбилиси")
#                 clear
#                 ln -sf /usr/share/zoneinfo/Asia/Tbilisi /etc/localtime
#              break
#              ;;
#                 "Томск")
#                 clear
#                 ln -sf /usr/share/zoneinfo/Asia/Tomsk /etc/localtime
#              break
#              ;;
#                 "Ульяновск")
#                 clear
#                 ln -sf /usr/share/zoneinfo/Europe/Ulyanovsk /etc/localtime
#              break
#              ;;
#                 "Уральск")
#                 clear
#                 ln -sf /usr/share/zoneinfo/Asia/Oral /etc/localtime
#              break
#              ;;
#                 "Чита")
#                 clear
#                 ln -sf /usr/share/zoneinfo/Asia/Chita /etc/localtime
#              break
#              ;;
#                 "Якутск")
#                 clear
#                 ln -sf /usr/share/zoneinfo/Asia/Yakutsk /etc/localtime
#              break
#              ;;
#         255)
#             echo "Нажата клавиша ESC.";;
# esac

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

pacman -Sy reflector --noconfirm

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
                pacman -S lxdm --noconfirm
                systemctl enable lxdm.service
             
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
pacman -Syy
pacman -S grub efibootmgr os-prober --noconfirm 
grub-install --target=x86_64-efi --efi-directory=/boot/efi --bootloader-id=arch
grub-mkconfig -o /boot/grub/grub.cfg

 
$DIALOG --title " ПЕРЕЗАГРУЗКА " --clear \
        --yesno "УСТАНОВКА СИСТЕМЫ ЗАВЕРШЕНА. ПЕРЕЗАГРУЗИТЬ КОМПЬЮТЕР ?" 10 40

case $? in
    0)
    umount -R /mnt
	reboot
	;;
    1)
    umount -R /mnt
    clear
	;;
    255)
	echo "Нажата клавиша ESC.";;
esac

