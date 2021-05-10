#!/bin/bash

variable=`efibootmgr  | awk '/BootOrder: / {print $2}'`
if [[ $variable ]]; then
    echo "Мы проверили Ваше железо и рекомендуем Вам выбрать 'УСТАНОВКА В EFI'."
else
    echo "Согласно Вашему железу мы Вам рекомендуем выбрать 'УСТАНОВКА В MBR'!"
fi
