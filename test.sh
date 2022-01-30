#!/bin/bash
loadkeys ru
setfont cyr-sun16

username="user"
hostname="VIRTUAL"
pass='123'


echo '>> Имя компьютера '$hostname
echo $hostname > /etc/hostname
echo -e '127.0.0.1 localhost\n::1 localhost\n' > /etc/hosts

# Настройка администратора и создание пользователя $username
echo '>> Пароль root'
(
	echo $pass
	echo $pass
) | passwd
useradd -G wheel -s /bin/bash -m $username
echo '>> Пароль пользователя '$username
(
	echo $pass
	echo $pass
) | passwd $username


