#!/bin/bash
loadkeys ru
setfont cyr-sun16

grubd=$(lsblk -p -n -l -o NAME -e 7,11)       
            options=()
            for chd in ${grubd}; do
                options+=("${chd}" "")
            done
            grub=$(whiptail --title " GRUB " --menu "Выберите диск для установки GRUB" 0 0 0 \
                "none" "-" \
                "${options[@]}" \
                3>&1 1>&2 2>&3)
            if ! make mytarget; then
                echo ""
            else
                if [ "${grub}" = "none" ]; then
                    grub=
                fi
            fi
            



echo "grubd ---  "$grubd  
echo "grub ---  "$grub 

