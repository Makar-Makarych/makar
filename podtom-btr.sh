#!/bin/bash
loadkeys ru
setfont cyr-sun16

#####создадим подтома под root и домашний каталог пользователя и для снапшотов:

  btrfs subvolume create /mnt/@
  btrfs subvolume create /mnt/@home
  btrfs subvolume create /mnt/@snapshots
  btrfs subvolume create /mnt/@cache
  umount /mnt
  mount -o noatime,compress=lzo,space_cache,subvol=@ /dev/$root /mnt
  mkdir -p /mnt/{home,boot,boot/efi,var,var/cache,.snapshots}
  mount -o noatime,compress=lzo,space_cache,subvol=@cache /dev/sda3 /mnt/var/cache
  mount -o noatime,compress=lzo,space_cache,subvol=@home /dev/sda3 /mnt/home
  mount -o noatime,compress=lzo,space_cache,subvol=@snapshots /dev/sda3 /mnt/.snapshots
  mount /dev/$bootd /mnt/boot/efi