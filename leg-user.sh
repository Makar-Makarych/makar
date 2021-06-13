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

$DIALOG --title "  ИМЯ КОМПЬЮТЕРА  " --clear \
    --inputbox "  ПРИДУМАЙТЕ И ВВЕДИТЕ ИМЯ КОМПЬЮТЕРА" 10 60 2> $tempfile
        hostname=`cat $tempfile`
        echo $hostname > /etc/hostname
	    
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
	     "Владивосток" ""\
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
                clear
                ln -sf /usr/share/zoneinfo/Asia/Almaty /etc/localtime
             break
             ;;
		          "Владивосток")
                clear
                ln -sf /usr/share/zoneinfo/Asia/Vladivostok /etc/localtime
             break
             ;;     
	      	    "Екатеринбург")
                clear
                ln -sf /usr/share/zoneinfo/Asia/Yekaterinburg /etc/localtime
             break
             ;;
                "Ереван")
                clear
                ln -sf /usr/share/zoneinfo/Asia/Yerevan /etc/localtime
             break
             ;;
                "Запарожье")
                clear
                ln -sf /usr/share/zoneinfo/Europe/Zaporozhye /etc/localtime
             break
             ;;
                "Иркутск")
                clear
                ln -sf /usr/share/zoneinfo/Asia/Irkutsk /etc/localtime
             break
             ;;
                "Калининград")
                clear
                ln -sf /usr/share/zoneinfo/Europe/Kaliningrad /etc/localtime
             break
             ;;
                "Камчатка")
                clear
                ln -sf /usr/share/zoneinfo/Asia/Kamchatka /etc/localtime
             break
             ;;
                "Киев")
                clear
                ln -sf /usr/share/zoneinfo/Europe/Kiev /etc/localtime
             break
             ;;
                "Киров" )
                clear
                ln -sf /usr/share/zoneinfo/Europe/Kirov /etc/localtime      
             break
             ;;
                "Красноярск")
                clear
                ln -sf /usr/share/zoneinfo/Asia/Krasnoyarsk /etc/localtime
             break
             ;;
                "Магадан")
                clear
                ln -sf /usr/share/zoneinfo/Asia/Magadan /etc/localtime
             break
             ;;
                "Минск")
                clear
                ln -sf /usr/share/zoneinfo/Europe/Minsk /etc/localtime
             break
             ;;
                "Москва")
                clear
                ln -sf /usr/share/zoneinfo/Europe/Moscow /etc/localtime
             break
             ;;
                "Новокузнецк")
                clear
                ln -sf /usr/share/zoneinfo/Asia/Novokuznetsk /etc/localtime
             break
             ;;
                "Новосибирск")
                clear
                ln -sf /usr/share/zoneinfo/Asia/Novosibirsk /etc/localtime
             break
             ;;
                "Омск")
                clear
                ln -sf /usr/share/zoneinfo/Asia/Omsk /etc/localtime
             break
             ;;
                "Самара")
                clear
                ln -sf /usr/share/zoneinfo/Europe/Samara /etc/localtime
             break
             ;;
                "Саратов")
                clear
                ln -sf /usr/share/zoneinfo/Europe/Saratov /etc/localtime
             break
             ;;
                "Среднеколымск")
                clear
                ln -sf /usr/share/zoneinfo/Asia/Srednekolymsk /etc/localtime
             break
             ;;
                "Стамбул")
                clear
                ln -sf /usr/share/zoneinfo/Asia/Istanbul /etc/localtime
             break
             ;;
                "Ташкент")
                clear
                ln -sf /usr/share/zoneinfo/Asia/Tashkent /etc/localtime
             break
             ;;
                "Тбилиси")
                clear
                ln -sf /usr/share/zoneinfo/Asia/Tbilisi /etc/localtime
             break
             ;;
                "Томск")
                clear
                ln -sf /usr/share/zoneinfo/Asia/Tomsk /etc/localtime
             break
             ;;
                "Ульяновск")
                clear
                ln -sf /usr/share/zoneinfo/Europe/Ulyanovsk /etc/localtime
             break
             ;;
                "Уральск")
                clear
                ln -sf /usr/share/zoneinfo/Asia/Oral /etc/localtime
             break
             ;;
                "Чита")
                clear
                ln -sf /usr/share/zoneinfo/Asia/Chita /etc/localtime
             break
             ;;
                "Якутск")
                clear
                ln -sf /usr/share/zoneinfo/Asia/Yakutsk /etc/localtime
             break
             ;;
        255)
            echo "Нажата клавиша ESC.";;
esac

#-----------  Создадим загрузочный RAM диск
mkinitcpio -p linux

#----------------   Ставим программу для Wi-fi
pacman -S wpa_supplicant --noconfirm 

#------------    Настраиваем  SUDO
echo '%wheel ALL=(ALL) ALL' >> /etc/sudoers

#-----    Раскомментируем репозиторий multilib Для работы 32-битных приложений в 64-битной системе
echo '[multilib]' >> /etc/pacman.conf
echo 'Include = /etc/pacman.d/mirrorlist' >> /etc/pacman.conf
pacman -Syy

#-----------  Reflector
pacman -S reflector --noconfirm

#--------------------  Обновление зеркал на установленной системе

$DIALOG --title "ОБНОВЛЕНИЕ ЗЕРКАЛ" --clear \
        --yesno "Обновить зеркала на установленной системе ?" 10 40
 
case $? in
    0)
        clear
        reflector -a 12 -l 15 -p https,http --sort rate --save /etc/pacman.d/mirrorlist --verbose
        ;;
    1)
        echo " NO "
        ;;
    255)
        echo " ESC."
        ;;
esac

#------------  Виртуалка или нет

$DIALOG --title " ВМРТУАЛЬНАЯ или РЕАЛЬНАЯ МАШИНА " --clear \
        --yesno "УСТАНОВКА ПРОХОДИТ НА ВИРТУАЛЬНУЮ МАШИНУ ?" 10 40
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
                pacman -S xfce4 pavucontrol xfce4-goodies lightdm lightdm-gtk-greeter --noconfirm
                systemctl enable lightdm.service 
                #pacman -S lxdm --noconfirm
                #systemctl enable lxdm.service
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
            echo "Нажата клавиша ESC.";;
esac



#------------------  Завершение установки

#-----------    Шрифты
clear
pacman -S ttf-arphic-ukai git ttf-liberation ttf-dejavu ttf-arphic-uming ttf-fireflysung ttf-sazanami --noconfirm

#-------------- Сеть
clear
pacman -S networkmanager networkmanager-openvpn network-manager-applet ppp openssh --noconfirm
systemctl enable NetworkManager.service
systemctl enable dhcpcd.service
systemctl enable sshd.service

#-------------  Звук
clear
pacman -S pulseaudio-bluetooth alsa-utils pulseaudio-equalizer-ladspa   --noconfirm
systemctl enable bluetooth.service

#--------  Для Bash и Btrfs
pacman -S bash-completion grub-btrfs --noconfirm

#-------------  Ntfs & FAT + gvfs
clear
pacman -S exfat-utils ntfs-3g gvfs --noconfirm

#----------------   ПО
clear
pacman -S file-roller gparted p7zip unace lrzip gvfs-afc htop xterm gvfs-mtp neofetch blueman flameshot mesa firefox firefox-i18n-ru  --noconfirm 

#------------------------ Дополнительное ПО

$DIALOG --title " ДОПОЛНИТЕЛНОЕ ПО" --clear \
        --yesno "УСТАНОВИТЬ ДОПОЛНИТЕЛЬНЫЕ ПРОГРАММЫ (YAY,  PAMAC)?" 10 60
 
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
            echo "Нажата клавиша ESC.";;
esac

#-----------  Папки пользователя 
mkdir /home/$username/{Downloads,Music,Pictures,Videos,Documents,time}   
chown -R $username:users  /home/$username/{Downloads,Music,Pictures,Videos,Documents,time}

#-------------  Загрузчик

$DIALOG --title "GRUB" --clear \
        --inputbox "На какой диск ставить загрузчик GRUB ? (sda/sdb/sdc - ПРИМЕР: sda )" 16 51 2> $tempfile
         clear
         grubd=`cat $tempfile`
         pacman -Sy grub os-prober --noconfirm 
         grub-install /dev/$grubd
         grub-mkconfig -o /boot/grub/grub.cfg

#------------ END

$DIALOG --title " OK ! " --clear \
        --yesno "УСТАНОВКА СИСТЕМЫ ЗАВЕРШЕНА. ПЕРЕЗАГРУЗИТЬ КОМПЬЮТЕР ?" 10 60
 
case $? in
    0)
         umount -R /mnt
         reboot;;
    1)
         clear
        exit;;
    255)
         echo "Нажата клавиша ESC.";;
esac

   clear
echo "УСТАНОВКА ЗАВЕРШЕНА"
exit
