#!/bin/bash
loadkeys ru
setfont cyr-sun16

arch-chroot /mnt

echo -e "ДЛЯ ПРОДОЛЖЕНИЯ УСТАНОВКИ ПРИДУМАЙТЕ И ВВЕДИТЕ ROOT ПАРОЛЬ"

passwd


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

#-----------  Создадим загрузочный RAM диск
mkinitcpio -p linux

#-------------  Загрузчик
pacman -Syy
pacman -S grub efibootmgr --noconfirm 
grub-install --target=x86_64-efi --efi-directory=/boot/efi --bootloader-id=grub
grub-mkconfig -o /boot/grub/grub.cfg


echo 'Ставим программу для Wi-fi'
pacman -S dialog wpa_supplicant --noconfirm 

echo 'Добавляем пользователя'
useradd -m -g users -G wheel -s /bin/bash $username




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
 
####
echo ""
echo " Установим DE/WM "
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
pacman -S sddm sddm-kcm --noconfirm
systemctl enable sddm.service -f
clear
echo "Plasma KDE успешно установлена"

elif [[ $x_de2 == 2 ]]; then
pacman -S  xfce4 pavucontrol xfce4-goodies  --noconfirm
pacman -S lxdm
systemctl enable lxdm.service
clear
echo "Xfce успешно установлено"

elif [[ $x_de2 == 3 ]]; then
pacman -S gnome gnome-extra  --noconfirm
pacman -S gdm --noconfirm
systemctl enable gdm.service -f
clear
echo " установка gdm завершена "
clear
echo " Gnome успешно установлен " 

elif [[ $x_de2 == 4 ]]; then
pacman -S lxde --noconfirm
pacman -S lxdm
systemctl enable lxdm.service
clear
echo " lxde успешно установлен "

elif [[ $x_de2 == 5 ]]; then
pacman -S deepin deepin-extra
pacman -S lxdm
systemctl enable lxdm.service
clear
echo " Deepin успешно установлен "

elif [[ $x_de2 == 6 ]]; then
pacman -S  mate mate-extra  --noconfirm
pacman -S lxdm
systemctl enable lxdm.service
clear
echo " Mate успешно установлен "

elif [[ $x_de2 == 7 ]]; then
pacman -S lxqt lxqt-qtplugin lxqt-themes --noconfirm
pacman -S sddm sddm-kcm --noconfirm
systemctl enable sddm.service -f
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

#------------ Перезагруз


clear
echo "УСТАНОВКА ЗАВЕРШЕНА. ПЕРЕЗАГРУЗИТЕ КОМПЬЮТЕР"
exit





