#!/bin/bash
loadkeys ru
setfont cyr-sun16


############################################################
############################################################
###              Часть 2 --- Установка в MBR и Ext4      ###  
############################################################
############################################################
clear
echo -e "\n В данное время Ваш диск размечен следующим образом : \n \n \n"
lsblk -f
            echo ""
            echo ""
            echo -e " Нужна разметка диска ? \n"
PS3=' ВВедите номер ответа : '
options=("Да" "Нет" "Ну нахер все, выход из скрипта!")
select opt in "${options[@]}"
do
    case $opt in
        "Да")
             clear
            lsblk -f
            echo ""
            read -p " Укажите диск (sda/sdb/sdc) " cfd
            cfdisk /dev/$cfd
            break
            ;;
        "Нет")
            echo 'разметка пропущена.'
            break
            ;;
        "Ну нахер все, выход из скрипта!")
            exit
            break
            ;;
        *) echo "Хрень какую-то Ввели, попробуем еще раз? $REPLY";;
    esac
done
# echo -e "\033[32m"
# read -n 1 -s -r -p "Нажмите любую кнопку для продолжения"
# echo -e "\033[0m"

#------------------------------ ROOT
clear
lsblk -f
echo ""
read -p " Укажите ROOT раздел(sda/sdb 1.2.3.4 (sda5 например)):" root
echo ""
mkfs.ext4 /dev/$root -L root
mount /dev/$root /mnt
mkdir /mnt/{boot,home}
echo ""     
echo -e "\033[32m"
read -n 1 -s -r -p "Нажмите любую кнопку для продолжения"
echo -e "\033[0m"

#-------------------------------- BOOT
clear
lsblk -f
echo ""
echo -e " Если производиться установка, и у вас уже имеется BOOT раздел от предыдущей системы, тогда вам необходимо его форматировать. Если у вас раздел не вынесен на другой раздел, тогда этот этап можно пропустить \n \n"

echo -e " Нужно форматировать BOOT раздел ? \n"
PS3=' ВВедите номер ответа : '
options=("Да" "Нет" "Нет BOOT раздела" "Ну нахер все, выход из скрипта!")
select opt in "${options[@]}"
do
    case $opt in
        "Да")
            read -p " Укажите BOOT раздел(sda/sdb 1.2.3.4 (sda7 например)):" bootd
            mkfs.ext2  /dev/$bootd -L boot
            mkdir /mnt/boot
            mount /dev/$bootd /mnt/boot
            echo " Продолжим дальше ..."
            break
            ;;
        "Нет")
            read -p " Укажите BOOT раздел(sda/sdb 1.2.3.4 (sda7 например)):" bootd
            mkdir /mnt/boot
            mount /dev/$bootd /mnt/boot
            echo " Продолжим дальше ..."
            break
            ;;
        "Нет BOOT раздела")
            echo " Продолжим дальше ..."
            break
            ;;
        "Ну нахер все, выход из скрипта!")
            exit
            break
            ;;
        *) echo "Хрень какую-то Ввели, попробуем еще раз? $REPLY";;
    esac
done
echo -e "\033[32m"
read -n 1 -s -r -p "Нажмите любую кнопку для продолжения"
echo -e "\033[0m"

###----------------------------------- SWAP

clear
lsblk -f
echo ""
echo -e " Подключить SWAP раздел ? \n"
PS3=' ВВедите номер ответа : '
options=("Да" "Нет" "Ну нахер все, выход из скрипта!")
select opt in "${options[@]}"
do
    case $opt in
        "Да")
            read -p "Укажите swap раздел(sda/sdb 1.2.3.4 (sda7 например)):" swaps
            mkswap /dev/$swaps -L swap
            swapon /dev/$swaps
            echo " Продолжим дальше ..."
            break
            ;;
        "Нет")
            echo " Продолжим дальше ..."
            break
            ;;
        "Ну нахер все, выход из скрипта!")
            exit
            break
            ;;
        *) echo "Хрень какую-то Ввели, попробуем еще раз? $REPLY";;
    esac
done
echo -e "\033[32m"
read -n 1 -s -r -p "Нажмите любую кнопку для продолжения"
echo -e "\033[0m"

 
###  --------------    HOME
clear
lsblk -f
echo ""
echo -e " Нужно форматировать HOME раздел ? \n"
PS3=' ВВедите номер ответа : '
options=("Да" "Нет" "Нет HOME раздела" "Ну нахер все, выход из скрипта!")
select opt in "${options[@]}"
do
    case $opt in
        "Да")
            read -p "Укажите HOME раздел(sda/sdb 1.2.3.4 (sda6 например)):" home
            mkfs.ext4 /dev/$home -L home    
            mkdir /mnt/home 
            mount /dev/$home /mnt/home
            echo " Продолжим дальше ..."
            break
            ;;
        "Нет")
            read -p "Укажите HOME раздел(sda/sdb 1.2.3.4 (sda6 например)):" homeV
            mkdir /mnt/home 
            mount /dev/$homeV /mnt/home
            echo " Продолжим дальше ..."
            break
            ;;
        "Нет BOOT раздела")
            echo " Продолжим дальше ..."
            break
            ;;
        "Ну нахер все, выход из скрипта!")
            exit
            break
            ;;
        *) echo "Хрень какую-то Ввели, попробуем еще раз? $REPLY";;
    esac
done
echo -e "\033[32m"
read -n 1 -s -r -p "Нажмите любую кнопку для продолжения"
echo -e "\033[0m"



##------------------   Зеркала
pacman -Sy
clear

echo -e "Есть возможность выбрать и обновить ближайшие зеркала \n"
echo -e " Обновить зеркала ? \n"
PS3=' ВВедите номер ответа : '
options=("Да" "Нет" "Ну нахер все, выход из скрипта!")
select opt in "${options[@]}"
do
    case $opt in
        "Да")
        echo -e "\033[33m Сейчас будет выбрано 15 самых быстрых зеркал из ближайших для вашего местоположения \033[0m"
            pacman -S reflector --noconfirm
            reflector -a 12 -l 15 -p https,http --sort rate --save /etc/pacman.d/mirrorlist --verbose
            echo " Продолжим дальше ..."
            break
            ;;
        "Нет")
            echo " Смена зеркал пропущена. Продолжим дальше ..."
            break
            ;;
        "Ну нахер все, выход из скрипта!")
            exit
            break
            ;;
        *) echo "Хрень какую-то Ввели, попробуем еще раз? $REPLY";;
    esac
done
echo -e "\033[32m"
read -n 1 -s -r -p "Нажмите любую кнопку для продолжения"
echo -e "\033[0m"


pacman -Sy --noconfirm



######################  Установка базы      ################################### 

pacstrap /mnt base base-devel linux linux-firmware nano dhcpcd netctl linux-headers which inetutils wget wpa_supplicant dialog

genfstab -pU /mnt >> /mnt/etc/fstab

#############################################################
# arch-chroot /mnt sh -c "$(curl -fsSL git.io/arch2.sh)" # Продолжение установки по скрипту Бойко
##############################################################


arch-chroot /mnt sh -c "$(curl -fsSL https://raw.githubusercontent.com/Makar-Makarych/makar/main/mbr_ext4_chroot.sh)"

#  Файл mbr_ext4_chroot


