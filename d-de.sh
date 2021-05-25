#!/bin/bash
loadkeys ru
setfont cyr-sun16

clear

DE=$(whiptail --title  "Графическое окружение" --menu  "Выберите рабочий стол" 15 60 28 \
	"1" "KDE (Plasma)" \
	"2" "XFCE" \
	"3" "GNOME" \
	"4" "LXDE" \
    "5" "Deepin" \
    "6" "MATE" \
	"7" "LXQT" \
	"8" "Пропустить" 3>&1 1>&2 2>&3)

exitstatus=$?
if [ $exitstatus = 0 ];  
	then
    	echo "Your chosen option:" $DE
	else
    	echo "You chose Cancel."
fi

select $DE
	do
    	case $DE 
    		in
            
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
            "5" )
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