#!/bin/bash
loadkeys ru
setfont cyr-sun16

DIALOG=${DIALOG=dialog}
tempfile=`tempfile 2>/dev/null` || tempfile=/tmp/test$$
trap "rm -f $tempfile" 0 1 2 5 15


$DIALOG --title " ПЕРЕЗАГРУЗКА " --clear --msgbox " УСТАНОВКА СИСТЕМЫ ЗАВЕРШЕНА. ПЕРЕЗАГРУЗИ КОМПЬЮТЕР " 10 40


