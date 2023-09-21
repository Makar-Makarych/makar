#!/bin/bash
setfont ter-v32b
#------------  Markup  new  ---------------------

if (whiptail --title  " MARKUP " --yesno "
$(lsblk)

  Do I need to mark up or re-mark up your disk?" 0 0)  
    then
            cfds=$(lsblk -d -p -n -l -o NAME -e 7,11)       
            options=()
            for cfd in ${cfds}; do
                options+=("${cfd}" "")
            done
            cfddev=$(whiptail --title "pecify the disk" --menu "" 0 0 0 \
                "none" "-" \
                "${options[@]}" \
                3>&1 1>&2 2>&3)
            
            if ! make mytarget; then
                echo ""
            else
                if [ "${cfddev}" = "none" ]; then
                    cfddev=
                fi
            fi
                cfdisk "$cfddev"
    else
    clear   
fi

#-----------   ROOT new

chds=$(lsblk -p -n -l -o NAME -e 7,11)       
            options=()
            for chd in ${chds}; do
                options+=("${chd}" "")
            done
            root=$(whiptail --title " ROOT " --menu "Specify the partition to install the system in ROOT" 0 0 0 \
                "none" "-" \
                "${options[@]}" \
                3>&1 1>&2 2>&3)
            if ! make mytarget; then
                echo ""
            else
                if [ "${root}" = "none" ]; then
                    root=
                fi
            fi
                mkfs.ext4 /dev/$root -L root
                mount /dev/$root /mnt
                mkdir /mnt/{boot,home}

#------------------   BOOT  ----------------------

if (whiptail --title  " BOOT " --yesno "

  Do I need to format the BOOT partition of your disk ?" 0 0)  
    then
        
            chds=$(lsblk -p -n -l -o NAME -e 7,11)       
            options=()
            for chd in ${chds}; do
                options+=("${chd}" "")
            done
            boot=$(whiptail --title " ROOT " --menu "Specify the name of the section to format" 0 0 0 \
                "none" "-" \
                "${options[@]}" \
                3>&1 1>&2 2>&3)
            if ! make mytarget; then
                echo ""
            else
                if [ "${boot}" = "none" ]; then
                    boot=
                fi
            fi
            clear
                 mkfs.vfat -F32 /dev/$boot
                 mkdir /mnt/boot
                 mkdir /mnt/boot/efi
                 mount /dev/$boot /mnt/boot/efi

    else
 
 chds=$(lsblk -p -n -l -o NAME -e 7,11)       
            options=()
            for chd in ${chds}; do
                options+=("${chd}" "")
            done
            boot=$(whiptail --title " ROOT " --menu "Specify the name of the partition to mount BOOT" 0 0 0 \
                "none" "-" \
                "${options[@]}" \
                3>&1 1>&2 2>&3)
            if ! make mytarget; then
                echo ""
            else
                if [ "${boot}" = "none" ]; then
                    boot=
                fi
            fi

            clear
                 mkdir /mnt/boot/
                 mkdir /mnt/boot/efi
                 mount /dev/$boot /mnt/boot/efi
fi

#------------------   HOME  ----------------------

if (whiptail --title  " HOME " --yesno "

  Do I need to format the HOME partition of your disk ?" 0 0)  
    then
        
            chds=$(lsblk -p -n -l -o NAME -e 7,11)       
            options=()
            for chd in ${chds}; do
                options+=("${chd}" "")
            done
            home=$(whiptail --title " HOME " --menu "Specify the name of the section to format" 0 0 0 \
                "none" "-" \
                "${options[@]}" \
                3>&1 1>&2 2>&3)
            if ! make mytarget; then
                echo ""
            else
                if [ "${home}" = "none" ]; then
                    home=
                fi
            fi

            clear
                mkfs.ext4 /dev/$home -L home    
                mkdir /mnt/home 
                mount /dev/$home /mnt/home
    else
 
 chds=$(lsblk -p -n -l -o NAME -e 7,11)       
            options=()
            for chd in ${chds}; do
                options+=("${chd}" "")
            done
            home=$(whiptail --title " ROOT " --menu "Specify the name of the partition to mount" 0 0 0 \
                           "none" "-" \
                "${options[@]}" \
                3>&1 1>&2 2>&3)
            if ! make mytarget; then
                echo ""
            else
                if [ "${home}" = "none" ]; then
                    home=
                fi
            fi
            clear
                mkdir /mnt/home 
                mount /dev/$home /mnt/home
fi

#------------------    SWAP   new    ----------------------

if (whiptail --title  " SWAP " --yesno  "
     Connect a SWAP partition ?" 10 40)  
    then

chds=$(lsblk -p -n -l -o NAME -e 7,11)       
            options=()
            for chd in ${chds}; do
                options+=("${chd}" "")
            done
            swap=$(whiptail --title " SWAP " --menu "Specify a name for the SWAP partition" 0 0 0 \
                "none" "-" \
                "${options[@]}" \
                3>&1 1>&2 2>&3)
            if ! make mytarget; then
                echo ""
            else
                if [ "${swap}" = "none" ]; then
                    swap=
                fi
            fi
                mkswap "$swap" -L SWAP
                swapon "$swap"
fi


#------------------    MIRRORS       ----------------------

if (whiptail --title  " MIRRORS " --yesno  "
  You can update the mirrors now, but it will take some time. After the update (or skipping), the installation of the base system will begin immediately.

        Run the atomic mirror selection ?" 12 60)  
  then
        clear
        pacman -Sy reflector --noconfirm
        reflector --verbose -l 20 -p https --sort rate --save /etc/pacman.d/mirrorlist
        #reflector --verbose -a1 -f10 -l70 -p https -p http --sort rate --save /etc/pacman.d/mirrorlist
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
