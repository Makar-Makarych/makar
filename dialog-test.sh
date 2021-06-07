#!/bin/sh

DIALOG=${DIALOG=dialog}
tempfile=`mktemp 2>/dev/null` || tempfile=/tmp/test$$
trap "rm -f $tempfile" 0 1 2 5 15
 


$DIALOG --clear --title " ЧАСОВЫЕ ПОЯСА " \
        --menu "ВЫБЕРИТЕ ВАШ ЧАСОВОЙ ПОЯС :" 15 45 4 \
        "Алматы" \
        "Екатеринбург" \
        "Ереван" \
        "Запарожье" \
        "Иркутск" \
        "Калининград" \
        "Камчатка" \
        "Киев" \
        "Киров" \
        "Красноярск" \
        "Магадан" \
        "Минск" \
        "Москва" \
        "Новокузнецк" \
        "Новосибирск" \
        "Омск" \
        "Самара" \
        "Саратов" \
        "Среднеколымск" \
        "Стамбул" \
        "Ташкент" \
        "Тбилиси" \
        "Томск" \
        "Ульяновск" \
        "Уральск" \
        "Чита" \
        "Якутск" 2>> $tempfile
 
#retval=$?
 
#tzone=$(`cat $tempfile`)

#echo $tzone


# #select $tzone
# do
#     case $tzone in
#             "Калининград")
#             #ln -sf /usr/share/zoneinfo/Europe/Kaliningrad /etc/localtime
#             break
#             ;;
#             "Красноярск")
#             #ln -sf /usr/share/zoneinfo/Asia/Krasnoyarsk /etc/localtime
#             break
#             ;;
#             "Киев")
#             #ln -sf /usr/share/zoneinfo/Europe/Kiev /etc/localtime
#             break
#             ;;
#             "Магадан")
#             #ln -sf /usr/share/zoneinfo/Asia/Magadan /etc/localtime
#             break
#             ;;
#             "Киров" )
#             #ln -sf /usr/share/zoneinfo/Europe/Kirov /etc/localtime      
#             break
#             ;;
#             "Новокузнецк")
#             #ln -sf /usr/share/zoneinfo/Asia/Novokuznetsk /etc/localtime
#             break
#             ;;
#             "Минск")
#             #ln -sf /usr/share/zoneinfo/Europe/Minsk /etc/localtime
#             break
#             ;;
#             "Москва")
#             #ln -sf /usr/share/zoneinfo/Europe/Moscow /etc/localtime
#             break
#             echo "Москва"
#             ;;
#             "Самара")
#             #ln -sf /usr/share/zoneinfo/Europe/Samara /etc/localtime
#             break
#             ;;
#             "Саратов")
#             #ln -sf /usr/share/zoneinfo/Europe/Saratov /etc/localtime
#             break
#             ;;
#             "Ульяновск")
#             #ln -sf /usr/share/zoneinfo/Europe/Ulyanovsk /etc/localtime
#             break
#             ;;
#             "Запарожье")
#             #ln -sf /usr/share/zoneinfo/Europe/Zaporozhye /etc/localtime
#             break
#             ;;
#             "Чита")
#             #ln -sf /usr/share/zoneinfo/Asia/Chita /etc/localtime
#             break
#             ;;
#             "Иркутск")
#             #ln -sf /usr/share/zoneinfo/Asia/Irkutsk /etc/localtime
#             break
#             ;;
#             "Стамбул")
#             #ln -sf /usr/share/zoneinfo/Asia/Istanbul /etc/localtime
#             break
#             ;;
#             "Камчатка")
#             #ln -sf /usr/share/zoneinfo/Asia/Kamchatka /etc/localtime
#             break
#             ;;
#             "Новосибирск")
#             #ln -sf /usr/share/zoneinfo/Asia/Novosibirsk /etc/localtime
#             break
#             ;;
#             "Омск")
#             #ln -sf /usr/share/zoneinfo/Asia/Omsk /etc/localtime
#             break
#             ;;
#             "Уральск")
#             #ln -sf /usr/share/zoneinfo/Asia/Oral /etc/localtime
#             break
#             ;;
#             "Алматы")
#             #ln -sf /usr/share/zoneinfo/Asia/Almaty /etc/localtime
#             break
#             ;;
#             "Среднеколымск")
#             #ln -sf /usr/share/zoneinfo/Asia/Srednekolymsk /etc/localtime
#             break
#             ;;
#             "Ташкент")
#             #ln -sf /usr/share/zoneinfo/Asia/Tashkent /etc/localtime
#             break
#             ;;
#             "Тбилиси")
#             #ln -sf /usr/share/zoneinfo/Asia/Tbilisi /etc/localtime
#             break
#             ;;
#             "Томск")
#             #ln -sf /usr/share/zoneinfo/Asia/Tomsk /etc/localtime
#             break
#             ;;
#             "Якутск")
#             #ln -sf /usr/share/zoneinfo/Asia/Yakutsk /etc/localtime
#             break
#             ;;
#             "Екатеринбург")
#             #ln -sf /usr/share/zoneinfo/Asia/Yekaterinburg /etc/localtime
#             break
#             ;;
#             "Ереван")
#             #ln -sf /usr/share/zoneinfo/Asia/Yerevan /etc/localtime
#             break
#             ;;
#             "")
#             exit
#             break
#            ;;
#         *) echo "NNNNNNN";;
#     esac
# done


# $DIALOG --title "Ввод данных" --clear \
#   --inputbox "Привет! Перед вами пример ввода даных\nВведите свое имя:" 16 51 2> $tempfile
 

# ttt=`cat $tempfile`

# retval=$?
 
# case $retval in
#   0)
#     echo "Вы ввели `cat $tempfile`"
#     ;;
#   1)
#     echo "Отказ от ввода.";;
#   255)
#     if test -s $tempfile ; then
#       cat $tempfile
#     else
#       echo "Нажата клавиша ESC."
#     fi
#     ;;
# esac


# echo " TEXT = $ttt"