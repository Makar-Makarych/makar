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


$DIALOG --title " КОМПЬЮТЕР " --clear \
	--inputbox " СОЗДАЙТЕ НОВОЕ ИМЯ КОМПЬЮТЕРА :" 10 60 2> $tempfile
 
retval=$?
 
case $retval in
  0)
	hostname=$(cat $tempfile)
	echo $"hostname" > /etc/hostname
    ;;
  1)
    echo "Отказ от ввода.";;
  255)
    if test -s $tempfile ; then
      cat $tempfile
    else
      echo "Нажата клавиша ESC."
    fi
    ;;
esac


$DIALOG --title " ПОЛЬЗОВАТЕЛЬ " --clear \
	--inputbox " СОЗДАЙТЕ НОВОЕ ИМЯ ПОЛЬЗОВАТЕЛЯ :" 10 60 2> $tempfile
 
retval=$?
 
case $retval in
  0)
	username=$(cat $tempfile)
	useradd -m -g users -G wheel -s /bin/bash $username
	echo $"hostname" > /etc/hostname
    ;;
  1)
    echo "Отказ от ввода.";;
  255)
    if test -s $tempfile ; then
      cat $tempfile
    else
      echo "Нажата клавиша ESC."
    fi
    ;;
esac











# hostname=$(whiptail --title  " КОМПЬЮТЕР " --inputbox  " СОЗДАЙТЕ НОВОЕ ИМЯ КОМПЬЮТЕРА " 10 60 ArchLinux 3>&1 1>&2 2>&3)
 
# exitstatus=$?
# if [ $exitstatus = 0 ];  
# 	then
#     	clear
#     	echo $"hostname" > /etc/hostname
# 	else
#     	clear
# fi


# username=$(whiptail --title  " ПОЛЬЗОВАТЕЛЬ " --inputbox  " СОЗДАЙТЕ НОВОЕ ИМЯ ПОЛЬЗОВАТЕЛЯ " 10 60 User 3>&1 1>&2 2>&3)
 
# exitstatus=$?
# if [ $exitstatus = 0 ];  then
#     clear
#     useradd -m -g users -G wheel -s /bin/bash $username
#     #echo "Your pet name is:"
# else
#     clear
#     #echo "You chose Cancel."
# fi




  clear
        echo ""
        echo -e " ПРИДУМАЙТЕ И ВВЕДИТЕ ROOT ПАРОЛЬ  "
	        passwd

    clear
        echo ""
        echo -e " ПРИДУМАЙТЕ И ВВЕДИТЕ ПАРОЛЬ ПОЛЬЗОВАТЕЛЯ  "
    	   passwd $username




#---------------------  Временная зона  --------------------------

options=$(whiptail --title  "Часовой пояс" --menu  "Выберите город" 35 60 28 \
	"1" "Калининград" \
	"2" "Красноярск" \
	"3" "Киев" \
	"4" "Магадан" \
    "5" "Киров" \
    "6" "Новокузнецк" \
	"7" "Минск" \
	"8" "Новосибирск" \
	"9" "Москва" \
	"10" "Омск" \
	"11" "Самара" \
	"12" "Уральск" \
	"13" "Саратов" \
	"14" "Алматы" \
	"15" "Ульяновск" \
	"16" "Среднеколымск" \
	"17" "Запарожье" \
	"18" "Ташкент" \
	"19" "Чита" \
	"20" "Тбилиси" \
	"21" "Иркутск" \
    "22" "Томск" \
	"23" "Стамбул" \
	"24" "Якутск" \
	"25" "Камчатка" \
	"26" "Екатеринбург" \
	"27" "Ереван" \
    "28" "Настрою часовой пояс позже" 3>&1 1>&2 2>&3)

exitstatus=$?
if [ $exitstatus = 0 ];  
	then
    	echo "Your chosen option:" $options
	else
    	echo "You chose Cancel."
fi

select $options
do
    case $options in
            "1")
            ln -sf /usr/share/zoneinfo/Europe/Kaliningrad /etc/localtime
            break
            ;;
            "2")
            ln -sf /usr/share/zoneinfo/Asia/Krasnoyarsk /etc/localtime
            break
            ;;
            "3")
            ln -sf /usr/share/zoneinfo/Europe/Kiev /etc/localtime
            break
            ;;
            "4")
            ln -sf /usr/share/zoneinfo/Asia/Magadan /etc/localtime
            break
            ;;
            "5" )
            ln -sf /usr/share/zoneinfo/Europe/Kirov /etc/localtime      
            break
            ;;
            "6")
            ln -sf /usr/share/zoneinfo/Asia/Novokuznetsk /etc/localtime
            break
            ;;
            "7")
            ln -sf /usr/share/zoneinfo/Europe/Minsk /etc/localtime
            break
            ;;
            "8")
            ln -sf /usr/share/zoneinfo/Asia/Novosibirsk /etc/localtime
            break
            ;;
            "9")
            ln -sf /usr/share/zoneinfo/Europe/Moscow /etc/localtime
            break
            ;;
            "11")
            ln -sf /usr/share/zoneinfo/Europe/Samara /etc/localtime
            break
            ;;
            "13")
            ln -sf /usr/share/zoneinfo/Europe/Saratov /etc/localtime
            break
            ;;
            "15")
            ln -sf /usr/share/zoneinfo/Europe/Ulyanovsk /etc/localtime
            break
            ;;
            "17")
            ln -sf /usr/share/zoneinfo/Europe/Zaporozhye /etc/localtime
            break
            ;;
            "19")
            ln -sf /usr/share/zoneinfo/Asia/Chita /etc/localtime
            break
            ;;
            "21")
            ln -sf /usr/share/zoneinfo/Asia/Irkutsk /etc/localtime
            break
            ;;
            "23")
            ln -sf /usr/share/zoneinfo/Asia/Istanbul /etc/localtime
            break
            ;;
            "25")
            ln -sf /usr/share/zoneinfo/Asia/Kamchatka /etc/localtime
            break
            ;;
            "10")
            ln -sf /usr/share/zoneinfo/Asia/Omsk /etc/localtime
            break
            ;;
            "12")
            ln -sf /usr/share/zoneinfo/Asia/Oral /etc/localtime
            break
            ;;
            "14")
            ln -sf /usr/share/zoneinfo/Asia/Almaty /etc/localtime
            break
            ;;
            "16")
            ln -sf /usr/share/zoneinfo/Asia/Srednekolymsk /etc/localtime
            break
            ;;
            "18")
            ln -sf /usr/share/zoneinfo/Asia/Tashkent /etc/localtime
            break
            ;;
            "20")
            ln -sf /usr/share/zoneinfo/Asia/Tbilisi /etc/localtime
            break
            ;;
            "22")
            ln -sf /usr/share/zoneinfo/Asia/Tomsk /etc/localtime
            break
            ;;
            "24")
            ln -sf /usr/share/zoneinfo/Asia/Yakutsk /etc/localtime
            break
            ;;
            "26")
            ln -sf /usr/share/zoneinfo/Asia/Yekaterinburg /etc/localtime
            break
            ;;
            "27")
            ln -sf /usr/share/zoneinfo/Asia/Yerevan /etc/localtime
            break
            ;;
            "28")
            clear
            echo " Этап пропущен "
            echo ""
            break
            ;;
            "")
            exit
            break
            ;;
        *) echo "";;
    esac
done

#----------  Ставим программу для Wi-fi'

pacman -S dialog wpa_supplicant --noconfirm 

#-------- 'Устанавливаем SUDO'

echo '%wheel ALL=(ALL) ALL' >> /etc/sudoers

#-----------------Раскомментируем репозиторий multilib Для работы 32-битных приложений в 64-битной системе.'

echo '[multilib]' >> /etc/pacman.conf
echo 'Include = /etc/pacman.d/mirrorlist' >> /etc/pacman.conf
pacman -Syy

#----------------  Виртуалка или реальная машина


if (whiptail --title  "ВИРТУАЛЬНАЯ \ РЕАЛЬНАЯ МАШИНА" --yesno  "Устанавливем Arch Linux на виртуальную машину?" 10 60)  
    then
        pacman -S xorg-server xorg-drivers xorg-xinit virtualbox-guest-utils --noconfirm 
        #echo "You chose Yes. Exit status was $?."
    else
        pacman -S xorg-server xorg-drivers xorg-xinit --noconfirm 
        #echo "You chose No. Exit status was $?."--noconfirm 
fi



#-----------  Создадим загрузочный RAM диск

mkinitcpio -p linux

#-------------  Загрузчик

pacman -Syy
pacman -S grub efibootmgr --noconfirm 
grub-install --target=x86_64-efi --efi-directory=/boot/efi --bootloader-id=grub
grub-mkconfig -o /boot/grub/grub.cfg

#---------  Установка графической оболочки

clear
graf=$(whiptail --title  "Часовой пояс" --menu  "Выберите город" 15 60 8 \
	"1" "KDE (Plasma)" \
	"2" "XFCE" \
	"3" "GNOME" \
	"4" "LXDE" \
    "5" "Deepin" \
    "6" "MATE" \
	"7" "LXQT" \
	"8" "Пропустить" 3>&1 1>&2 2>&3)


# exitstatus=$?
# if [ $exitstatus = 0 ];  
# 	then
#     	clear
#         #echo "Your chosen option:" $DE
# 	else
#     	clear
#         echo "Результат ------- ." $graf
# fi



select $graf
    do
    	case $graf in 
            "1")
				pacman -S plasma plasma-meta plasma-pa plasma-desktop kde-system-meta kde-utilities-meta kio-extras kwalletmanager latte-dock  konsole  kwalletmanager --noconfirm
				pacman -R konqueror --noconfirm
				pacman -S sddm sddm-kcm --noconfirm
				systemctl enable sddm.service -f
            break
            ;;
            "2")
 		        pacman -S  xfce4 pavucontrol xfce4-goodies  --noconfirm
				pacman -S lxdm
				systemctl enable lxdm.service
            break
            ;;
            "3")
            	pacman -S gnome gnome-extra  --noconfirm
				pacman -S gdm --noconfirm
				systemctl enable gdm.service -f
            break
            ;;
            "4")
            	pacman -S lxde --noconfirm
				pacman -S lxdm
				systemctl enable lxdm.service
            break
            ;;
            "5")
            	pacman -S deepin deepin-extra
				pacman -S lxdm
				systemctl enable lxdm.service
		    break
            ;;
            "6")
            	pacman -S  mate mate-extra  --noconfirm
				pacman -S lxdm
				systemctl enable lxdm.service
            break
            ;;
            "7")
           		pacman -S lxqt lxqt-qtplugin lxqt-themes --noconfirm
				pacman -S sddm sddm-kcm --noconfirm
				systemctl enable sddm.service -f
            break
            ;;
            "8")
            clear
            echo " Этап пропущен "
            echo ""
            break
            ;;
            "")
            exit
            break
            ;;
        *) echo "";;
        esac
done

#------------------  Завершение установки

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

whiptail --title  "УСТАНОВКА СИСТЕМЫ" --msgbox  "Установка системы завершена. Вы можете перезагрузить компьютер" 10 60

exit










#sh d-user.sh       #-------  Раскладка, пользователь, врем. зона, виртуалка или реальная
#sh -c "$(curl -fsSL https://raw.githubusercontent.com/Makar-Makarych/makar/main/d-user.sh)"

#sh grub-btr.sh     #-------  Установка загрузчика
#sh -c "$(curl -fsSL https://raw.githubusercontent.com/Makar-Makarych/makar/main/grub-btr.sh)"

#sh d-de.sh         #-------  Установка окружения
#sh -c "$(curl -fsSL https://raw.githubusercontent.com/Makar-Makarych/makar/main/d-de.sh)" 

#d-de.sh

#sh d-end.sh        #-------  YAY, Pamac, Шрифты, Звук, Сеть
#sh -c "$(curl -fsSL https://raw.githubusercontent.com/Makar-Makarych/makar/main/d-end.sh)"