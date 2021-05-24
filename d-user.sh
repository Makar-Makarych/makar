#!/bin/bash
loadkeys ru
setfont cyr-sun16

#-----------  Создание паролей, пользователя и --------------

echo -e "\n ПРИДУМАЙТЕ И ВВЕДИТЕ ROOT ПАРОЛЬ \n "
	passwd
read -p "\n ПРИДУМАЙТЕ И ВВЕДИТЕ ИМЯ КОМПЬЮТЕРА \n " hostname
	echo $hostname > /etc/hostname
read -p "\n ПРИДУМАЙТЕ И ВВЕДИТЕ ИМЯ ПОЛЬЗОВАТЕЛЯ \n " username
	useradd -m -g users -G wheel -s /bin/bash $username
echo -e "\n ПРИДУМАЙТЕ И ВВЕДИТЕ ROOT ПАРОЛЬ \n "
	passwd
echo -e '\n ПРИДУМАЙТЕ И ВВЕДИТЕ ПАРОЛЬ ПОЛЬЗОВАТЕЛЯ \n '
	passwd $username

#---------------------  Временная зона  --------------------------


options=$(whiptail --title  "Test Menu Dialog" --menu  "Choose your option" 15 60 4 \
	"1" "Калининград" \
	"2" "Красноярск" \
	"3" "Киев" \
	"4" "Магадан" \
    "5" "Киров" \
    "6" "Новокузнецк" \
	"7" "Минск" \
	"8" "Новосибирск" \
	"9" "Москва" \
	"10" "Омск" \
	"11" "Самара" \
	"12" "Уральск" \
	"13" "Саратов" \
	"14" "Алматы" \
	"15" "Ульяновск" \
	"16" "Среднеколымск" \
	"17" "Запарожье" \
	"18" "Ташкент" \
	"19" "Чита" \
	"20" "Тбилиси" \
	"21" "Иркутск" \
    "22" "Томск" \
	"23" "Стамбул" \
	"24" "Якутск" \
	"25" "Камчатка" \
	"26" "Екатеринбург" \
	"27" "Ереван" \
    "28" "Настрою часовой пояс позже" 3>&1 1>&2 2>&3)

exitstatus=$?
if [ $exitstatus = 0 ];  
	then
    	echo "Your chosen option:" $options
	else
    	echo "You chose Cancel."
fi

select opt in "${options[@]}"
do
    case $opt in
            "1")
            ln -sf /usr/share/zoneinfo/Europe/Kaliningrad /etc/localtime
            break
            ;;
            "2")
            ln -sf /usr/share/zoneinfo/Asia/Krasnoyarsk /etc/localtime
            break
            ;;
            "3")
            ln -sf /usr/share/zoneinfo/Europe/Kiev /etc/localtime
            break
            ;;
            "4")
            ln -sf /usr/share/zoneinfo/Asia/Magadan /etc/localtime
            break
            ;;
            "5" )
            ln -sf /usr/share/zoneinfo/Europe/Kirov /etc/localtime      
            break
            ;;
            "6")
            ln -sf /usr/share/zoneinfo/Asia/Novokuznetsk /etc/localtime
            break
            ;;
            "7")
            ln -sf /usr/share/zoneinfo/Europe/Minsk /etc/localtime
            break
            ;;
            "8")
            ln -sf /usr/share/zoneinfo/Asia/Novosibirsk /etc/localtime
            break
            ;;
            "9")
            ln -sf /usr/share/zoneinfo/Europe/Moscow /etc/localtime
            break
            ;;
            "11")
            ln -sf /usr/share/zoneinfo/Europe/Samara /etc/localtime
            break
            ;;
            "13")
            ln -sf /usr/share/zoneinfo/Europe/Saratov /etc/localtime
            break
            ;;
            "15")
            ln -sf /usr/share/zoneinfo/Europe/Ulyanovsk /etc/localtime
            break
            ;;
            "17")
            ln -sf /usr/share/zoneinfo/Europe/Zaporozhye /etc/localtime
            break
            ;;
            "19")
            ln -sf /usr/share/zoneinfo/Asia/Chita /etc/localtime
            break
            ;;
            "21")
            ln -sf /usr/share/zoneinfo/Asia/Irkutsk /etc/localtime
            break
            ;;
            "23")
            ln -sf /usr/share/zoneinfo/Asia/Istanbul /etc/localtime
            break
            ;;
            "25")
            ln -sf /usr/share/zoneinfo/Asia/Kamchatka /etc/localtime
            break
            ;;
            "10")
            ln -sf /usr/share/zoneinfo/Asia/Omsk /etc/localtime
            break
            ;;
            "12")
            ln -sf /usr/share/zoneinfo/Asia/Oral /etc/localtime
            break
            ;;
            "14")
            ln -sf /usr/share/zoneinfo/Asia/Almaty /etc/localtime
            break
            ;;
            "16")
            ln -sf /usr/share/zoneinfo/Asia/Srednekolymsk /etc/localtime
            break
            ;;
            "18")
            ln -sf /usr/share/zoneinfo/Asia/Tashkent /etc/localtime
            break
            ;;
            "20")
            ln -sf /usr/share/zoneinfo/Asia/Tbilisi /etc/localtime
            break
            ;;
            "22")
            ln -sf /usr/share/zoneinfo/Asia/Tomsk /etc/localtime
            break
            ;;
            "24")
            ln -sf /usr/share/zoneinfo/Asia/Yakutsk /etc/localtime
            break
            ;;
            "26")
            ln -sf /usr/share/zoneinfo/Asia/Yekaterinburg /etc/localtime
            break
            ;;
            "27")
            ln -sf /usr/share/zoneinfo/Asia/Yerevan /etc/localtime
            break
            ;;
            "28")
            clear
            echo " Этап пропущен "
            echo ""
            break
            ;;
            "")
            exit
            break
            ;;
        *) echo "";;
    esac
done

#-----------  Добавляем русскую локаль  и язык системы

echo "en_US.UTF-8 UTF-8" > /etc/locale.gen
echo "ru_RU.UTF-8 UTF-8" >> /etc/locale.gen
locale-gen
echo 'LANG="ru_RU.UTF-8"' > /etc/locale.conf 
echo "KEYMAP=ru" >> /etc/vconsole.conf
echo "FONT=cyr-sun16" >> /etc/vconsole.conf

#----------- Загрузочный RAM 

echo 'Создадим загрузочный RAM диск'
mkinitcpio -p linux

#----------  Ставим программу для Wi-fi'

pacman -S dialog wpa_supplicant --noconfirm 

#-------- 'Устанавливаем SUDO'

echo '%wheel ALL=(ALL) ALL' >> /etc/sudoers

#-----------------Раскомментируем репозиторий multilib Для работы 32-битных приложений в 64-битной системе.'

echo '[multilib]' >> /etc/pacman.conf
echo 'Include = /etc/pacman.d/mirrorlist' >> /etc/pacman.conf
pacman -Syy

#----------------  Виртуалка или реальная машина


if (whiptail --title  "ВИРТУАЛЬНАЯ \ РЕАЛЬНАЯ МАШИНА" --yesno  "Устанавливем Arch Linux на виртуальную машину?" 10 60)  
    then
        #pacman -S xorg-server xorg-drivers xorg-xinit virtualbox-guest-utils
        echo "You chose Yes. Exit status was $?."
    else
        #pacman -S xorg-server xorg-drivers xorg-xinit
        echo "You chose No. Exit status was $?."
fi


#    ---------------------   далее ставим загрузчик