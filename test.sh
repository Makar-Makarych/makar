#!/bin/bash
loadkeys ru
setfont cyr-sun16

## https://ipapi.co/timezone | http://ip-api.com/line?fields=timezone | https://ipwhois.app/line/?objects=timezone

time_zone=$(curl -s https://ipinfo.io/timezone)

#time_zone=$(curl -s https://ipapi.co/timezone)

#time_zone=$(curl -s http://ip-api.com/line?fields=timezone)

#time_zone=$(curl -s https://ipwhois.app/line/?objects=timezone)


#timedatectl set-timezone $time_zone
echo " ВЫВОД : "
echo " "
echo $time_zone
