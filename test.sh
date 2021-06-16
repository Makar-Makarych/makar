#!/bin/bash
loadkeys ru
setfont cyr-sun16


OPTION=$(whiptail --title  " ТИП УСТАНОВКИ " --menu  "

  Выберите вариант, как Вы хотите установить систему" 15 60 4 \
"1" "UEFI + BtrFS + Subvolumes" \
"2" "UEFI + Ext4" \
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