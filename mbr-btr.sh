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
                    cfdisk /dev/"$cfd"
            else
                clear
            fi
        clear
    else
    clear   
fi

#------------------  ROOT   ----------------------

root=$(whiptail --title  "ROOT - Раздел" --inputbox  "Укажите системный раздел ROOT ( / ) (sda/sdb 1.2.3.4 ( например sda5 ) $(echo "" && echo "" && lsblk)" 30 80 3>&1 1>&2 2>&3)
 
exitstatus=$?
if [ $exitstatus = 0 ];  
    then
        clear
        mkfs.btrfs -f -L arch /dev/$root
        mount /dev/$root /mnt
        mkdir /mnt/{boot,home}
fi

#------------------   BOOT   ----------------------

if (whiptail --title "BOOT - РАЗДЕЛ" --yesno "Имеется ли раздел, размеченный как BOOT ? $(echo "" && echo "" && lsblk)" 30 60)
    then
        if (whiptail --title  "BOOT - РАЗДЕЛ" --yesno "Нужно ли форматировать BOOT - раздел Вашего диска ? $(echo "" && echo "" && lsblk)" 30 60)  
            then
                bootd=$(whiptail --title  "BOOT - РАЗДЕЛ" --inputbox  "Укажите имя раздела для форматирования (sda/sdb 1.2.3.4 ( ПРИМЕР: sda5 )$(echo "" && echo "" && lsblk)" 30 60 3>&1 1>&2 2>&3)
                exitstatus=$?
                if [ $exitstatus = 0 ];  
                    then
                        clear
                        mkfs.ext2 /dev/$bootd -L boot    
                        mkdir /mnt/boot
                		mount /dev/$bootd /mnt/boot
                    else
                        clear
                fi
                    clear
            else
                bootd=$(whiptail --title  "BOOT - РАЗДЕЛ" --inputbox  "Укажите имя раздела для монтирования (sda/sdb 1.2.3.4  ( ПРИМЕР: sda5 )$(echo "" && echo "" && lsblk)" 30 60 3>&1 1>&2 2>&3)
                exitstatus=$?
                if [ $exitstatus = 0 ];  
                    then
                        clear
                        mkdir /mnt/boot 
                        mount /dev/$bootd /mnt/boot
                    else
                        clear
                fi
                clear
        fi
            clear
    else
        clear
fi        


#------------------  HOME  ----------------------

if (whiptail --title "HOME - РАЗДЕЛ" --yesno "Имеется ли раздел, размеченный как HOME ? $(echo "" && echo "" && lsblk)" 30 60)
    then
        if (whiptail --title  "HOME - РАЗДЕЛ" --yesno "Нужно ли форматировать HOME - раздел Вашего диска ? $(echo "" && echo "" && lsblk)" 30 60)  
            then
                homed=$(whiptail --title  "HOME - РАЗДЕЛ" --inputbox  "Укажите имя раздела HOME (sda/sdb 1.2.3.4 ( ПРИМЕР: sda5 )$(echo "" && echo "" && lsblk)" 30 60 3>&1 1>&2 2>&3)
                exitstatus=$?
                if [ $exitstatus = 0 ];  
                    then
                        clear
                        mkfs.btrfs -f -L home /dev/$homed    
                        mkdir /mnt/home 
                        mount /dev/$homed /mnt/home
                    else
                        clear
                fi
                    clear
            else
                homed=$(whiptail --title  "HOME - РАЗДЕЛ" --inputbox  "Укажите имя раздела для монтирования (sda/sdb 1.2.3.4   ( ПРИМЕР: sda5 )$(echo "" && echo "" && lsblk)" 30 60 3>&1 1>&2 2>&3)
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


#------------------    SWAP       ----------------------

if (whiptail --title  "SWAP - РАЗДЕЛ" --yesno  "Подключить SWAP раздел ?" 10 60)  
    then
        swaps=$(whiptail --title  "SWAP - РАЗДЕЛ" --inputbox  "Укажите имя раздела SWAP (sda/sdb 1.2.3.4 ( ПРИМЕР: sda5 )$(echo "" && echo "" && lsblk)" 30 60 3>&1 1>&2 2>&3)
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

mount /dev/"$bootd" /mnt/boot


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



######################  Установка базы      ################################### 

pacstrap /mnt base base-devel linux linux-firmware nano dhcpcd netctl linux-headers which inetutils wget wpa_supplicant git mc dialog

genfstab -pU /mnt >> /mnt/etc/fstab

arch-chroot /mnt sh -c "$(curl -fsSL https://raw.githubusercontent.com/Makar-Makarych/makar/main/mbr-user.sh)"