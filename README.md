# makar

Данный скрипт проверяет ваш компьютер и предлагает установить Arch Linux в системе UEFI или Legacy в разделы с Btrfs (GPT) или Ext4 (MBR) по выбору. Так же предлагается установить ндно графических окружений. Графические окружения ставятся по дефолту. 

При установке на BtrFS в UEFI рекомендуется создать таблицу разделов в GPT и создать следующие разделы :

1. BOOT - тип Boot EFI
2. SWAP - тип Раздел подкачки
3. ROOT - тип Файловая система Линукс

На разделе ROOT впоследствии будут созданы субволумы

1. /@ 
2. /@HOME
3. /@CACHE
4. /@SNAPSHOTS

В дальнейшем при установке будет несколько запросов пароля (установленного ранее)

УСТАНОВКА :

После загрузки образа вводим команды :

1.  pacman -Sy wget
2.  wget git.io/t-archinst.sh
3.  sh t-archinst.sh
