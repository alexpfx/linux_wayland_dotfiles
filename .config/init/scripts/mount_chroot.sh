#!/bin/bash
sudo mount -t proc proc /mnt/proc
sudo mount -t sysfs sys /mnt/sys
sudo mount -o bind /dev /mnt/dev
sudo mount -t devpts pts /mnt/dev/pts/
sudo arch-chroot /mnt
