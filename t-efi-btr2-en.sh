#!/bin/bash
loadkeys us
setfont ter-v32b
echo "Color" >> /etc/pacman.conf
echo "VerbosePkgLists" >> /etc/pacman.conf
echo "IloveCandy" >> /etc/pacman.conf
echo "ParallelDownloads = 5" >> /etc/pacman.conf
clear
#------------  Markup  ---------------------

if (whiptail --title  " MARKUP " --yesno "
$(lsblk)

  Do I need to mark up or re-mark up your disk?" 0 0)  
    then
		    cfds=$(lsblk -d -p -n -l -o NAME -e 7,11)       
		    options=()
		    for cfd in ${cfds}; do
		        options+=("${cfd}" "")
		    done
		    cfddev=$(whiptail --title "Specify the disk" --menu "" 0 0 0 \
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

#------------------  ROOT   ----------------------

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
                mkfs.btrfs -f -L ROOT "$root"

#------------------   BOOT  new ----------------------

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
mkfs -t vfat -n BOOT "$boot"
 #mkfs.fat -F32 "$boot"
mkdir /mnt/boot
mkdir /mnt/boot/efi

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
mkdir /mnt/boot
mkdir /mnt/boot/efi  
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


#------------------    SUBVOLUMS       ----------------------
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

if (whiptail --title  " MIRRORS " --yesno  "
  You can update the mirrors now, but it will take some time. After the update, the installation of the base system will begin immediately.

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

#-------------- Install & Chroot  

pacstrap /mnt base base-devel linux linux-firmware nano dhcpcd netctl linux-headers which inetutils wget wpa_supplicant git mc dialog

genfstab -pU /mnt >> /mnt/etc/fstab

arch-chroot /mnt sh -c "$(curl -fsSL https://raw.githubusercontent.com/Makar-Makarych/makar/main/t-efi-btr3-en.sh)"
