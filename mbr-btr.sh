#!/bin/bash
loadkeys ru
setfont cyr-sun16

# Разметка  -------------------------------------------

if (whiptail --title  " РАЗМЕТКА " --yesno "
$(lsblk)
  
   Нужна ли разметка ( переразметка ) диска ?" 30 60)  
    then
        cfd=$(whiptail --title  " РАЗМЕТКА " --inputbox  "
$(lsblk)
  
        Укажите имя диска. Например: sda" 30 60 3>&1 1>&2 2>&3)
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


#-----------  Выбрать раздел ROOT new

chds=$(lsblk -p -n -l -o NAME -e 7,11)       
            options=()
            for chd in ${chds}; do
                options+=("${chd}" "")
            done
            root=$(whiptail --title " ROOT " --menu "Выберите раздел для ROOT" 0 0 0 \
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

  Нужно ли форматировать BOOT раздел Вашего диска ?" 0 0)  
    then
        
            chds=$(lsblk -p -n -l -o NAME -e 7,11)       
            options=()
            for chd in ${chds}; do
                options+=("${chd}" "")
            done
            boot=$(whiptail --title " BOOT " --menu "Выберите раздел для форматирования BOOT" 0 0 0 \
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

    else
 
 chds=$(lsblk -p -n -l -o NAME -e 7,11)       
            options=()
            for chd in ${chds}; do
                options+=("${chd}" "")
            done
            boot=$(whiptail --title " BOOT " --menu "Выберите раздел для монтирования BOOT" 0 0 0 \
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

fi

#  раздел HOME создается как субволум

##------------------   HOME  new ----------------------
#
#if (whiptail --title  " HOME " --yesno "
#
#  Нужно ли форматировать HOME раздел Вашего диска ?" 0 0)  
#    then
#        
#            homed=$(lsblk -p -n -l -o NAME -e 7,11)       
#            options=()
#            for chd in ${homed}; do
#                options+=("${chd}" "")
#            done
#            home=$(whiptail --title " HOME " --menu "Выберите раздел для форматирования HOME" 0 0 0 \
#                "none" "-" \
#                "${options[@]}" \
#                3>&1 1>&2 2>&3)
#            if ! make mytarget; then
#                echo ""
#            else
#                if [ "${home}" = "none" ]; then
#                    home=
#                fi
#            fi
#clear
#               mkfs.btrfs -f -L HOME "$home"
#
#
#    else
# 
# homed=$(lsblk -p -n -l -o NAME -e 7,11)       
#            options=()
#            for chd in ${homed}; do
#                options+=("${chd}" "")
#            done
#            home=$(whiptail --title " HOME " --menu "Выберите раздел для монтирования HOME" 0 0 0 \
#                "none" "-" \
#                "${options[@]}" \
#                3>&1 1>&2 2>&3)
#            if ! make mytarget; then
#                echo ""
#            else
#                if [ "${home}" = "none" ]; then
#                    home=
#                fi
#            fi
#clear
#   
#fi


#------------------    SWAP   new    ----------------------


if (whiptail --title  " SWAP " --yesno  "
     Подключить SWAP раздел ?" 10 40)  
    then

chds=$(lsblk -p -n -l -o NAME -e 7,11)       
            options=()
            for chd in ${chds}; do
                options+=("${chd}" "")
            done
            swap=$(whiptail --title " SWAP " --menu "Выберите раздел для монтирования SWAP" 0 0 0 \
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
              #-#  swapon "$swap"
            
fi


   



#------------------    СУБВОЛУМЫ       ----------------------
clear

mount "$root" /mnt

btrfs subvolume create /mnt/@
btrfs subvolume create /mnt/@home
btrfs subvolume create /mnt/@snapshots
btrfs subvolume create /mnt/@cache

umount -R /mnt

mount -o noatime,compress=lzo,subvol=@ "$root" /mnt
mkdir -p /mnt/{home,boot,boot/efi,var,var/cache,.snapshots}
mount -o noatime,compress=lzo,subvol=@cache "$root" /mnt/var/cache
mount -o noatime,compress=lzo,=@home "$root" /mnt/home
mount -o noatime,compress=lzo,subvol=@snapshots "$root" /mnt/.snapshots

mount "$boot" /mnt/boot/efi
swapon "$swap"

#------------------    ЗЕРКАЛО       ----------------------

if (whiptail --title  " ЗЕРКАЛА " --yesno  "
  Сейчас можно обновить зеркала на Российские. После обновления сазу начнется установка базовой системы.

        Запустить атоматический выбор Российских зеркал ? " 12 60)  
	then
		clear
    	pacman -Sy reflector --noconfirm
        reflector --verbose --country Russia -p http -p https --sort rate --save /etc/pacman.d/mirrorlist
        #reflector --verbose -a1 -f10 -l70 -p https -p http --sort rate --save /etc/pacman.d/mirrorlist
        pacman -Sy --noconfirm
    else
		clear
    	pacman -Sy --noconfirm
fi

######################  Установка базы      ################################### 

pacstrap /mnt base base-devel linux linux-firmware nano dhcpcd netctl linux-headers which inetutils wget wpa_supplicant git mc dialog

genfstab -pU /mnt >> /mnt/etc/fstab

arch-chroot /mnt sh -c "$(curl -fsSL https://raw.githubusercontent.com/Makar-Makarych/makar/main/mbr-user.sh)"
