#!/bin/bash
loadkeys ru
setfont cyr-sun16

#sh dialog-razmetka.sh  #-----------  Разметка
sh -c "$(curl -fsSL https://raw.githubusercontent.com/Makar-Makarych/makar/main/dialog-razmetka.sh)"

#sh d-root-btr.sh       #-----------  Рут раздел . Формат и монтирование
sh -c "$(curl -fsSL https://raw.githubusercontent.com/Makar-Makarych/makar/main/d-root-btr.sh)"


#sh d-boot-btr.sh       #----------- Загрузочный  раздел . Формат и монтирование
sh -c "$(curl -fsSL https://raw.githubusercontent.com/Makar-Makarych/makar/main/d-boot-btr.sh)"


#sh d-swap.sh           #----------- Своп . Создание и подключение
sh -c "$(curl -fsSL https://raw.githubusercontent.com/Makar-Makarych/makar/main/d-swap.sh)"


	#mount /dev/$root /mnt      #------------   Монтируем корень

#sh podtom-btr.sh           #-----------  Создаем субволумы
sh -c "$(curl -fsSL https://raw.githubusercontent.com/Makar-Makarych/makar/main/podtom-btr.sh)"


#sh zerkalo.sh          #-----------  Обновляем зеркала
sh -c "$(curl -fsSL https://raw.githubusercontent.com/Makar-Makarych/makar/main/zerkalo.sh)"



######################  Установка базы      ################################### 

pacstrap /mnt base base-devel linux linux-firmware nano dhcpcd netctl linux-headers which inetutils wget wpa_supplicant dialog

genfstab -pU /mnt >> /mnt/etc/fstab



#############################################################
# arch-chroot /mnt sh -c "$(curl -fsSL git.io/arch2.sh)" # Продолжение установки по скрипту Бойко
##############################################################

arch-chroot /mnt sh -c "$(curl -fsSL https://raw.githubusercontent.com/Makar-Makarych/makar/main/t-efi-btr3.sh)"

# Файл uefi_btrfs_chroot

# sh t-efi-btr3.sh
