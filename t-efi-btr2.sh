#!/bin/bash
loadkeys ru
setfont cyr-sun16
clear
#------------  Разметка   ---------------------

if (whiptail --title  " РАЗМЕТКА " --yesno "
$(lsblk)

  Нужна ли разметка (переразметка) Вашего диска ?" 30 60)  
	then
		cfd=$(whiptail --title  " РАЗМЕТКА " --inputbox  "
$(lsblk)

  Укажите имя Вашего диска для разметки. Например: sda" 30 60 3>&1 1>&2 2>&3)
		exitstatus=$?
		
		if [ $exitstatus = 0 ];  
			then
     			clear
     				cfdisk /dev/"$cfd"
			else
     			clear
     		fi
		clear
   	else
	clear	
fi

#------------------  ROOT   ----------------------

root=$(whiptail --title  " ROOT " --inputbox  "
$(lsblk)
  
  Укажите раздел для установки системы. Например: sda5"  30 60 3>&1 1>&2 2>&3)
 
exitstatus=$?
if [ $exitstatus = 0 ];  
	then
     	clear
     	mkfs.btrfs -f -L arch /dev/"$root"
fi

#------------------   BOOT   ----------------------

if (whiptail --title  " BOOT " --yesno "
$(lsblk)
  
  Нужно ли форматировать BOOT раздел Вашего диска ?" 30 60)  
	then
		bootd=$(whiptail --title  " BOOT " --inputbox  "
$(lsblk)

  Укажите имя раздела для форматирования. Например: sda5" 30 60 3>&1 1>&2 2>&3)
		exitstatus=$?
		
		if [ $exitstatus = 0 ];  
			then
				clear
     			 mkfs.fat -F32 /dev/"$bootd"
                 mkdir /mnt/boot
             	mkdir /mnt/boot/efi
            else
     			clear
		fi
    	    clear
	else
    
		bootd=$(whiptail --title  " BOOT " --inputbox  "
$(lsblk)

  Укажите имя раздела для монтирования. Например: sda5" 30 60 3>&1 1>&2 2>&3)
		exitstatus=$?
		
		if [ $exitstatus = 0 ];  
			then
				clear
       			mkdir /mnt/boot/
             	mkdir /mnt/boot/efi
            else
				clear
     		fi
    clear
fi

#------------------    SWAP       ----------------------

if (whiptail --title  " SWAP " --yesno  "
     Подключить SWAP раздел ?" 10 40)  
	then
    	
		swaps=$(whiptail --title  " SWAP " --inputbox  "
$(lsblk)
			
  Укажите имя для SWAP раздела. Например: sda5" 30 60 3>&1 1>&2 2>&3)
 		exitstatus=$?
		if [ $exitstatus = 0 ];  
			then
				clear
     			mkswap /dev/"$swaps" -L swap
     			swapon /dev/"$swaps"
     		else
				clear
     	fi
    		clear
    else
    	clear
fi

#------------------    СУБВОЛУМЫ       ----------------------
clear
mount /dev/$root /mnt

btrfs subvolume create /mnt/@
btrfs subvolume create /mnt/@home
btrfs subvolume create /mnt/@snapshots
btrfs subvolume create /mnt/@cache

umount -R /mnt


mount -o noatime,compress=lzo,space_cache,subvol=@ /dev/"$root" /mnt
mkdir -p /mnt/{home,boot,boot/efi,var,var/cache,.snapshots}
mount -o noatime,compress=lzo,space_cache,subvol=@cache /dev/"$root" /mnt/var/cache
mount -o noatime,compress=lzo,space_cache,subvol=@home /dev/"$root" /mnt/home
mount -o noatime,compress=lzo,space_cache,subvol=@snapshots /dev/"$root" /mnt/.snapshots

mount /dev/"$bootd" /mnt/boot/efi


#------------------    ЗЕРКАЛО       ----------------------

if (whiptail --title  " ЗЕРКАЛА " --yesno  "
  Сейчас можно обновить зеркала, но это займет каое-то время. После обновления (или пропуска) сразу же начнется установка базовой системы.

        Запустить атоматический выбор зеркал ? " 12 60)  
	then
		clear
    	pacman -Sy reflector --noconfirm
        reflector --verbose --country 'Russia' -p http -p https --sort rate --save /etc/pacman.d/mirrorlist
        #reflector --verbose -a1 -f10 -l70 -p https -p http --sort rate --save /etc/pacman.d/mirrorlist
        pacman -Sy --noconfirm
    else
		clear
    	pacman -Sy --noconfirm
fi

#-------------- Установка базы   

pacstrap /mnt base base-devel linux linux-firmware nano dhcpcd netctl linux-headers which inetutils wget wpa_supplicant git mc dialog

genfstab -pU /mnt >> /mnt/etc/fstab

#--------------  CHROOT  в систему

arch-chroot /mnt sh -c "$(curl -fsSL https://raw.githubusercontent.com/Makar-Makarych/makar/main/t-efi-btr3.sh)"
