#!/bin/bash
loadkeys ru
setfont cyr-sun16

sh d-user.sh       #-------  Раскладка, пользователь, врем. зона, виртуалка или реальная
sh -c "$(curl -fsSL https://raw.githubusercontent.com/Makar-Makarych/makar/main/d-user.sh)"

sh grub-btr.sh     #-------  Установка загрузчика
sh -c "$(curl -fsSL https://raw.githubusercontent.com/Makar-Makarych/makar/main/grub-btr.sh)"

sh d-de.sh         #-------  Установка окружения
sh -c "$(curl -fsSL https://raw.githubusercontent.com/Makar-Makarych/makar/main/d-de.sh)" 
d-de.sh
sh d-end.sh        #-------  YAY, Pamac, Шрифты, Звук, Сеть
sh -c "$(curl -fsSL https://raw.githubusercontent.com/Makar-Makarych/makar/main/d-end.sh)"