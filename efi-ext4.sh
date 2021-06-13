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
        mkfs.ext4 /dev/$root -L root
        mount /dev/$root /mnt
        mkdir /mnt/{boot,home}
fi

#------------------   BOOT   ----------------------

if (whiptail --title  "BOOT - РАЗДЕЛ" --yesno "НУЖНО ЛИ ФОРМАТИРОВАТЬ BOOT - РАЗДЕЛ ВАШЕГО ДИСКА ?$(echo "" && echo "" && lsblk)" 30 60)  
    then
        bootd=$(whiptail --title  "BOOT - РАЗДЕЛ" --inputbox  "УКАЖИТЕ ИМЯ РАЗДЕЛА ДЛЯ ФОРМАТИРОВАНИЯ (sda/sdb 1.2.3.4 ( например sda5 )$(echo "" && echo "" && lsblk)" 30 60 3>&1 1>&2 2>&3)
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
        bootd=$(whiptail --title  "BOOT - РАЗДЕЛ" --inputbox  "УКАЖИТЕ ИМЯ РАЗДЕЛА ДЛЯ МОНТИРОВАНИЯ (sda/sdb 1.2.3.4   ( например sda5 )$(echo "" && echo "" && lsblk)" 30 60 3>&1 1>&2 2>&3)
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

#------------------    SWAP       ----------------------

if (whiptail --title  "SWAP - РАЗДЕЛ" --yesno  "Подключить SWAP раздел ?" 10 60)  
    then
        
        swaps=$(whiptail --title  "SWAP - РАЗДЕЛ" --inputbox  "УКАЖИТЕ ИМЯ РАЗДЕЛА ДЛЯ SWAP (sda/sdb 1.2.3.4 ( например sda5 )$(echo "" && echo "" && lsblk)" 30 60 3>&1 1>&2 2>&3)
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


#------------------  HOME  ----------------------

if (whiptail --title "HOME - РАЗДЕЛ" --yesno "Имеется ли раздел, размеченный как HOME ? $(echo "" && echo "" && lsblk)" 30 60)
    then
        if (whiptail --title  "HOME - РАЗДЕЛ" --yesno "НУЖНО ЛИ ФОРМАТИРОВАТЬ HOME - РАЗДЕЛ ВАШЕГО ДИСКА ? $(echo "" && echo "" && lsblk)" 30 60)  
            then
                homed=$(whiptail --title  "HOME - РАЗДЕЛ" --inputbox  "УКАЖИТЕ ИМЯ РАЗДЕЛА ДЛЯ ФОРМАТИРОВАНИЯ (sda/sdb 1.2.3.4 ( например sda5 )$(echo "" && echo "" && lsblk)" 30 60 3>&1 1>&2 2>&3)
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
                homed=$(whiptail --title  "HOME - РАЗДЕЛ" --inputbox  "УКАЖИТЕ ИМЯ РАЗДЕЛА ДЛЯ МОНТИРОВАНИЯ (sda/sdb 1.2.3.4   ( например sda5 )$(echo "" && echo "" && lsblk)" 30 60 3>&1 1>&2 2>&3)
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

#--------------  CHROOT  в систему

arch-chroot /mnt sh -c "$(curl -fsSL https://raw.githubusercontent.com/Makar-Makarych/makar/main/t-efi-btr3.sh)"


