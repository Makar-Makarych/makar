#!/bin/bash
loadkeys ru
setfont cyr-sun16

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
mkdir -p /mnt/{home,boot,boot/efi,var,.snapshots}
mount -o compress=zstd,subvol=@var "$root" /mnt/var
mount -o compress=zstd,subvol=@home "$root" /mnt/home
mount -o compress=zstd,subvol=@snapshots "$root" /mnt/.snapshots

mount "$boot" /mnt/boot/efi

#------------------    ЗЕРКАЛО       ----------------------

if (whiptail --title  " ЗЕРКАЛА " --yesno  "
  Сейчас можно обновить зеркала на Российские. После обновления сазу начнется установка базовой системы.

        Запустить атоматический выбор Российских зеркал ? " 12 60)  
	then
		clear
    	pacman -Sy reflector --noconfirm
        reflector --verbose --country Russia -p http -p https --sort rate --save /etc/pacman.d/mirrorlist
        pacman -Sy --noconfirm
    else
		clear
    	pacman -Sy --noconfirm
fi

#-------------- Установка базы   

pacstrap /mnt base base-devel linux linux-firmware nano dhcpcd netctl linux-headers which inetutils wget wpa_supplicant git mc dialog

genfstab -U -p /mnt >> /mnt/etc/fstab

#--------------  CHROOT  в систему

arch-chroot /mnt sh -c "$(curl -fsSL https://raw.githubusercontent.com/Makar-Makarych/makar/main/t-efi-btr3.sh)"
