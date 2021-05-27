#!/bin/bash
loadkeys ru
setfont cyr-sun16


if (whiptail --title  "ЗЕРКАЛА" --yesno  "Сейчас можно автоматически выбрать 15 самых быстрых зеркал из ближайших для вашего местоположения, но это займет каое-то время. После обновления (или пропуска) сразу же начнется установка базовой системы. Запустить атоматический выбор зеркал ? " 10 60)  
	then
		clear
    	pacman -S reflector --noconfirm
        reflector -a 12 -l 15 -p https,http --sort rate --save /etc/pacman.d/mirrorlist --verbose
    	pacman -Sy --noconfirm
    	#echo "Зеркала выбраны $?."
	else
		clear
    	pacman -Sy --noconfirm
    	#echo "Пропущена. Exit status was $?."
fi
