# makar

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

