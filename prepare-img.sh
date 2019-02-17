#!/bin/sh

mkdir -p /tmp/rpi
mount /dev/mmcblk0p1 /tmp/rpi
cp -f kernel.img /tmp/rpi/
umount /tmp/rpi
