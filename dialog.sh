#!/bin/bash
loadkeys ru
setfont cyr-sun16
clear
#------------------------- Обновление ключей ---------------------------------------
echo -e "Добро пожаловать в установщик !\n \n"
echo -e "\033[33m  Вначале рекомендуется обновить ключи Pacman, чтобы избежать проблем с ключами в дальнейшем, если используете не свежий образ ArchLinux для установки! \033[0m "
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
			echo "ОБНОВЛЕНИЕ"
            #pacman-key --init
            #pacman-key --populate archlinux
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