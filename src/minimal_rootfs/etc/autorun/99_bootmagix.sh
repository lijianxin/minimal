#!/bin/sh

echo "bootmagix ..."
ls /dev/sd*
mkdir /mnt

echo "mount device ..."
mount /dev/sda1 /mnt

echo "fix fstab ..."
cat /mnt/etc/fstab
cp /mnt/etc/fstab /mnt/etc/fstab.bootmagix
sed -i 's|/dev/vda1|/dev/sda1|g' /mnt/etc/fstab

echo "fix grub2 ..."
cat /mnt/boot/grub2/grub.cfg
cp /mnt/boot/grub2/grub.cfg /mnt/boot/grub2/grub.cfg.bootmagix
sed -i 's|/dev/vda1|/dev/sda1|g' /mnt/boot/grub2/grub.cfg

echo "poweroff ..."
poweroff
