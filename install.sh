#!/bin/bash
loadkeys ru
setfont cyr-sun16
clear
#------------------------- Обновление ключей ---------------------------------------
echo -e "Добро пожаловать в установщик !\n \n"
echo -e "\033[33m  Вначале рекомендуется обновить ключи Pacman, чтобы избежать проблем с ключами в  дальнейшем, если используете не свежий образ ArchLinux для установки! \033[0m "
echo ""
echo ""
echo "Обновить ключи ? "
echo ""
PS3='Выберите вариант : '
options=("Да"  "Нет"  "Ну нахер все, выход из скрипта!")
select opt in "${options[@]}"
do
    case $opt in
        "Да")
            pacman-key --init
            pacman-key --populate archlinux
    # pacman-key --refresh-keys
            break
            ;;
        "Нет")
            echo -e "\033[31m \n !!!  ОБНОВЛЕНИЕ КЛЮЧЕЙ ПРОПУЩЕНО  !!! \033[0m"
            break
            ;;
        "Ну нахер все, выход из скрипта!")
            exit
            break
            ;;
        *) echo "Хрень какую-то Ввели, попробуем еще раз? $REPLY";;
    esac
done
#echo "Вышли из цикла."

#----------------- Выбор UEFI-Btrfs , UEFI-Ext4 или MBR-Ext4  ------------------

#/////////////////////////////////////////////////////////////////////////////////////
#                           Выбор UEFI или Legacy
#/////////////////////////////////////////////////////////////////////////////////////
echo -e "\033[32m"
read -n 1 -s -r -p "Нажмите любую кнопку для продолжения"
echo -e "\033[0m"
clear
variable=`efibootmgr  | awk '/BootOrder: / {print $2}'`
if [[ $variable ]]; then
            echo ""
            echo ""
            echo -e "\033[33m Мы проверили Ваш компьютер и рекомендуем Вам выбрать УСТАНОВКУ В EFI. \033[0m"
else
            echo ""
            echo ""
            echo -e "\033[33m Мы проверили Ваш компьютер и рекомендуем Вам выбрать УСТАНОВКУ В MBR. \033[0m"
fi
            echo ""
            echo ""

  echo -e " Какой тип установки Вы предпочитаете? \n  "          
PS3=' Введите номер : '
options=("UEFI-Btrfs" "UEFI-Ext4" "MBR-Ext4" "Ну нахер все, выход из скрипта!")
select opt in "${options[@]}"
do
    case $opt in
        "UEFI-Btrfs")
            sh -c "$(curl -fsSL https://raw.githubusercontent.com/Makar-Makarych/makar/main/uefi_btrfs.sh)"
            break
            ;;
        "UEFI-Ext4")
            sh -c "$(curl -fsSL https://raw.githubusercontent.com/Makar-Makarych/makar/main/uefi_ext4.sh)"
            break
            ;;
        "MBR-Ext4")
            sh -c "$(curl -fsSL https://raw.githubusercontent.com/Makar-Makarych/makar/main/mbr_ext4.sh)"
            break 
            ;;
        "Ну нахер все, выход из скрипта!")
            exit
            break
            ;;
        *) echo "Хрень какую-то Ввели, попробуем еще раз? $REPLY";;
    esac
done

