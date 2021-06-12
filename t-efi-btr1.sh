#!/bin/bash
loadkeys ru
setfont cyr-sun16
clear
#------------------------- Обновление ключей ---------------------------------------

if (whiptail --title  "Добро пожаловать в установщик !" --yesno  "Вначале рекомендуется обновить ключи Pacman, чтобы избежать проблем с ключами в дальнейшем, если используете не свежий образ ArchLinux для установки! Обновить ключи ?" 10 100)
    then
        clear
        #echo ""
        pacman-key --init
        pacman-key --populate archlinux
    else
        whiptail --title "ОБНОВЛЕНИЕ КЛЮЧЕЙ ПРОПУЩЕНО" --msgbox "" 10 60
fi
        
#----------  Проверка BOOT / EFI  ---------------------

variable=`efibootmgr  | awk '/BootOrder: / {print $2}'`
if [[ $variable ]]; 
    then
        whiptail --title "Проверка BOOT / UEFI" --msgbox "Мы проверили Ваш компьютер и рекомендуем Вам выбрать УСТАНОВКУ В EFI" 10 60
    else
        whiptail --title "Проверка BOOT / UEFI" --msgbox "Мы проверили Ваш компьютер и рекомендуем Вам выбрать УСТАНОВКУ В MBR" 10 60
fi

#------------  Выбор типа установки  ---------------------

OPTION=$(whiptail --title  "ТИП УСТАНОВКИ" --menu  "Выберите вариант, как Вы хотите установить систему" 15 60 4 \
"1" "UEFI + BtrFS" \
"2" "UEFI + Ext4" \
"3" "MBR (Legacy) + BtrFS" \
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

while [ "$OPTION" ]
    do
        case $OPTION in
            "1")
                sh -c "$(curl -fsSL https://raw.githubusercontent.com/Makar-Makarych/makar/main/t-efi-btr2.sh)"
            break
            ;;
            "2")
                sh -c "$(curl -fsSL https://raw.githubusercontent.com/Makar-Makarych/makar/main/uefi_ext4.sh)"
            break
            ;;
            "4")
echo "Your 2 chosen option:" $OPTION
                #sh -c "$(curl -fsSL https://raw.githubusercontent.com/Makar-Makarych/makar/main/mbr_ext4.sh)"
            break 
            ;;
            "3")
echo "Your 2 chosen option:" $OPTION
            break
            ;;
        esac
    done
