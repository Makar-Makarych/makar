#!/bin/bash
loadkeys ru
setfont cyr-sun16

# #------  SWAP   

# if (whiptail --title  " SWAP " --yesno  "
#      Подключить SWAP раздел ?" 10 40)  
# 	then
    	
# 		swaps=$(whiptail --title  " SWAP " --inputbox  "
# $(lsblk)
			
#   Укажите имя для SWAP раздела. Например: sda5" 30 60 3>&1 1>&2 2>&3)
#  		exitstatus=$?
# 		if [ $exitstatus = 0 ];  
# 			then
# 				clear
#      			# mkswap /dev/"$swaps" -L swap
#      			# swapon /dev/"$swaps"
#      		else
# 				clear
#      	fi
#     		clear
#     else
#     	clear
# fi



#------------------    ЗЕРКАЛО       ----------------------

if (whiptail --title  " ЗЕРКАЛА " --yesno  "
  Сейчас можно обновить зеркала, но это займет каое-то время. После обновления (или пропуска) сразу же начнется установка базовой системы.

        Запустить атоматический выбор зеркал ? " 12 60)  
	then
		clear
    	pacman -S reflector --noconfirm
        reflector --verbose --country 'Russia' -p https --sort rate --save /etc/pacman.d/mirrorlist
        #reflector -a 12 -l 15 -p https,http --sort rate --save /etc/pacman.d/mirrorlist --verbose
    	pacman -Sy --noconfirm
    else
		clear
    	pacman -Sy --noconfirm
fi







