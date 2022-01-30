#!/bin/bash
loadkeys ru
setfont cyr-sun16

DIALOG=${DIALOG=dialog}
tempfile=`tempfile 2>/dev/null` || tempfile=/tmp/test$$
trap "rm -f $tempfile" 0 1 2 5 15


$DIALOG --title " ПЕРЕЗАГРУЗКА " --clear \
        --yesno " УСТАНОВКА СИСТЕМЫ ЗАВЕРШЕНА. ПЕРЕЗАГРУЗИТЬ КОМПЬЮТЕР ?" 10 40

case $? in
    0)
    umount -R /mnt
    shutdown -r now
    ;;
    1)
    umount -R /mnt
    clear
	;;
    255)
	echo "Нажата клавиша ESC.";;
esac


