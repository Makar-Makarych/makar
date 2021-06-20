#!/bin/bash



#------------  Markup  ---------------------

if (whiptail --title  " MARKUP " --yesno "
$(lsblk)
  
   Do I need to mark up (re-mark up) your disk?" 30 60)  
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
    
  Specify the partition to install the system in (ROOT). For example: sda5" 30 60 3>&1 1>&2 2>&3)
 
exitstatus=$?
if [ $exitstatus = 0 ];  
    then
        clear
        mkfs.ext4 /dev/$root -L root
        mount /dev/$root /mnt
        mkdir /mnt/{boot,home}
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
                 mkfs.vfat -F32 /dev/$bootd
                 mkdir /mnt/boot
                 mkdir /mnt/boot/efi
                 mount /dev/$bootd /mnt/boot/efi
            else
                clear
        fi
            clear
    else
        bootd=$(whiptail --title  " BOOT " --inputbox  "
$(lsblk)
  Specify the name of the partition to mount. For example: sda5" 30 60 3>&1 1>&2 2>&3)
        exitstatus=$?
        
        if [ $exitstatus = 0 ];  
            then
                clear
                 mkdir /mnt/boot/
                 mkdir /mnt/boot/efi
                 mount /dev/$bootd /mnt/boot/efi
            else
                clear
            fi
    clear
fi

#------------------  HOME  ----------------------

if (whiptail --title " HOME " --yesno "
$(lsblk)

  Is there a section marked as HOME?" 30 60)
    then
        if (whiptail --title  " HOME " --yesno "
$(lsblk)
  
  Do I need to format the HOME partition of your disk ?" 30 60)  
            then
                homed=$(whiptail --title  " HOME " --inputbox  "
$(lsblk)
  
  Specify the name of the section to format. For example: sda5" 30 60 3>&1 1>&2 2>&3)
                exitstatus=$?
                if [ $exitstatus = 0 ];  
                    then
                        clear
                        mkfs.ext4 /dev/$homed -L home    
                        mkdir /mnt/home 
                        mount /dev/$homed /mnt/home
                    else
                        clear
                fi
                    clear
            else
                homed=$(whiptail --title  " HOME " --inputbox  "
$(lsblk)
  
  Specify the name of the partition to mount. For example: sda5" 30 60 3>&1 1>&2 2>&3)
                exitstatus=$?
                if [ $exitstatus = 0 ];  
                    then
                        clear
                        mkdir /mnt/home 
                        mount /dev/$homed /mnt/home
                    else
                        clear
                fi
                clear
        fi
            clear
    else
        clear
fi


#----------------------  SWAP   ------------------------------------------


   

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

#------------------    MIRRORS       ----------------------

if (whiptail --title  " MIRRORS " --yesno  "
  You can update the mirrors now, but it will take some time. After the update (or skipping), the installation of the base system will begin immediately.

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

#----------------  Install   

pacstrap /mnt base base-devel linux linux-firmware nano dhcpcd netctl linux-headers which inetutils wget wpa_supplicant git mc dialog

genfstab -pU /mnt >> /mnt/etc/fstab

#--------------  CHROOT 

arch-chroot /mnt sh -c "$(curl -fsSL https://raw.githubusercontent.com/Makar-Makarych/makar/main/t-efi-btr3-en.sh)"
