#!/bin/bash
setfont ter-v32b
clear
#------------------------- Обновление ключей ---------------------------------------

if (whiptail --title  " WELCOME TO THE INSTALLER " --yesno  " In the beginning, it is recommended to update the Pacman keys to avoid problems with the keys in the future, if you are not using a fresh ArchLinux image for installation. 

                   Update your keys ?" 12 60)
    then
        clear
        #echo ""
        pacman-key --init
        pacman-key --populate archlinux
    else
        whiptail --title " KEY UPDATE SKIPPED " --msgbox "" 10 60
fi
        
#----------  CHECKING BOOT / UEFI  ---------------------

variable=`efibootmgr  | awk '/BootOrder: / {print $2}'`
if [[ $variable ]]; 
    then
        whiptail --title " CHECKING BOOT / UEFI " --msgbox "
  
  We have checked your computer and recommend that you choose to install in UEFI" 10 60
    else
        whiptail --title " CHECKING BOOT / UEFI " --msgbox "

  We have checked your computer and recommend that you choose to install in MBR" 10 60
fi

#------------  Select ---------------------

OPTION=$(whiptail --title  " BOOT / UEFI " --menu  "

  Select the option how you want to install the system" 15 60 4 \
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

#-----------  Click-through option  ------------------------

case $OPTION in
                "1")
                sh -c "$(curl -fsSL https://raw.githubusercontent.com/Makar-Makarych/makar/main/t-efi-btr2-en.sh)"
             break
             ;;
                "2")
                sh -c "$(curl -fsSL https://raw.githubusercontent.com/Makar-Makarych/makar/main/efi-ext4-en.sh)"
             break
             ;;
                "3")
                echo ""
                sh -c "$(curl -fsSL https://raw.githubusercontent.com/Makar-Makarych/makar/main/mbr-btr-en.sh)"
             break
             ;;
                "4")
                echo ""
                sh -c "$(curl -fsSL https://raw.githubusercontent.com/Makar-Makarych/makar/main/mbr-ext-en.sh)"
             break
             ;;
            255)
            echo " ESC.";;
esac
