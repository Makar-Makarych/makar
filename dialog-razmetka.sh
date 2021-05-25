#!/bin/bash
loadkeys ru
setfont cyr-sun16

if (whiptail --title  "НУЖНА ЛИ РАЗМЕТКА (переразметка) ВАШЕГО ДИСКА ?" --yesno "$(lsblk)" 30 60)  
	then
		cfd=$(whiptail --title  "УКАЖИТЕ ИМЯ ДИСКА (sda/sdb/sdc)" --inputbox  "$(lsblk)" 30 60 3>&1 1>&2 2>&3)
		exitstatus=$?
		
		if [ $exitstatus = 0 ];  
			then
     			#echo "Вы выбрали :" $cfd
			    cfdisk /dev/$cfd
			else
     			echo ""
		fi
    	 echo ""
	else
     echo ""
fi
