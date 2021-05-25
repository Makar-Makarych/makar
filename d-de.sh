#!/bin/bash
loadkeys ru
setfont cyr-sun16


x_de2=$(whiptail --title  "УСТАНОВКА  DE" --menu  "Выберите окружение рабочего стола" 15 60 8 \

"1" "KDE (Plasma)" \
"2" "XFCE" \
"3" "GNOME" \
"4" "LXDE" \
"5" "Deepin" \
"6" "MATE" \
"7" "LXQT" \
"8" "Пропустить"  3>&1 1>&2 2>&3)
 
exitstatus=$?
if [ $exitstatus = 0 ];  
	then
    	echo "Your chosen option:" $x_de2
	else
    	echo "You chose Cancel."
fi


if [[ $x_de2 == 8 ]]; 
	then
  		echo 'уcтановка DE пропущена' 
	elif [[ $x_de2 == 1 ]]; then
		pacman -S plasma plasma-meta plasma-pa plasma-desktop kde-system-meta kde-utilities-meta kio-extras kwalletmanager latte-dock  konsole  kwalletmanager --noconfirm
		pacman -R konqueror --noconfirm
		pacman -S sddm sddm-kcm --noconfirm
		systemctl enable sddm.service -f
		

	elif [[ $x_de2 == 2 ]]; then
		pacman -S  xfce4 pavucontrol xfce4-goodies  --noconfirm
		pacman -S lxdm
		systemctl enable lxdm.service
		

	elif [[ $x_de2 == 3 ]]; then
		pacman -S gnome gnome-extra  --noconfirm
		pacman -S gdm --noconfirm
		systemctl enable gdm.service -f
		 

	elif [[ $x_de2 == 4 ]]; then
		pacman -S lxde --noconfirm
		pacman -S lxdm
		systemctl enable lxdm.service
		

	elif [[ $x_de2 == 5 ]]; then
		pacman -S deepin deepin-extra
		pacman -S lxdm
		systemctl enable lxdm.service
		

	elif [[ $x_de2 == 6 ]]; then
		pacman -S  mate mate-extra  --noconfirm
		pacman -S lxdm
		systemctl enable lxdm.service
		

	elif [[ $x_de2 == 7 ]]; then
		pacman -S lxqt lxqt-qtplugin lxqt-themes --noconfirm
		pacman -S sddm sddm-kcm --noconfirm
		systemctl enable sddm.service -f
		
fi
