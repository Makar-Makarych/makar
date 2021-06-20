# makar

Данный скрипт проверяет ваш компьютер и предлагает установить Arch Linux в системе UEFI или Legacy в разделы с Btrfs (GPT) или Ext4 (MBR) по выбору. Так же предлагается установить одно из графических окружений. Графические окружения ставятся по дефолту. 

   После загрузки образа вводим команду :

1. curl -LO git.io/starch.sh && sh starch.sh


   При установке на BtrFS в UEFI рекомендуется создать таблицу разделов в GPT и создать следующие разделы : BOOT ( EFI System ) и ROOT ( Linux filesystem ). Создание раздела SWAP на Ваше усмотрение . На разделе ROOT впоследствии будут созданы субволумы : @ , @HOME , @CACHE и @SNAPSHOTS .

   При установке на Ext4 в UEFI рекомендуется создать таблицу разделов в GPT и создать следующие разделы : BOOT ( EFI System ) и ROOT ( Linux filesystem ) . Разделы SWAP и HOME Вы можете создавать или не создавать по своему желанию, а так же монтировать их , если они уже созданы ранее .
   
   При установке на BtrFS в Legacy (MBR) Вы можете создать таблицу разделов в GPT или MBR . Разделы BOOT и SWAP создаются по Вашему желанию . На разделе ROOT впоследствии будут созданы субволумы : @ , @HOME , @CACHE и @SNAPSHOTS .
   
   При установке на Ext4 в Legacy (MBR) Вы можете создать таблицу разделов в GPT или MBR . Разделы BOOT , HOME и SWAP создаются по Вашему желанию .
      
В дальнейшем при установке нужно будет несколько раз подтвердить выбор, нажав Enter и/или ввести ранее установленный пароль. При установке в Legacy (MBR) в конце установки нужно будет указать диск, на который будет установлен GRUB .


    Fork it!
    Create your feature branch (git checkout -b my-new-feature)
    Commit your changes (git commit -am 'Add some feature')
    Push to the branch (git push origin my-new-feature)
    Create new Pull Request!

--------------------------------------------------

   Поддержать чашечкой Кофе :

$ https://www.donationalerts.com/r/makar_makarych
