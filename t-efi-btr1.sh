#!/bin/bash
loadkeys ru
setfont cyr-sun16
clear
#------------------------- Обновление ключей ---------------------------------------

whiptail --title " Arch Linux " --msgbox "

        Добро пожаловать в установщик" 10 60


#whiptail --title  " Arch Linux " --msgbox  "  ДОБРО ПОЖАЛОВАТЬ В УСТАНОВЩИК ! " 12 60
        pacman-key --init
        pacman-key --populate archlinux

#----------  Проверка BOOT / EFI  ---------------------

variable=$(efibootmgr  | awk '/BootOrder: / {print $2}')
if [[ $variable ]]; 
    then
        whiptail --title " ПРОВЕРКА BOOT / UEFI " --msgbox "
  
  Мы проверили Ваш компьютер и рекомендуем Вам выбрать установку В EFI" 10 60
    else
        whiptail --title " ПРОВЕРКА BOOT / UEFI " --msgbox "

  Мы проверили Ваш компьютер и рекомендуем Вам выбрать установку В MBR" 10 60
fi

#------------  Выбор типа установки  ---------------------

OPTION=$(whiptail --title  " ТИП УСТАНОВКИ " --menu  "

  Выберите вариант, как Вы хотите установить систему" 15 60 4 \
"1" "UEFI + BtrFS + Subvolumes" \
"2" "UEFI + Ext4 (пока не работает)" \
"3" "MBR (Legacy) + BtrFS + Subvolumes" \
"4" "MBR (Legacy) + Ext4"  3>&1 1>&2 2>&3)
 
exitstatus=$?
if [ $exitstatus = 0 ];  
    then
        clear
        echo "" 
    else
        clear
        echo ""
fi

#-----------  Переход по выбору  ------------------------

case $OPTION in
                "1")
                sh -c "$(curl -fsSL https://raw.githubusercontent.com/Makar-Makarych/makar/main/t-efi-btr2.sh)"
             
             ;;
                "2")
                sh -c "$(curl -fsSL https://raw.githubusercontent.com/Makar-Makarych/makar/main/efi-ext4.sh)"
             
             ;;
                "3")
                echo ""
                sh -c "$(curl -fsSL https://raw.githubusercontent.com/Makar-Makarych/makar/main/mbr-btr.sh)"
             
             ;;
                "4")
                echo ""
                sh -c "$(curl -fsSL https://raw.githubusercontent.com/Makar-Makarych/makar/main/mbr-ext.sh)"
             
             ;;
            255)
            echo "Нажата клавиша ESC.";;
esac
