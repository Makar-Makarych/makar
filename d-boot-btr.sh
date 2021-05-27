#!/bin/bash
loadkeys ru
setfont cyr-sun16

#-------------------------------- BOOT

if (whiptail --title  "BOOT - РАЗДЕЛ" --yesno "НУЖНО ЛИ ФОРМАТИРОВАТЬ BOOT - РАЗДЕЛ ВАШЕГО ДИСКА ?$(echo "" && echo "" && lsblk)" 30 60)  
	then
		bootd=$(whiptail --title  "BOOT - РАЗДЕЛ" --inputbox  "УКАЖИТЕ ИМЯ РАЗДЕЛА ДЛЯ ФОРМАТИРОВАНИЯ (sda/sdb 1.2.3.4 ( например sda5 )$(echo "" && echo "" && lsblk)" 30 60 3>&1 1>&2 2>&3)
		exitstatus=$?
		
		if [ $exitstatus = 0 ];  
			then
				clear
     			mkfs.fat -F32  /dev/$bootd
                mkdir /mnt/boot
            	mkdir /mnt/boot/efi
            	mount /dev/$bootd /mnt/boot/efi

     			#echo "Вы выбрали форматировать:" $bootd
			else
     			echo ""
		fi
    	 echo ""
	else
    
		bootd=$(whiptail --title  "BOOT - РАЗДЕЛ" --inputbox  "УКАЖИТЕ ИМЯ РАЗДЕЛА ДЛЯ МОНТИРОВАНИЯ (sda/sdb 1.2.3.4   ( например sda5 )$(echo "" && echo "" && lsblk)" 30 60 3>&1 1>&2 2>&3)
		exitstatus=$?
		
		if [ $exitstatus = 0 ];  
			then
				clear
       			mkdir /mnt/boot/
            	mkdir /mnt/boot/efi
            	mount /dev/$bootd /mnt/boot/efi

     			#echo "Вы выбрали просто монтировать:" $bootd
			else
				clear
     			#echo ""
		fi
    clear
    #echo ""
fi

