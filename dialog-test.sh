#!/bin/sh


DIALOG=${DIALOG=dialog}
tempfile=`mktemp 2>/dev/null` || tempfile=/tmp/test$$
trap "rm -f $tempfile" 0 1 2 5 15
 
dialog --clear --title "Мои любимые исполнители" \
        --menu "Все любят песни хинди, поэтому выбирайте:" 20 51 4 \
        "Rafi"  "Mohammed Rafi" \
        "Mukesh" "Mukesh" \
        "Kishore" "Kishore Kumar" \
        "Saigal" "K L Saigal" \
        "Lata"  "Lata Mangeshkar" \
        "Yesudas"  "K J Yesudas" 2> $tempfile
 
retval=$?
 
choice=`cat $tempfile`
 
case $retval in
  0)
    echo "Да вы эстет! '$choice' -- это лучшее, что вы слышали в своей жизни!";;
  1)
    echo "Отказ от ввода.";;
  255)
    echo "Нажата клавиша ESC.";;
esac