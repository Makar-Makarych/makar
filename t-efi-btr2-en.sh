#!/bin/bash
loadkeys us

clear
#------------  Markup  ---------------------

if (whiptail --title  " MARKUP " --yesno "
$(lsblk)

  Do I need to mark up or re-mark up your disk?" 30 60)  
	then
		cfd=$(whiptail --title  " MARKUP " --inputbox  "
$(lsblk)

  Specify the name of your disk to mark up. For example: sda" 30 60 3>&1 1>&2 2>&3)
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
  
  Specify the partition to install the system in ROOT. For example: sda5" 30 60 3>&1 1>&2 2>&3)
 
exitstatus=$?
if [ $exitstatus = 0 ];  
	then
     	clear
     	mkfs.btrfs -f -L arch /dev/"$root"
fi

#------------------   BOOT   ----------------------

if (whiptail --title  " BOOT " --yesno "
$(lsblk)
  
  Do I need to format the BOOT partition of your disk ?" 30 60)  
	then
		bootd=$(whiptail --title  " BOOT " --inputbox  "
$(lsblk)

  Specify the name of the section to format. For example: sda5" 30 60 3>&1 1>&2 2>&3)
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

  Specify the name of the partition to mount BOOT. For example: sda5" 30 60 3>&1 1>&2 2>&3)
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
     Connect a SWAP partition ?" 10 40)  
	then
    	
		swaps=$(whiptail --title  " SWAP " --inputbox  "
$(lsblk)
			
  Specify a name for the SWAP partition. For example: sda5" 30 60 3>&1 1>&2 2>&3)
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

#------------------    SUBVOLUMS       ----------------------
clear
mount /dev/"$root" /mnt

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

if (whiptail --title  " MIRRORS " --yesno  "
  You can update the mirrors now, but it will take some time. After the update, the installation of the base system will begin immediately.

        Run the atomic mirror selection ?" 12 60)  
	then
		clear
    	pacman -Sy reflector --noconfirm
        reflector --verbose -a1 -f10 -l70 -p https -p http --sort rate --save /etc/pacman.d/mirrorlist
        pacman -Sy --noconfirm
    else
		clear
    	pacman -Sy --noconfirm
fi

#-------------- Install & Chroot  

pacstrap /mnt base base-devel linux linux-firmware nano dhcpcd netctl linux-headers which inetutils wget wpa_supplicant git mc dialog

genfstab -pU /mnt >> /mnt/etc/fstab

arch-chroot /mnt sh -c "$(curl -fsSL https://raw.githubusercontent.com/Makar-Makarych/makar/main/t-efi-btr3-en.sh)"
