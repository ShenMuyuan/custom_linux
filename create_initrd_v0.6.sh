#!/bin/bash

. utils/add_commands.sh
# . utils/add_modules.sh

rm -rf myinitrd_v0_55
mkdir myinitrd_v0_55
cd myinitrd_v0_55 || exit

# make directories
mkdir -p usr/bin usr/sbin usr/lib usr/lib64
ln -s usr/bin bin
ln -s usr/sbin sbin
ln -s usr/lib lib
ln -s usr/lib64 lib64

# add essential commands
add_commands bash insmod ls lvm mkdir mount mknod lsblk ln

# add essential modules
cp ../../dev/kernel/linux-6.3.6/drivers/usb/host/xhci-pci.ko .
cp ../../dev/kernel/linux-6.3.6/drivers/usb/host/xhci-pci-renesas.ko .

# write init script
touch init
tee init <<EOF
#!/bin/bash
export PATH=/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin

[ -d /dev ] || mkdir -m 0755 /dev
[ -d /root ] || mkdir -m 0700 /root
[ -d /sys ] || mkdir /sys
[ -d /proc ] || mkdir /proc
[ -d /tmp ] || mkdir /tmp

mkdir -p /var/lock
mount -t sysfs -o nodev,noexec,nosuid sysfs /sys
mount -t proc -o nodev,noexec,nosuid proc /proc

# make nodes
mknod /dev/nvme0n1 b 259 0
mknod /dev/nvme0n1p1 b 259 1
mknod /dev/nvme0n1p2 b 259 2
mknod /dev/nvme0n1p3 b 259 3
mkdir -p /dev/ubuntu-vg
mknod /dev/dm-0 b 253 0
ln -s /dev/dm-0 /dev/ubuntu-vg/ubuntu-lv

# prepare lvm
lvm vgchange -a y

# mount lvm logical volume to /mnt/my_root
mkdir -m 0755 -p /mnt/my_root
mount -t ext4 /dev/ubuntu-vg/ubuntu-lv /mnt/my_root

# keyboard related
insmod xhci-pci-renesas.ko
insmod xhci-pci.ko

/bin/bash
EOF
chmod 755 init

# generate initrd
find . -print0 | cpio --null -ov --format=newc | gzip --best > /boot/smy_initrd.gz
