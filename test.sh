#!/bin/bash
loadkeys ru
setfont cyr-sun16

DIALOG=${DIALOG=dialog}
tempfile=`tempfile 2>/dev/null` || tempfile=/tmp/test$$
trap "rm -f $tempfile" 0 1 2 5 15

#######################################################################################


# #------------------  HOME  ----------------------

# if (whiptail --title " HOME " --yesno "
# $(lsblk)

#   Имеется ли раздел, размеченный как HOME ?" 30 60)
#     then
#         if (whiptail --title  " HOME " --yesno "
# $(lsblk)
  
#   Нужно ли форматировать HOME раздел Вашего диска ?" 30 60)  
#             then
#                 homed=$(whiptail --title  " HOME " --inputbox  "
# $(lsblk)
  
#   Укажите имя раздела для форматирования. Например: sda5" 30 60 3>&1 1>&2 2>&3)
#                 exitstatus=$?
#                 if [ $exitstatus = 0 ];  
#                     then
#                         clear
#                         mkfs.ext4 /dev/$homed -L home    
#                         mkdir /mnt/home 
#                         mount /dev/$homed /mnt/home
#                     else
#                         clear
#                 fi
#                     clear
#             else
#                 homed=$(whiptail --title  " HOME " --inputbox  "
# $(lsblk)
  
#   Укажите имя раздела для монтирования. Например: sda5 )" 30 60 3>&1 1>&2 2>&3)
#                 exitstatus=$?
#                 if [ $exitstatus = 0 ];  
#                     then
#                         clear
#                         mkdir /mnt/home 
#                         mount /dev/$homed /mnt/home
#                     else
#                         clear
#                 fi
#                 clear
#         fi
#             clear
#     else
#         clear
# fi        



# #------------------   BOOT   ----------------------

# if (whiptail --title  " BOOT " --yesno "
# $(lsblk)
  
#   Нужно ли форматировать BOOT раздел Вашего диска ?" 30 60)  
#     then
#         bootd=$(whiptail --title  " BOOT " --inputbox  "
# $(lsblk)
#   Укажите имя раздела для форматирования. Например: sda5" 30 60 3>&1 1>&2 2>&3)
#         exitstatus=$?
#         if [ $exitstatus = 0 ];  
#             then
#                 clear
#                  mkfs.vfat -F32 /dev/$bootd
#                  mkdir /mnt/boot
#                  mkdir /mnt/boot/efi
#                  mount /dev/$bootd /mnt/boot/efi
#             else
#                 clear
#         fi
#             clear
#     else
#         bootd=$(whiptail --title  " BOOT " --inputbox  "
# $(lsblk)
#   Укажите имя раздела для монтирования. Например: sda5" 30 60 3>&1 1>&2 2>&3)
#         exitstatus=$?
        
#         if [ $exitstatus = 0 ];  
#             then
#                 clear
#                  mkdir /mnt/boot/
#                  mkdir /mnt/boot/efi
#                  mount /dev/$bootd /mnt/boot/efi
#             else
#                 clear
#             fi
#     clear
# fi




#-----------------------   ROOT -------------------------------------------


# root=$(whiptail --title  " ROOT " --inputbox  "
# $(lsblk)
	
#   Укажите имя раздела для установки системы ROOT. Например: sda5" 30 60 3>&1 1>&2 2>&3)
 
# exitstatus=$?
# if [ $exitstatus = 0 ];  
#     then
#         clear
#         mkfs.ext4 /dev/$root -L root
#         mount /dev/$root /mnt
#         mkdir /mnt/{boot,home}
# fi


# #--------- Разметка  -------------------------------------------

# if (whiptail --title  " РАЗМЕТКА " --yesno "
# $(lsblk)
  
#    Нужна ли разметка ( переразметка ) диска ?" 30 60)  
#     then
#         cfd=$(whiptail --title  " РАЗМЕТКА " --inputbox  "
# $(lsblk)
  
#         Укажите имя диска. Например: sda" 30 60 3>&1 1>&2 2>&3)
#         exitstatus=$?
        
#         if [ $exitstatus = 0 ];  
#             then
#                 clear
#                     cfdisk /dev/"$cfd"
#             else
#                 clear
#             fi
#         clear
#     else
#     clear   
# fi



#----------------------  Дополнит. ПО  ---------------------------------------------------------


# $DIALOG --title " ДОПОЛНИТЕЛНОЕ ПО" --clear \
#         --yesno "
#   Установить дополнительные приложения (YAY, PAMAC)?" 10 60


#-------------------------- ЧАСОВЫЕ ПОЯСА    -----------------------------------------------------


# $DIALOG --clear --title " ЧАСОВЫЕ ПОЯСА " \
#         --menu "
#   Выберите Ваш часовой пояс:" 20 51 7 \
#         "Алматы" ""\
# 	     "Владивосток" ""\
#         "Екатеринбург" ""\
#         "Ереван" "" \
#         "Запарожье" ""\
#         "Иркутск" ""\
#         "Калининград" ""\
#         "Камчатка" ""\
#         "Киев" ""\
#         "Киров" ""\
#         "Красноярск" ""\
#         "Магадан" ""\
#         "Минск" ""\
#         "Москва" ""\
#         "Новокузнецк" ""\
#         "Новосибирск" ""\
#         "Омск" ""\
#         "Самара" ""\
#         "Саратов" ""\
#         "Среднеколымск" ""\
#         "Стамбул" ""\
#         "Ташкент" ""\
#         "Тбилиси" ""\
#         "Томск" ""\
#         "Ульяновск" ""\
#         "Уральск" ""\
#         "Чита" ""\
#         "Якутск" "" 2> $tempfile
 
# retval=$?


#---------------------------  УСТАНОВКА ГРАФИЧЕСКОГО ОКРУЖЕНИЯ   --------


# $DIALOG --clear --title " УСТАНОВКА ГРАФИЧЕСКОГО ОКРУЖЕНИЯ " \
#         --menu "
#   Выберите из списка : " 15 60 7 \
#         "KDE" ""\
#         "XFCE" ""\
#         "GNOME" "" \
#         "LXDE" ""\
#         "DEEPIN" ""\
#         "MATE" ""\
#         "LXQT" "" 2> $tempfile
 
# retval=$?


#----------------------  SWAP   ------------------------------------------


   

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
#      			mkswap /dev/"$swaps" -L swap
#      			swapon /dev/"$swaps"
#      		else
# 				clear
#      	fi
#     		clear
#     else
#     	clear
# fi



# #------------------    ЗЕРКАЛО       ----------------------

# if (whiptail --title  " ЗЕРКАЛА " --yesno  "
#   Сейчас можно обновить зеркала, но это займет каое-то время. После обновления (или пропуска) сразу же начнется установка базовой системы.

#         Запустить атоматический выбор зеркал ? " 12 60)  
# 	then
# 		clear
#     	pacman -Sy reflector --noconfirm
#         reflector --verbose -a1 -f10 -l70 -p https -p http --sort rate --save /etc/pacman.d/mirrorlist
#         pacman -Sy --noconfirm
#     else
# 		clear
#     	pacman -Sy --noconfirm
# fi


# #------------------    ЗЕРКАЛО  2     ----------------------

# if (whiptail --title  " ЗЕРКАЛА " --yesno  "
#   Сейчас можно обновить зеркала во вновь установленной системе, но это займет каое-то время.

#         Запустить атоматический выбор зеркал ? " 12 60)  
#  then
#     clear
#        pacman -Sy reflector --noconfirm
#         reflector --verbose -a1 -f10 -l70 -p https -p http --sort rate --save /etc/pacman.d/mirrorlist
#         pacman -Sy --noconfirm
#     else
#     clear
#        pacman -Sy --noconfirm
# fi


#-------------------------------------------------------------------------------------------------

# $DIALOG --clear --title "  ЧАСОВЫЕ ПОЯСА  " \
#         --menu "
#   Выберите Ваш часовой пояс: " 20 51 7 \
#         "Алматы" ""\
# 	     "Владивосток" ""\
#         "Екатеринбург" ""\
#         "Ереван" "" \
#         "Запарожье" ""\
#         "Иркутск" ""\
#         "Калининград" ""\
#         "Камчатка" ""\
#         "Киев" ""\
#         "Киров" ""\
#         "Красноярск" ""\
#         "Магадан" ""\
#         "Минск" ""\
#         "Москва" ""\
#         "Новокузнецк" ""\
#         "Новосибирск" ""\
#         "Омск" ""\
#         "Самара" ""\
#         "Саратов" ""\
#         "Среднеколымск" ""\
#         "Стамбул" ""\
#         "Ташкент" ""\
#         "Тбилиси" ""\
#         "Томск" ""\
#         "Ульяновск" ""\
#         "Уральск" ""\
#         "Чита" ""\
#         "Якутск" "" 2> $tempfile
 
# retval=$?
 



















