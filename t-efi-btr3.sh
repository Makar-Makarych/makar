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

#-----------  Создание паролей, пользователя и --------------
clear
        echo ""
        echo -e " ПРИДУМАЙТЕ И ВВЕДИТЕ ПАРОЛЬ ROOT  "
        echo ""
        passwd

$DIALOG --title "  ИМЯ КОМПЬЮТЕРА  " --clear \
    --inputbox "  ПРИДУМАЙТЕ И ВВЕДИТЕ ИМЯ КОМПЬЮТЕРА" 10 60 2> $tempfile
        hostname=`cat $tempfile`
        echo $"hostname" > /etc/hostname
	    
$DIALOG --title "  ИМЯ ПОЛЬЗОВАТЕЛЯ  " --clear \
    --inputbox " ПРИДУМАЙТЕ И ВВЕДИТЕ ИМЯ ПОЛЬЗОВАТЕЛЯ  " 10 60 2> $tempfile
        username=`cat $tempfile`
        useradd -m -g users -G wheel -s /bin/bash $username

clear
        echo ""
        echo -e " ПРИДУМАЙТЕ И ВВЕДИТЕ ПАРОЛЬ ROOT  "
        echo ""
        passwd

clear
        echo ""
        echo -e " ПРИДУМАЙТЕ И ВВЕДИТЕ ПАРОЛЬ ПОЛЬЗОВАТЕЛЯ  "
    	echo ""
        passwd $username

#-----------------   Часовые пояса

$DIALOG --clear --title "  ЧАСОВЫЕ ПОЯСА  " \
        --menu " ВЫБЕРИТЕ ВАШ ЧАСОВОЙ ПОЯС : " 20 51 7 \
        "Алматы" ""\
        "Екатеринбург" ""\
        "Ереван" "" \
        "Запарожье" ""\
        "Иркутск" ""\
        "Калининград" ""\
        "Камчатка" ""\
        "Киев" ""\
        "Киров" ""\
        "Красноярск" ""\
        "Магадан" ""\
        "Минск" ""\
        "Москва" ""\
        "Новокузнецк" ""\
        "Новосибирск" ""\
        "Омск" ""\
        "Самара" ""\
        "Саратов" ""\
        "Среднеколымск" ""\
        "Стамбул" ""\
        "Ташкент" ""\
        "Тбилиси" ""\
        "Томск" ""\
        "Ульяновск" ""\
        "Уральск" ""\
        "Чита" ""\
        "Якутск" "" 2> $tempfile
 
retval=$?
 
choice=`cat $tempfile`
 
case $choice in
                "Алматы")
                ln -sf /usr/share/zoneinfo/Asia/Almaty /etc/localtime
             break
             ;;
                "Екатеринбург")
                ln -sf /usr/share/zoneinfo/Asia/Yekaterinburg /etc/localtime
             break
             ;;
                "Ереван")
                ln -sf /usr/share/zoneinfo/Asia/Yerevan /etc/localtime
             break
             ;;
                "Запарожье")
                ln -sf /usr/share/zoneinfo/Europe/Zaporozhye /etc/localtime
             break
             ;;
                "Иркутск")
                ln -sf /usr/share/zoneinfo/Asia/Irkutsk /etc/localtime
             break
             ;;
                "Калининград")
                ln -sf /usr/share/zoneinfo/Europe/Kaliningrad /etc/localtime
             break
             ;;
                "Камчатка")
                ln -sf /usr/share/zoneinfo/Asia/Kamchatka /etc/localtime
             break
             ;;
                "Киев")
                ln -sf /usr/share/zoneinfo/Europe/Kiev /etc/localtime
             break
             ;;
                "Киров" )
                ln -sf /usr/share/zoneinfo/Europe/Kirov /etc/localtime      
             break
             ;;
                "Красноярск")
                ln -sf /usr/share/zoneinfo/Asia/Krasnoyarsk /etc/localtime
             break
             ;;
                "Магадан")
                ln -sf /usr/share/zoneinfo/Asia/Magadan /etc/localtime
             break
             ;;
                "Минск")
                ln -sf /usr/share/zoneinfo/Europe/Minsk /etc/localtime
             break
             ;;
                "Москва")
                ln -sf /usr/share/zoneinfo/Europe/Moscow /etc/localtime
             break
             ;;
                "Новокузнецк")
                ln -sf /usr/share/zoneinfo/Asia/Novokuznetsk /etc/localtime
             break
             ;;
                "Новосибирск")
                ln -sf /usr/share/zoneinfo/Asia/Novosibirsk /etc/localtime
             break
             ;;
                "Омск")
                ln -sf /usr/share/zoneinfo/Asia/Omsk /etc/localtime
             break
             ;;
                "Самара")
                ln -sf /usr/share/zoneinfo/Europe/Samara /etc/localtime
             break
             ;;
                "Саратов")
                ln -sf /usr/share/zoneinfo/Europe/Saratov /etc/localtime
             break
             ;;
                "Среднеколымск")
                ln -sf /usr/share/zoneinfo/Asia/Srednekolymsk /etc/localtime
             break
             ;;
                "Стамбул")
                ln -sf /usr/share/zoneinfo/Asia/Istanbul /etc/localtime
             break
             ;;
                "Ташкент")
                ln -sf /usr/share/zoneinfo/Asia/Tashkent /etc/localtime
             break
             ;;
                "Тбилиси")
                ln -sf /usr/share/zoneinfo/Asia/Tbilisi /etc/localtime
             break
             ;;
                "Томск")
                ln -sf /usr/share/zoneinfo/Asia/Tomsk /etc/localtime
             break
             ;;
                "Ульяновск")
                ln -sf /usr/share/zoneinfo/Europe/Ulyanovsk /etc/localtime
             break
             ;;
                "Уральск")
                ln -sf /usr/share/zoneinfo/Asia/Oral /etc/localtime
             break
             ;;
                "Чита")
                ln -sf /usr/share/zoneinfo/Asia/Chita /etc/localtime
             break
             ;;
                "Якутск")
                ln -sf /usr/share/zoneinfo/Asia/Yakutsk /etc/localtime
             break
             ;;
        255)
            echo "Нажата клавиша ESC.";;
esac



#-----------  Создадим загрузочный RAM диск
mkinitcpio -p linux

#-------------  Загрузчик
pacman -Syy
pacman -S grub efibootmgr --noconfirm 
grub-install --target=x86_64-efi --efi-directory=/boot/efi --bootloader-id=grub
grub-mkconfig -o /boot/grub/grub.cfg


echo 'Ставим программу для Wi-fi'
pacman -S wpa_supplicant --noconfirm 



echo 'Устанавливаем SUDO'
echo '%wheel ALL=(ALL) ALL' >> /etc/sudoers

echo 'Раскомментируем репозиторий multilib Для работы 32-битных приложений в 64-битной системе.'
echo '[multilib]' >> /etc/pacman.conf
echo 'Include = /etc/pacman.d/mirrorlist' >> /etc/pacman.conf
pacman -Syy

#--------------------  Обновление зеркал на установленной системе

pacman -S reflector --noconfirm
reflector -a 12 -l 15 -p https,http --sort rate --save /etc/pacman.d/mirrorlist --verbose


#------------  Виртуалка или нет

clear

echo "Куда устанавливем Arch Linux на виртуальную машину?"

read -p "1 - Да, 0 - Нет: " vm_setting

if [[ $vm_setting == 0 ]]; then
    pacman -S xorg-server xorg-drivers xorg-xinit
    
elif [[ $vm_setting == 1 ]]; then
    pacman -S xorg-server xorg-drivers xorg-xinit virtualbox-guest-utils
fi

#--------------    УСТАНОВКА  DE  ------------------------------------------


$DIALOG --clear --title " УСТАНОВКА ГРАФИЧЕСКОГО ОКРУЖЕНИЯ  " \
        --menu " ВЫБЕРИТЕ ИЗ СПИСКА : " 20 51 7 \
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
                pacman -S deepin deepin-extra --noconfirm
                pacman -S lxdm --noconfirm
                systemctl enable lxdm.service
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
            echo "Нажата клавиша ESC.";;
esac



#------------------  Завершение установки

#-----------    Шрифты
clear
pacman -S ttf-arphic-ukai git ttf-liberation ttf-dejavu ttf-arphic-uming ttf-fireflysung ttf-sazanami --noconfirm

#-------------- Сеть
clear
pacman -Sy networkmanager networkmanager-openvpn network-manager-applet ppp openssh --noconfirm
systemctl enable NetworkManager.service
systemctl enable dhcpcd.service
systemctl enable sshd.service

#-------------  Звук
clear
pacman -Sy pulseaudio-bluetooth alsa-utils pulseaudio-equalizer-ladspa   --noconfirm
systemctl enable bluetooth.service

#-------------  Ntfs & FAT
clear
pacman -Sy exfat-utils ntfs-3g --noconfirm

#----------------   ПО
clear
pacman -Sy unzip unrar lha file-roller gparted p7zip unace arc lrzip gvfs-afc htop xterm gvfs-mtp neofetch blueman flameshot firefox firefox-i18n-ru  --noconfirm 

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

#-----------  Папки пользователя 
mkdir /home/$username/{Downloads,Music,Pictures,Videos,Documents,time}   
chown -R $username:users  /home/$username/{Downloads,Music,Pictures,Videos,Documents,time}

#whiptail --title  "УСТАНОВКА СИСТЕМЫ" --msgbox  "Установка системы завершена. Вы можете перезагрузить компьютер" 10 60
clear
echo "УСТАНОВКА ЗАВЕРШЕНА"
exit
