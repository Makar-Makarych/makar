#!/bin/bash
loadkeys ru
setfont cyr-sun

clear
read -p "Введите имя компьютера: " hostname
read -p "Введите имя пользователя: " username

echo 'Прописываем имя компьютера'
echo $hostname > /etc/hostname

### ----------------    Часовой пояс


echo -e " Часовые пояса  \n"

PS3=' ВВедите номер ответа : '
options=("Калининград" "Красноярск" "Киев" "Магадан" "Киров" "Новокузнецк" "Минск" "Новосибирск" "Москва" "Омск" "Самара" "Уральск" "Саратов" "Алматы" "Ульяновск" "Среднеколымск" "Запарожье" "Ташкент" "Чита" "Тбилиси" "Иркутск" "Томск" "Стамбул" "Якутск" "Камчатка" "Екатеринбург" "Ереван" "Настрою позднее" "Ну нахер все, выход из скрипта!")
select opt in "${options[@]}"
do
    case $opt in
            "Калининград")
            ln -sf /usr/share/zoneinfo/Europe/Kaliningrad /etc/localtime
            break
            ;;
            "Красноярск")
            ln -sf /usr/share/zoneinfo/Asia/Krasnoyarsk /etc/localtime
            break
            ;;
            "Киев")
            ln -sf /usr/share/zoneinfo/Europe/Kiev /etc/localtime
            break
            ;;
            "Магадан")
            ln -sf /usr/share/zoneinfo/Asia/Magadan /etc/localtime
            break
            ;;
            "Киров" )
            ln -sf /usr/share/zoneinfo/Europe/Kirov /etc/localtime      
            break
            ;;
            "Новокузнецк")
            ln -sf /usr/share/zoneinfo/Asia/Novokuznetsk /etc/localtime
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
            "Самара")
            ln -sf /usr/share/zoneinfo/Europe/Samara /etc/localtime
            break
            ;;
            "Саратов")
            ln -sf /usr/share/zoneinfo/Europe/Saratov /etc/localtime
            break
            ;;
            "Ульяновск")
            ln -sf /usr/share/zoneinfo/Europe/Ulyanovsk /etc/localtime
            break
            ;;
            "Запарожье")
            ln -sf /usr/share/zoneinfo/Europe/Zaporozhye /etc/localtime
            break
            ;;
            "Чита")
            ln -sf /usr/share/zoneinfo/Asia/Chita /etc/localtime
            break
            ;;
            "Иркутск")
            ln -sf /usr/share/zoneinfo/Asia/Irkutsk /etc/localtime
            break
            ;;
            "Стамбул")
            ln -sf /usr/share/zoneinfo/Asia/Istanbul /etc/localtime
            break
            ;;
            "Камчатка")
            ln -sf /usr/share/zoneinfo/Asia/Kamchatka /etc/localtime
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
            "Уральск")
            ln -sf /usr/share/zoneinfo/Asia/Oral /etc/localtime
            break
            ;;
            "Алматы")
            ln -sf /usr/share/zoneinfo/Asia/Almaty /etc/localtime
            break
            ;;
            "Среднеколымск")
            ln -sf /usr/share/zoneinfo/Asia/Srednekolymsk /etc/localtime
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
            "Якутск")
            ln -sf /usr/share/zoneinfo/Asia/Yakutsk /etc/localtime
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
            "Настрою позднее")
            clear
            echo " Этап пропущен "
            echo ""
            break
            ;;
            "Ну нахер все, выход из скрипта!")
            exit
            break
            ;;
        *) echo "Хрень какую-то Ввели, попробуем еще раз? $REPLY";;
    esac
done
echo -e "\033[32m"
read -n 1 -s -r -p "Нажмите любую кнопку для продолжения"
echo -e "\033[0m"

#-----------  Добавляем русскую локаль  и язык системы

echo "en_US.UTF-8 UTF-8" > /etc/locale.gen
echo "ru_RU.UTF-8 UTF-8" >> /etc/locale.gen
locale-gen
echo 'LANG="ru_RU.UTF-8"' > /etc/locale.conf 
echo "KEYMAP=ru" >> /etc/vconsole.conf
echo "FONT=cyr-sun16" >> /etc/vconsole.conf

#-----------

echo 'Создадим загрузочный RAM диск'
mkinitcpio -p linux

read -p "Укажите диск куда установить GRUB (sda/sdb): " x_boot
pacman -Syy
pacman -S grub --noconfirm
grub-install /dev/$x_boot
grub-mkconfig -o /boot/grub/grub.cfg


echo 'Ставим программу для Wi-fi'
pacman -S dialog wpa_supplicant --noconfirm 

echo 'Добавляем пользователя'
useradd -m -g users -G wheel -s /bin/bash $username

echo 'Создаем root пароль'
passwd

echo 'Устанавливаем пароль пользователя'
passwd $username

echo 'Устанавливаем SUDO'
echo '%wheel ALL=(ALL) ALL' >> /etc/sudoers

echo 'Раскомментируем репозиторий multilib Для работы 32-битных приложений в 64-битной системе.'
echo '[multilib]' >> /etc/pacman.conf
echo 'Include = /etc/pacman.d/mirrorlist' >> /etc/pacman.conf
pacman -Syy

echo "Куда устанавливем Arch Linux на виртуальную машину?"
read -p "1 - Да, 0 - Нет: " vm_setting
if [[ $vm_setting == 0 ]]; then
  gui_install="xorg-server xorg-drivers xorg-xinit"
elif [[ $vm_setting == 1 ]]; then
  gui_install="xorg-server xorg-drivers xorg-xinit virtualbox-guest-utils"
fi

################# УСТАНОВКА  DE  ------------------------------------------

echo "#####################################################################"
echo ""
echo " Установим DE/WM? "
while 
    read -n1 -p  "
    1 - KDE(Plasma)
    
    2 - xfce 
    
    3 - gmome
    
    4 - lxde
    
    5 - Deepin

    6 - Mate

    7 - Lxqt
    
    8 - i3 (  конфиги стандартные, возможна установка с автовходом )

    0 - пропустить " x_de
    echo ''
    [[ "$x_de" =~ [^123456780] ]]
do
    :
done
if [[ $x_de == 0 ]]; then
  echo 'уcтановка DE пропущена' 
elif [[ $x_de == 1 ]]; then
pacman -S  plasma plasma-meta plasma-pa plasma-desktop kde-system-meta kde-utilities-meta kio-extras kwalletmanager latte-dock  konsole  kwalletmanager --noconfirm
clear
echo " Если желаете использовать 2 окружения тогда укажите 0  "
echo ""
echo " Нужен автовход без DM ? "
while 
    read -n1 -p  "
    1 - да  
    
    0 - нет : " i_kde   # sends right after the keypress
    echo ''
    [[ "$i_kde" =~ [^10] ]]
do
    :
done
if [[ $i_kde  == 0 ]]; then
echo " буду использовами DM "
elif [[ $i_kde  == 1 ]]; then
pacman -S xorg-xinit --noconfirm
cp /etc/X11/xinit/xinitrc /home/$username/.xinitrc
chown $username:users /home/$username/.xinitrc
chmod +x /home/$username/.xinitrc
sed -i 52,55d /home/$username/.xinitrc
echo "exec startplasma-x11 " >> /home/$username/.xinitrc
mkdir /etc/systemd/system/getty@tty1.service.d/
echo " [Service] " > /etc/systemd/system/getty@tty1.service.d/override.conf
echo " ExecStart=" >> /etc/systemd/system/getty@tty1.service.d/override.conf
echo   ExecStart=-/usr/bin/agetty --autologin $username --noclear %I 38400 linux >> /etc/systemd/system/getty@tty1.service.d/override.conf
echo ' [[ -z $DISPLAY && $XDG_VTNR -eq 1 ]] && exec startx ' >> /etc/profile
fi
pacman -R konqueror --noconfirm
clear
echo "Plasma KDE успешно установлена"
elif [[ $x_de == 2 ]]; then
pacman -S  xfce4  pavucontrol xfce4-goodies  --noconfirm
clear
echo " Если желаете использовать 2 окружения тогда укажите 0  "
echo ""
echo " Нужен автовход без DM ? "
while 
    read -n1 -p  "
    1 - да  
    
    0 - нет : " i_xfce   # sends right after the keypress
    echo ''
    [[ "$i_xfce" =~ [^10] ]]
do
    :
done
if [[ $i_xfce  == 0 ]]; then
echo " буду использовами DM "
elif [[ $i_xfce  == 1 ]]; then
pacman -S xorg-xinit --noconfirm
cp /etc/X11/xinit/xinitrc /home/$username/.xinitrc
chown $username:users /home/$username/.xinitrc
chmod +x /home/$username/.xinitrc
sed -i 52,55d /home/$username/.xinitrc
echo "exec startxfce4 " >> /home/$username/.xinitrc
mkdir /etc/systemd/system/getty@tty1.service.d/
echo " [Service] " > /etc/systemd/system/getty@tty1.service.d/override.conf
echo " ExecStart=" >> /etc/systemd/system/getty@tty1.service.d/override.conf
echo   ExecStart=-/usr/bin/agetty --autologin $username --noclear %I 38400 linux >> /etc/systemd/system/getty@tty1.service.d/override.conf
echo ' [[ -z $DISPLAY && $XDG_VTNR -eq 1 ]] && exec startx ' >> /etc/profile
fi
clear
echo "Xfce успешно установлено"
elif [[ $x_de == 3 ]]; then
pacman -S gnome gnome-extra  --noconfirm
clear
echo " Gnome успешно установлен " 
elif [[ $x_de == 4 ]]; then
pacman -S lxde --noconfirm
clear
echo " Если желаете использовать 2 окружения тогда укажите 0  "
echo ""
echo " Нужен автовход без DM ? "
while 
    read -n1 -p  "
    1 - да  
    
    0 - нет : " i_lxde   # sends right after the keypress
    echo ''
    [[ "$i_lxde" =~ [^10] ]]
do
    :
done
if [[ $i_lxde  == 0 ]]; then
echo " буду использовами DM "
elif [[ $i_lxde  == 1 ]]; then
pacman -S xorg-xinit --noconfirm
cp /etc/X11/xinit/xinitrc /home/$username/.xinitrc
chown $username:users /home/$username/.xinitrc
chmod +x /home/$username/.xinitrc
sed -i 52,55d /home/$username/.xinitrc
echo "exec startlxde " >> /home/$username/.xinitrc
mkdir /etc/systemd/system/getty@tty1.service.d/
echo " [Service] " > /etc/systemd/system/getty@tty1.service.d/override.conf
echo " ExecStart=" >> /etc/systemd/system/getty@tty1.service.d/override.conf
echo   ExecStart=-/usr/bin/agetty --autologin $username --noclear %I 38400 linux >> /etc/systemd/system/getty@tty1.service.d/override.conf
echo ' [[ -z $DISPLAY && $XDG_VTNR -eq 1 ]] && exec startx ' >> /etc/profile
fi
clear
echo " lxde успешно установлен "
elif [[ $x_de == 5 ]]; then
pacman -S deepin deepin-extra --noconfirm
clear
echo " Если желаете использовать 2 окружения тогда укажите 0  "
echo ""
echo " Нужен автовход без DM ? "
while 
    read -n1 -p  "
    1 - да  
    
    0 - нет : " i_deepin   # sends right after the keypress
    echo ''
    [[ "$i_deepin" =~ [^10] ]]
do
    :
done
if [[ $i_deepin  == 0 ]]; then
echo " буду использовами DM "
elif [[ $i_deepin  == 1 ]]; then
pacman -S xorg-xinit --noconfirm
cp /etc/X11/xinit/xinitrc /home/$username/.xinitrc
chown $username:users /home/$username/.xinitrc
chmod +x /home/$username/.xinitrc
sed -i 52,55d /home/$username/.xinitrc
echo "exec startdde  " >> /home/$username/.xinitrc
mkdir /etc/systemd/system/getty@tty1.service.d/
echo " [Service] " > /etc/systemd/system/getty@tty1.service.d/override.conf
echo " ExecStart=" >> /etc/systemd/system/getty@tty1.service.d/override.conf
echo   ExecStart=-/usr/bin/agetty --autologin $username --noclear %I 38400 linux >> /etc/systemd/system/getty@tty1.service.d/override.conf
echo ' [[ -z $DISPLAY && $XDG_VTNR -eq 1 ]] && exec startx ' >> /etc/profile
fi
clear
echo " Deepin успешно установлен "
elif [[ $x_de == 6 ]]; then
pacman -S  mate mate-extra  --noconfirm
clear
echo " Если желаете использовать 2 окружения тогда укажите 0  "
echo ""
echo " Нужен автовход без DM ? "
while 
    read -n1 -p  "
    1 - да  
    
    0 - нет : " i_mate   # sends right after the keypress
    echo ''
    [[ "$i_mate" =~ [^10] ]]
do
    :
done
if [[ $i_mate  == 0 ]]; then
echo " буду использовами DM "
elif [[ $i_mate  == 1 ]]; then
pacman -S xorg-xinit --noconfirm
cp /etc/X11/xinit/xinitrc /home/$username/.xinitrc
chown $username:users /home/$username/.xinitrc
chmod +x /home/$username/.xinitrc
sed -i 52,55d /home/$username/.xinitrc
echo "exec mate-session  " >> /home/$username/.xinitrc
mkdir /etc/systemd/system/getty@tty1.service.d/
echo " [Service] " > /etc/systemd/system/getty@tty1.service.d/override.conf
echo " ExecStart=" >> /etc/systemd/system/getty@tty1.service.d/override.conf
echo   ExecStart=-/usr/bin/agetty --autologin $username --noclear %I 38400 linux >> /etc/systemd/system/getty@tty1.service.d/override.conf
echo ' [[ -z $DISPLAY && $XDG_VTNR -eq 1 ]] && exec startx ' >> /etc/profile
fi
clear
echo " Mate успешно установлен "
elif [[ $x_de == 7 ]]; then
pacman -S lxqt lxqt-qtplugin lxqt-themes oxygen-icons xscreensaver --noconfirm
clear
echo " Если желаете использовать 2 окружения тогда укажите 0  "
echo ""
echo " Нужен автовход без DM ? "
while 
    read -n1 -p  "
    1 - да  
    
    0 - нет : " i_lxqt   # sends right after the keypress
    echo ''
    [[ "$i_deepin" =~ [^10] ]]
do
    :
done
if [[ $i_lxqt  == 0 ]]; then
echo " буду использовами DM "
elif [[ $i_lxqt  == 1 ]]; then
pacman -S xorg-xinit --noconfirm
cp /etc/X11/xinit/xinitrc /home/$username/.xinitrc
chown $username:users /home/$username/.xinitrc
chmod +x /home/$username/.xinitrc
sed -i 52,55d /home/$username/.xinitrc
echo "exec startlxqt " >> /home/$username/.xinitrc
mkdir /etc/systemd/system/getty@tty1.service.d/
echo " [Service] " > /etc/systemd/system/getty@tty1.service.d/override.conf
echo " ExecStart=" >> /etc/systemd/system/getty@tty1.service.d/override.conf
echo   ExecStart=-/usr/bin/agetty --autologin $username --noclear %I 38400 linux >> /etc/systemd/system/getty@tty1.service.d/override.conf
echo ' [[ -z $DISPLAY && $XDG_VTNR -eq 1 ]] && exec startx ' >> /etc/profile
fi
clear
echo " Lxqt успешно установлен "
elif [[ $x_de == 8 ]]; then
pacman -S i3 i3-wm i3status dmenu --noconfirm
clear
echo ""
echo " Если желаете использовать 2 окружения тогда укажите 0  "
echo ""
echo " Нужен автовход без DM ? "
while 
    read -n1 -p  "
    1 - да  
    
    0 - нет : " i_i3w   # sends right after the keypress
    echo ''
    [[ "$i_i3w" =~ [^10] ]]
do
    :
done
if [[ $i_i3w  == 0 ]]; then
echo " буду использовами DM "
elif [[ $i_i3w  == 1 ]]; then
pacman -S xorg-xinit --noconfirm
cp /etc/X11/xinit/xinitrc /home/$username/.xinitrc
chown $username:users /home/$username/.xinitrc
chmod +x /home/$username/.xinitrc
sed -i 52,55d /home/$username/.xinitrc
echo "exec i3 " >> /home/$username/.xinitrc
mkdir /etc/systemd/system/getty@tty1.service.d/
echo " [Service] " > /etc/systemd/system/getty@tty1.service.d/override.conf
echo " ExecStart=" >> /etc/systemd/system/getty@tty1.service.d/override.conf
echo   ExecStart=-/usr/bin/agetty --autologin $username --noclear %I 38400 linux >> /etc/systemd/system/getty@tty1.service.d/override.conf
echo ' [[ -z $DISPLAY && $XDG_VTNR -eq 1 ]] && exec startx ' >> /etc/profile
fi
echo ""
echo " nitrogen - легкая программа для установки обоев на рабочий стол" 
echo ""
echo " Установим nitrogen? "
while 
    read -n1 -p  "
    1 - да  
    
    0 - нет : " i_natro   # sends right after the keypress
    echo ''
    [[ "$i_natro" =~ [^10] ]]
do
    :
done
if [[ $i_natro  == 0 ]]; then
echo "yстановка пропущена"
elif [[ $i_natro  == 1 ]]; then
pacman -Sy nitrogen  --noconfirm
fi
echo " i3wm успешно установлен " 
fi
clear 
####
echo ""
echo " Установим еще одно DE/WM? "
while 
    read -n1 -p  "
    1 - KDE(Plasma)
    
    2 - xfce 
    
    3 - gmome
    
    4 - lxde
    
    5 - Deepin

    6 - Mate

    7 - Lxqt
    
    8 - i3 ( конфиги стандартные, не забудьте установить DM )

    0 - пропустить " x_de2
    echo ''
    [[ "$x_de2" =~ [^123456780] ]]
do
    :
done
if [[ $x_de2 == 0 ]]; then
  echo 'уcтановка DE пропущена' 
elif [[ $x_de2 == 1 ]]; then
pacman -S plasma plasma-meta plasma-pa plasma-desktop kde-system-meta kde-utilities-meta kio-extras kwalletmanager latte-dock  konsole  kwalletmanager --noconfirm
pacman -R konqueror --noconfirm
clear
echo "Plasma KDE успешно установлена"
elif [[ $x_de2 == 2 ]]; then
pacman -S  xfce4 pavucontrol xfce4-goodies  --noconfirm
clear
echo "Xfce успешно установлено"
elif [[ $x_de2 == 3 ]]; then
pacman -S gnome gnome-extra  --noconfirm
clear
echo " Gnome успешно установлен " 
elif [[ $x_de2 == 4 ]]; then
pacman -S lxde --noconfirm
clear
echo " lxde успешно установлен "
elif [[ $x_de2 == 5 ]]; then
pacman -S deepin deepin-extra
clear
echo " Deepin успешно установлен "
elif [[ $x_de2 == 6 ]]; then
pacman -S  mate mate-extra  --noconfirm
clear
echo " Mate успешно установлен "
elif [[ $x_de2 == 7 ]]; then
pacman -S lxqt lxqt-qtplugin lxqt-themes --noconfirm
clear
echo " Lxqt успешно установлен "
elif [[ $x_de2 == 8 ]]; then
pacman -S i3 i3-wm i3status  dmenu  --noconfirm
clear
echo " Установка i3 завершена "
echo ""
echo " nitrogen - легкая программа для установки обоев на рабочий стол" 
echo ""
echo " Установим nitrogen? "
while 
    read -n1 -p  "
    1 - да  
    
    0 - нет : " i_natro   # sends right after the keypress
    echo ''
    [[ "$i_natro" =~ [^10] ]]
do
    :
done
if [[ $i_natro  == 0 ]]; then
echo "yстановка пропущена"
elif [[ $i_natro  == 1 ]]; then
pacman -Sy nitrogen  --noconfirm
fi 
fi
clear
echo "#####################################################################"
echo ""
echo " При установке i3  без dm, dm не ставим!!! " 
echo " 
Arch-wiki рекоендует для: 
kde      <-> sddm
Lxqt     <-> sddm
xfce(i3) <-> lightdm
lxde     <-> lightdm
Gnome    <-> gdm
Deepin   <-> lightdm
Mate     <-> lightdm "
echo ""
echo "Установка Менеджера входа в систему "
while 
    read -n1 -p  "
    1 - Sddm
    
    2 - lightdm 
    
    3 - gdm
    
    0 - пропустить: " i_dm # sends right after the keypress
    
    echo ''
    [[ "$i_dm" =~ [^1230] ]]
do
    :
done
if [[ $i_dm == 0 ]]; then
clear
echo " Установка пропущена "
elif [[ $i_dm == 1 ]]; then
pacman -S sddm sddm-kcm --noconfirm
systemctl enable sddm.service -f
clear
echo " установка sddm  завершена "
elif [[ $i_dm == 2 ]]; then
pacman -S lightdm lightdm-gtk-greeter-settings lightdm-gtk-greeter --noconfirm
systemctl enable lightdm.service -f
clear
echo " установка lightdm завершена "
elif [[ $i_dm == 3 ]]; then
pacman -S gdm --noconfirm
systemctl enable gdm.service -f
clear
echo " установка gdm завершена "
fi

#-----------    Шрифты
pacman -S ttf-arphic-ukai git ttf-liberation ttf-dejavu ttf-arphic-uming ttf-fireflysung ttf-sazanami --noconfirm

#-------------- Сеть
pacman -Sy networkmanager networkmanager-openvpn network-manager-applet ppp openssh --noconfirm
systemctl enable NetworkManager.service
systemctl enable dhcpcd.service
systemctl enable sshd.service

#-------------  Звук
pacman -Sy pulseaudio-bluetooth alsa-utils pulseaudio-equalizer-ladspa   --noconfirm
systemctl enable bluetooth.service

#-------------  Ntfs & FAT
pacman -Sy exfat-utils ntfs-3g --noconfirm

#----------------   ПО
pacman -Sy unzip unrar lha file-roller gparted p7zip unace arc lrzip gvfs-afc htop xterm gvfs-mtp neofetch blueman flameshot firefox firefox-i18n-ru  --noconfirm 
#----------------  YAY

cd /home/$username
git clone https://aur.archlinux.org/yay.git
chown -R $username:users /home/$username/yay
chown -R $username:users /home/$username/yay/PKGBUILD 
cd /home/$username/yay  
sudo -u $username  makepkg -si --noconfirm  
rm -Rf /home/$username/yay
clear

#-------------------  PAMAC-AUR

cd /home/$username
 git clone https://aur.archlinux.org/pamac-aur.git
chown -R $username:users /home/$username/pamac-aur
chown -R $username:users /home/$username/pamac-aur/PKGBUILD 
cd /home/$username/pamac-aur
sudo -u $username  makepkg -si --noconfirm  
rm -Rf /home/$username/pamac-aur
clear

#-----------  Папки пользователя 
mkdir /home/$username/{Downloads,Music,Pictures,Videos,Documents,time}   
chown -R $username:users  /home/$username/{Downloads,Music,Pictures,Videos,Documents,time}
