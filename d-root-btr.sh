#!/bin/bash
loadkeys ru
setfont cyr-sun16

#------------------------------ ROOT


root=$(whiptail --title  "ROOT - Раздел" --inputbox  "Укажите раздел для системы (sda/sdb 1.2.3.4 ( например sda5 ) $(echo "" && echo "" && lsblk)" 30 80 3>&1 1>&2 2>&3)
 
exitstatus=$?
if [ $exitstatus = 0 ];  
	then
     	mkfs.btrfs -f -L arch /dev/$root
		mount /dev/$root /mnt
		mkdir /mnt/{boot,home}
     	#echo "Your pet name is:" $root
	else
     echo "You chose Cancel."
fi
