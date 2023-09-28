#!/bin/bash
loadkeys ru
###setfont cyr-sun16
setfont ter-v32b

clear

#------------  Разметка  new  ---------------------

if (whiptail --title  " РАЗМЕТКА " --yesno "
$(lsblk)

  Нужна ли разметка или переразметка Вашего диска ?" 0 0)  
    then
		    cfds=$(lsblk -d -p -n -l -o NAME -e 7,11)       
		    options=()
		    for cfd in ${cfds}; do
		        options+=("${cfd}" "")
		    done
		    cfddev=$(whiptail --title "Выберите диск" --menu "" 0 0 0 \
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
#mkfs -t vfat -n BOOT "$boot"
mkfs.ext2 /dev/$bootd -L BOOT
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
                swapon "$swap"
            
fi

#------------------    СУБВОЛУМЫ       ----------------------

mount "$root" /mnt

btrfs subvolume create /mnt/@
btrfs subvolume create /mnt/@home
btrfs subvolume create /mnt/@snapshots
btrfs subvolume create /mnt/@var

umount -R /mnt

mount -o compress=zstd,subvol=@ "$root" /mnt
mkdir -p /mnt/{home,boot,var,.snapshots}
mount -o compress=zstd,subvol=@var "$root" /mnt/var
mount -o compress=zstd,subvol=@home "$root" /mnt/home
mount -o compress=zstd,subvol=@snapshots "$root" /mnt/.snapshots

mount "$boot" /mnt/boot

#------------------    ЗЕРКАЛО       ----------------------

if (whiptail --title  " ЗЕРКАЛА " --yesno  "
  Сейчас можно обновить зеркала . После обновления сазу начнется установка базовой системы.

        Запустить атоматический выбор  зеркал ? " 12 60)  
	then
		clear
    	pacman -Sy reflector --noconfirm
        reflector -c ru,by,pl,de -p https,http --sort rate -a 12 -l 10 --save /etc/pacman.d/mirrorlist
	pacman -Sy --noconfirm
    else
		clear
    	pacman -Sy --noconfirm
fi

#-------------- Pacman.conf

#echo "Color" >> /etc/pacman.conf
#echo "VerbosePkgLists" >> /etc/pacman.conf
#echo "IloveCandy" >> /etc/pacman.conf
#echo "ParallelDownloads = 5" >> /etc/pacman.conf
sed -i 's/#Color/Color/' /etc/pacman.conf
sed -i 's/#VerbosePkgLists/VerbosePkgLists/' /etc/pacman.conf
sed -i 's/#ParallelDownloads = 5/ParallelDownloads = 5/' /etc/pacman.conf
######################  Установка базы      ################################### 

pacstrap /mnt base base-devel linux linux-firmware nano dhcpcd netctl linux-headers which inetutils wget wpa_supplicant git mc dialog

genfstab -pU /mnt >> /mnt/etc/fstab

#--------------  CHROOT  в систему

arch-chroot /mnt sh -c "$(curl -fsSL https://raw.githubusercontent.com/Makar-Makarych/makar/main/mbr-user.sh)"
