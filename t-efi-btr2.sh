#!/bin/bash
loadkeys ru
setfont cyr-sun16

#------------  Разметка   ---------------------

if (whiptail --title  "НУЖНА ЛИ РАЗМЕТКА (переразметка) ВАШЕГО ДИСКА ?" --yesno "$(lsblk)" 30 60)  
	then
		cfd=$(whiptail --title  "УКАЖИТЕ ИМЯ ДИСКА (sda/sdb/sdc)" --inputbox  "$(lsblk)" 30 60 3>&1 1>&2 2>&3)
		exitstatus=$?
		
		if [ $exitstatus = 0 ];  
			then
     			clear
     				cfdisk /dev/$cfd
			else
     			clear
     		fi
		clear
    	#echo ""
	else
	clear	
    #echo ""
fi

#------------------  ROOT   ----------------------

root=$(whiptail --title  "ROOT - Раздел" --inputbox  "Укажите системный раздел ROOT ( / ) (sda/sdb 1.2.3.4 ( например sda5 ) $(echo "" && echo "" && lsblk)" 30 80 3>&1 1>&2 2>&3)
 
exitstatus=$?
if [ $exitstatus = 0 ];  
	then
     	mkfs.btrfs -f -L arch /dev/$root
		#mount /dev/$root /mnt
		#mkdir /mnt/{boot,home}
     	#echo "Your pet name is:" $root
	else
    clear
    #echo "You chose Cancel."
fi

#------------------   BOOT   ----------------------

if (whiptail --title  "BOOT - РАЗДЕЛ" --yesno "НУЖНО ЛИ ФОРМАТИРОВАТЬ BOOT - РАЗДЕЛ ВАШЕГО ДИСКА ?$(echo "" && echo "" && lsblk)" 30 60)  
	then
		bootd=$(whiptail --title  "BOOT - РАЗДЕЛ" --inputbox  "УКАЖИТЕ ИМЯ РАЗДЕЛА ДЛЯ ФОРМАТИРОВАНИЯ (sda/sdb 1.2.3.4 ( например sda5 )$(echo "" && echo "" && lsblk)" 30 60 3>&1 1>&2 2>&3)
		exitstatus=$?
		
		if [ $exitstatus = 0 ];  
			then
				clear
     			mkfs.fat -F32 /dev/$bootd
                mkdir /mnt/boot
            	mkdir /mnt/boot/efi
            	#mount /dev/$bootd /mnt/boot/efi

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
            	#mount /dev/$bootd /mnt/boot/efi

     			#echo "Вы выбрали просто монтировать:" $bootd
			else
				clear
     			#echo ""
		fi
    clear
    #echo ""
fi

#------------------    SWAP       ----------------------

if (whiptail --title  "SWAP - РАЗДЕЛ" --yesno  "Подключить SWAP раздел ?" 10 60)  
	then
    	
		swaps=$(whiptail --title  "SWAP - РАЗДЕЛ" --inputbox  "УКАЖИТЕ ИМЯ РАЗДЕЛА ДЛЯ SWAP (sda/sdb 1.2.3.4 ( например sda5 )$(echo "" && echo "" && lsblk)" 30 60 3>&1 1>&2 2>&3)
 		exitstatus=$?
		if [ $exitstatus = 0 ];  
			then
				clear
     			mkswap /dev/$swaps -L swap
     			swapon /dev/$swaps
     			#echo "Подключен  свап:" $swaps
			else
				clear
     			#echo ""
		fi
    	clear
    	#echo ""
	else
    	clear
    	#echo ""
fi

#------------------    СУБВОЛУМЫ       ----------------------

mount /dev/$root /mnt
btrfs subvolume create /mnt/arch_root
btrfs subvolume create /mnt/arch_home
btrfs subvolume create /mnt/arch_snapshots
btrfs subvolume create /mnt/arch_cache

umount -R /mnt


mount -o noatime,compress=lzo,space_cache,subvol=arch_root /dev/"$root" /mnt
mkdir -p /mnt/{home,boot,boot/efi,var,var/cache,.snapshots}
mount -o noatime,compress=lzo,space_cache,subvol=arch_cache /dev/"$root" /mnt/var/cache
mount -o noatime,compress=lzo,space_cache,subvol=arch_home /dev/"$root" /mnt/home
mount -o noatime,compress=lzo,space_cache,subvol=arch_snapshots /dev/"$root" /mnt/.snapshots
mount "$boot" /mnt/boot/efi



# mount -o noatime,compress=lzo,space_cache,subvol=arch_root /dev/$root /mnt

# mkdir -p /mnt/{home,boot,boot/efi,var,var/cache,.snapshots}

# mount -o noatime,compress=lzo,space_cache,subvol=arch_cache /dev/$root /mnt/var/cache
# mount -o noatime,compress=lzo,space_cache,subvol=arch_home /dev/$root /mnt/home
# mount -o noatime,compress=lzo,space_cache,subvol=arch_snapshots /dev/$root /mnt/.snapshots




mount /dev/$bootd /mnt/boot/efi


#------------------    ЗЕРКАЛО       ----------------------

if (whiptail --title  "ЗЕРКАЛА" --yesno  "Сейчас можно автоматически выбрать 15 самых быстрых зеркал из ближайших для вашего местоположения, но это займет каое-то время. После обновления (или пропуска) сразу же начнется установка базовой системы. Запустить атоматический выбор зеркал ? " 10 60)  
	then
		clear
    	pacman -S reflector --noconfirm
        reflector -a 12 -l 15 -p https,http --sort rate --save /etc/pacman.d/mirrorlist --verbose
    	pacman -Sy --noconfirm
    	#echo "Зеркала выбраны $?."
	else
		clear
    	pacman -Sy --noconfirm
    	#echo "Пропущена. Exit status was $?."
fi

########################################################################################################

# # sh dialog-razmetka.sh  #-----------  Разметка
#  sh -c "$(curl -fsSL https://raw.githubusercontent.com/Makar-Makarych/makar/main/dialog-razmetka.sh)"

# # sh d-root-btr.sh       #-----------  Рут раздел . Формат и монтирование
#  sh -c "$(curl -fsSL https://raw.githubusercontent.com/Makar-Makarych/makar/main/d-root-btr.sh)"


# # sh d-boot-btr.sh       #----------- Загрузочный  раздел . Формат и монтирование
#  sh -c "$(curl -fsSL https://raw.githubusercontent.com/Makar-Makarych/makar/main/d-boot-btr.sh)"


# # sh d-swap.sh           #----------- Своп . Создание и подключение
#  sh -c "$(curl -fsSL https://raw.githubusercontent.com/Makar-Makarych/makar/main/d-swap.sh)"


#  	mount /dev/$root /mnt      #------------   Монтируем корень

# # sh podtom-btr.sh           #-----------  Создаем субволумы
#  sh -c "$(curl -fsSL https://raw.githubusercontent.com/Makar-Makarych/makar/main/podtom-btr.sh)"


# # sh zerkalo.sh          #-----------  Обновляем зеркала
#  sh -c "$(curl -fsSL https://raw.githubusercontent.com/Makar-Makarych/makar/main/zerkalo.sh)"



######################  Установка базы      ################################### 

pacstrap /mnt base #base-devel linux linux-firmware nano dhcpcd netctl linux-headers which inetutils wget wpa_supplicant dialog

genfstab -pU /mnt >> /mnt/etc/fstab



#############################################################
# arch-chroot /mnt sh -c "$(curl -fsSL git.io/arch2.sh)" # Продолжение установки по скрипту Бойко
##############################################################

#arch-chroot /mnt sh -c "$(curl -fsSL https://raw.githubusercontent.com/Makar-Makarych/makar/main/t-efi-btr3.sh)"

# Файл uefi_btrfs_chroot

# sh t-efi-btr3.sh
