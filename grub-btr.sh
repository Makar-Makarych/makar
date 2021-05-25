#!/bin/bash
loadkeys ru
setfont cyr-sun16

#-----------  Создадим загрузочный RAM диск

mkinitcpio -p linux

#-------------  Загрузчик

pacman -Syy
pacman -S grub efibootmgr --noconfirm 
grub-install --target=x86_64-efi --efi-directory=/boot/efi --bootloader-id=grub
grub-mkconfig -o /boot/grub/grub.cfg