#!/bin/bash
loadkeys ru
setfont cyr-sun16

if (whiptail --title  "SWAP - РАЗДЕЛ" --yesno  "Подключить SWAP раздел ?" 10 60)  
	then
    	
		swaps=$(whiptail --title  "SWAP - РАЗДЕЛ" --inputbox  "УКАЖИТЕ ИМЯ РАЗДЕЛА ДЛЯ SWAP (sda/sdb 1.2.3.4 ( например sda5 )$(echo "" && echo "" && lsblk)" 30 60 3>&1 1>&2 2>&3)
 		exitstatus=$?
		if [ $exitstatus = 0 ];  
			then
     				#mkswap /dev/$swaps -L swap
     			    #swapon /dev/$swaps
     			echo "Подключен  свап:" $swaps
			else
     			echo ""
		fi
    	echo ""
	else
    	echo "Фигвам"
fi
