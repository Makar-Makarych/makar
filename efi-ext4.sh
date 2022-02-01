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
                mkfs.ext4 "$root" -L ROOT
                mount "$root" /mnt
                mkdir /mnt/{boot,home}

#------------------   BOOT - EFI ----------------------

if (whiptail --title  " BOOT-EFI " --yesno "

  Нужно ли форматировать BOOT-EFI раздел Вашего диска ?" 0 0)  
    then
        
            chds=$(lsblk -p -n -l -o NAME -e 7,11)       
            options=()
            for chd in ${chds}; do
                options+=("${chd}" "")
            done
            boot=$(whiptail --title " BOOT-EFI " --menu "Выберите раздел для форматирования BOOT-EFI" 0 0 0 \
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
                 mkdir /mnt/boot/efi
                 mount "$boot" /mnt/boot/efi

    else
 
 chds=$(lsblk -p -n -l -o NAME -e 7,11)       
            options=()
            for chd in ${chds}; do
                options+=("${chd}" "")
            done
            boot=$(whiptail --title " BOOT-EFI " --menu "Выберите раздел для монтирования BOOT-EFI" 0 0 0 \
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
                 mkdir /mnt/boot/efi
                 mount "$boot" /mnt/boot/efi
fi

#------------------   HOME  new ----------------------

if (whiptail --title  " HOME " --yesno "

  Нужно ли форматировать HOME раздел Вашего диска ?" 0 0)  
    then
        
            homed=$(lsblk -p -n -l -o NAME -e 7,11)       
            options=()
            for chd in ${homed}; do
                options+=("${chd}" "")
            done
            home=$(whiptail --title " HOME " --menu "Выберите раздел для форматирования HOME" 0 0 0 \
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
                        mkfs.ext4 "$home" -L HOME    
                        mount "$home" /mnt/home

    else
 
 homed=$(lsblk -p -n -l -o NAME -e 7,11)       
            options=()
            for chd in ${homed}; do
                options+=("${chd}" "")
            done
            home=$(whiptail --title " HOME " --menu "Выберите раздел для монтирования HOME" 0 0 0 \
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
             mount "$home" /mnt/home      
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

#----------------  Установка базы   

pacstrap /mnt base base-devel linux linux-firmware nano dhcpcd netctl linux-headers which inetutils wget wpa_supplicant git mc dialog

genfstab -U -p /mnt >> /mnt/etc/fstab

#--------------  CHROOT  в систему

arch-chroot /mnt sh -c "$(curl -fsSL https://raw.githubusercontent.com/Makar-Makarych/makar/main/t-efi-btr3.sh)"


