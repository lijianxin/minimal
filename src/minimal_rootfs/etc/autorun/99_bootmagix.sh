#!/bin/sh

echo "bootmagix ..."
ls /dev/sd*
mkdir /mnt

echo "mount device ..."
if [ -b "/dev/sda1" ]
then
  mount /dev/sda1 /mnt
else
  echo "/dev/sda1 not found, poweroff ..."
  poweroff
fi

echo "fix grub2 ..."
cat /mnt/boot/grub2/grub.cfg
cp /mnt/boot/grub2/grub.cfg /mnt/boot/grub2/grub.cfg.$(date +%s)
sed -i 's|/dev/vda1|/dev/sda1|g' /mnt/boot/grub2/grub.cfg

echo "fix fstab ..."
cat /mnt/etc/fstab
cp /mnt/etc/fstab /mnt/etc/fstab.$(date +%s)
devices=$(ls /dev/sd*)
for vdevice in $(awk '{print $1}' /mnt/etc/fstab)
do
  if [ ${vdevice:0:7} == "/dev/vd" ]
  then
    target="${vdevice//v/s}"
    for device in $devices
    do
      if [ -b $target ]
      then
        sed -i "s|$vdevice|$target|g" /mnt/etc/fstab
      else
        sed -i "s|$vdevice|#$vdevice|g" /mnt/etc/fstab
      fi
    done
  fi
done

echo "poweroff ..."
poweroff
