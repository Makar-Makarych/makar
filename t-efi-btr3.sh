#!/bin/bash
loadkeys ru
setfont cyr-sun16

sh d-user.sh       #-------  Раскладка, пользователь, врем. зона, виртуалка или реальная

sh grub-btr.sh     #-------  Установка загрузчика

sh d-de.sh         #-------  Установка окружения 

