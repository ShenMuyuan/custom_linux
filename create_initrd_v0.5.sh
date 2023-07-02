#!/bin/bash

. utils/add_commands.sh
# . utils/add_modules.sh

rm -rf myinitrd_v0_5
mkdir myinitrd_v0_5
cd myinitrd_v0_5 || exit

# make directories
mkdir -p usr/bin usr/sbin usr/lib usr/lib64
ln -s usr/bin bin
ln -s usr/sbin sbin
ln -s usr/lib lib
ln -s usr/lib64 lib64

# add essential commands
add_commands bash insmod

# add essential modules
cp ../../dev/kernel/linux-6.3.6/drivers/usb/host/xhci-pci.ko .
cp ../../dev/kernel/linux-6.3.6/drivers/usb/host/xhci-pci-renesas.ko .

# write init script
touch init
tee init <<EOF
#!/bin/bash
insmod xhci-pci-renesas.ko
insmod xhci-pci.ko
/bin/bash
EOF
chmod 755 init

# generate initrd
find . -print0 | cpio --null -ov --format=newc | gzip --best > /boot/smy_initrd.gz
