#!/bin/bash
loadkeys ru
setfont cyr-sun16

sh dialog-razmetka.sh  #-----------  Разметка

sh d-root-btr.sh       #-----------  Рут раздел . Формат и монтирование

sh d-boot-btr.sh       #----------- Загрузочный  раздел . Формат и монтирование

sh d-swap.sh           #----------- Своп . Создание и подключение

	#mount /dev/$root /mnt      #------------   Монтируем корень

sh podtom.sh           #-----------  Создаем субволумы

sh zerkalo.sh          #-----------  Обновляем зеркала


######################  Установка базы      ################################### 

#pacstrap /mnt base base-devel linux linux-firmware nano dhcpcd netctl linux-headers which inetutils wget wpa_supplicant dialog

#genfstab -pU /mnt >> /mnt/etc/fstab



#############################################################
# arch-chroot /mnt sh -c "$(curl -fsSL git.io/arch2.sh)" # Продолжение установки по скрипту Бойко
##############################################################

#arch-chroot /mnt sh -c "$(curl -fsSL https://raw.githubusercontent.com/Makar-Makarych/makar/main/uefi_btrfs_chroot.sh)"

# Файл uefi_btrfs_chroot

# sh t-efi-btr3.sh
