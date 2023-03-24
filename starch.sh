#!/bin/bash
setfont cyr-sun16

#OPTION=$(whiptail --title  " LANGUAGE " --menu  "
#
#   " 15 60 4 \
# "1" "Russian" \
# "2" "English" 3>&1 1>&2 2>&3)
 
# exitstatus=$?
# if [ $exitstatus = 0 ];  
#     then
#         clear
#         echo "" 
#     else
#         clear
#         echo ""
# fi

# #-----------  Переход по выбору  ------------------------

# case $OPTION in
#                 "1")
                sh -c "$(curl -fsSL https://raw.githubusercontent.com/Makar-Makarych/makar/main/t-efi-btr1.sh)"
#              break
#              ;;
#                 "2")
#                 sh -c "$(curl -fsSL https://raw.githubusercontent.com/Makar-Makarych/makar/main/t-efi-btr1-en.sh)"
             
#              break
#              ;;
#                 255)
#      	        echo " ESC.";;
# esac
