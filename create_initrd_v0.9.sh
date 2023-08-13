#!/bin/bash

. utils/add_commands.sh
. utils/add_modules.sh
. utils/add_libraries.sh

rm -rf myinitrd_v0_9
mkdir myinitrd_v0_9
cd myinitrd_v0_9 || exit

# make directories
mkdir -p usr/bin usr/sbin usr/lib usr/lib64
ln -s usr/bin bin
ln -s usr/sbin sbin
ln -s usr/lib lib
ln -s usr/lib64 lib64
mkdir lib/systemd
cp /lib/systemd/systemd-udevd lib/systemd   # symlink to udevadm
mkdir lib/udev/
cp -r /lib/udev/rules.d lib/udev/

# add essential commands
add_commands bash insmod ls lvm mkdir mount mknod lsblk ln \
    udevadm dmsetup modprobe lsmod /lib/systemd/systemd systemctl \
    login passwd useradd userdel chown cat agetty chpasswd sudo \
    pwconv pwunconv touch usermod getty groups echo chmod

# support login
mkdir -m 0755 etc
cp /etc/passwd etc
cp /etc/shadow etc
cp /etc/group etc
cp /etc/sudo.conf etc
cp /etc/sudoers etc
cp -r /etc/sudoers.d etc
cp /etc/hosts etc
cp /etc/profile etc
mkdir -p etc/pam.d
cp -r /etc/pam.d/* etc/pam.d
cp /etc/nsswitch.conf etc
cp /etc/pam.conf etc/
cp -r /etc/security/ etc/
cp /etc/login.defs etc
mkdir -p usr/libexec
cp -r /usr/libexec/sudo/ usr/libexec
cp /etc/localtime etc
cp -r /usr/lib/pam.d usr/lib
cp /etc/shells etc
cp -r /etc/selinux etc
add_libraries /usr/lib/aarch64-linux-gnu/security/* /usr/lib/aarch64-linux-gnu/nss/*.so /usr/lib/aarch64-linux-gnu/libnss* /usr/lib/aarch64-linux-gnu/libfreebl*
add_libraries /lib/aarch64-linux-gnu/libz.so.1
add_libraries /lib/aarch64-linux-gnu/libnsl.so.2

# support network (can ping local & remote)
add_commands ip route ping ifconfig
cp /etc/protocols etc

# support ssh
add_commands ssh

# support sshd
add_commands sshd pidof tput expr grep
add_file /etc/ssh/sshd_config
add_file /etc/init.d/ssh
add_file /etc/default/ssh
add_file /lib/lsb/init-functions
add_file /usr/sbin/service
add_commands sh basename journalctl
add_commands dbus-daemon
add_file /usr/share/dbus-1/{system.conf,system-services/*,system.d/*,session.conf}
add_commands cron su
add_file /etc/crontab
add_commands ssh-keygen

# prepare for systemd
mkdir -p lib/systemd
cp -r /lib/systemd/* lib/systemd/

# prepare for modprobe
mkdir -p lib/modules/"$my_kernel_version"
add_modules nvme nvme-core
cp /lib/modules/"$my_kernel_version"/modules.dep lib/modules/"$my_kernel_version"
cp /lib/modules/"$my_kernel_version"/modules.dep.bin lib/modules/"$my_kernel_version"
mkdir -p etc/modprobe.d
touch etc/modprobe.d/aliases.conf
tee etc/modprobe.d/aliases.conf > /dev/null <<EOF
alias pci:v*d*sv*sd*bc01sc08i02* nvme
alias pci:v0000106Bd00002005sv*sd*bc*sc*i* nvme
alias pci:v0000106Bd00002003sv*sd*bc*sc*i* nvme
alias pci:v0000106Bd00002001sv*sd*bc*sc*i* nvme
alias pci:v00001D0Fd0000CD02sv*sd*bc*sc*i* nvme
alias pci:v00001D0Fd0000CD01sv*sd*bc*sc*i* nvme
alias pci:v00001D0Fd0000CD00sv*sd*bc*sc*i* nvme
alias pci:v00001D0Fd00008061sv*sd*bc*sc*i* nvme
alias pci:v00001D0Fd00000065sv*sd*bc*sc*i* nvme
alias pci:v00001D0Fd00000061sv*sd*bc*sc*i* nvme
alias pci:v00001E4Bd00001202sv*sd*bc*sc*i* nvme
alias pci:v00001E4Bd00001002sv*sd*bc*sc*i* nvme
alias pci:v00001E4Bd00001001sv*sd*bc*sc*i* nvme
alias pci:v00001F40d00005236sv*sd*bc*sc*i* nvme
alias pci:v00002646d0000501Esv*sd*bc*sc*i* nvme
alias pci:v00002646d0000501Bsv*sd*bc*sc*i* nvme
alias pci:v00002646d0000501Asv*sd*bc*sc*i* nvme
alias pci:v00002646d00005016sv*sd*bc*sc*i* nvme
alias pci:v00002646d00005018sv*sd*bc*sc*i* nvme
alias pci:v00002646d00002263sv*sd*bc*sc*i* nvme
alias pci:v00002646d00002262sv*sd*bc*sc*i* nvme
alias pci:v00001D97d00002263sv*sd*bc*sc*i* nvme
alias pci:v000015B7d00002001sv*sd*bc*sc*i* nvme
alias pci:v00001C5Cd00001504sv*sd*bc*sc*i* nvme
alias pci:v00001344d00006001sv*sd*bc*sc*i* nvme
alias pci:v00001344d00005407sv*sd*bc*sc*i* nvme
alias pci:v00001CC1d00008201sv*sd*bc*sc*i* nvme
alias pci:v000010ECd00005762sv*sd*bc*sc*i* nvme
alias pci:v00001CC1d000033F8sv*sd*bc*sc*i* nvme
alias pci:v00001B4Bd00001092sv*sd*bc*sc*i* nvme
alias pci:v00001987d00005016sv*sd*bc*sc*i* nvme
alias pci:v0000144Dd0000A822sv*sd*bc*sc*i* nvme
alias pci:v0000144Dd0000A821sv*sd*bc*sc*i* nvme
alias pci:v00001C5Fd00000540sv*sd*bc*sc*i* nvme
alias pci:v00001C58d00000023sv*sd*bc*sc*i* nvme
alias pci:v00001C58d00000003sv*sd*bc*sc*i* nvme
alias pci:v00001BB1d00000100sv*sd*bc*sc*i* nvme
alias pci:v0000126Fd00002263sv*sd*bc*sc*i* nvme
alias pci:v00001B36d00000010sv*sd*bc*sc*i* nvme
alias pci:v00008086d00005845sv*sd*bc*sc*i* nvme
alias pci:v00008086d0000F1A6sv*sd*bc*sc*i* nvme
alias pci:v00008086d0000F1A5sv*sd*bc*sc*i* nvme
alias pci:v00008086d00000A55sv*sd*bc*sc*i* nvme
alias pci:v00008086d00000A54sv*sd*bc*sc*i* nvme
alias pci:v00008086d00000A53sv*sd*bc*sc*i* nvme
alias pci:v00008086d00000953sv*sd*bc*sc*i* nvme
EOF

# write init script
touch init
tee init > /dev/null <<EOF
#!/bin/bash
export PATH=/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin

[ -d /dev ] || mkdir -m 0755 /dev
[ -d /root ] || mkdir -m 0700 /root
[ -d /sys ] || mkdir /sys
[ -d /proc ] || mkdir /proc
[ -d /tmp ] || mkdir /tmp
[ -d /var ] || mkdir /var
[ -d /run ] || mkdir /run

# for cron
ln -s /run /var/run
mkdir -m 0755 /var/spool
mkdir -m 0755 /etc/cron.d

mount -t sysfs -o nodev,noexec,nosuid sysfs /sys
mount -t proc -o nodev,noexec,nosuid proc /proc
mount -t tmpfs -o nodev,noexec,nosuid tmpfs /run

# init udev
mount -t devtmpfs -o nosuid,mode=0755 udev /dev
SYSTEMD_LOG_LEVEL=info /lib/systemd/systemd-udevd --daemon --resolve-names=never
udevadm trigger --type=subsystems --action=add
udevadm trigger --type=devices --action=add
udevadm settle || true

# mount lvm logical volume to /mnt/my_root
mkdir -m 0755 -p /mnt/my_root
mount -t ext4 /dev/ubuntu-vg/ubuntu-lv /mnt/my_root

# exec /bin/bash

mkdir -m 0755 /home
useradd -m -d /home/diangroup -s /bin/bash diangroup
echo diangroup:diangroup | chpasswd
usermod -aG sudo diangroup
touch /home/diangroup/.profile
echo "export PS1=\"\u@\h:\W \$ \"" >> /home/diangroup/.profile
echo "export PATH=\"/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin:\$PATH\"" >> /home/diangroup/.profile
touch /etc/hostname
echo "SMY-Linux" >> /etc/hostname
echo "127.0.0.1 SMY-Linux" >> /etc/hosts
chown root:root /usr/bin/sudo && chmod 4755 /usr/bin/sudo

# for ip
ip link set enp2s0 up
ip addr add 172.16.49.130/24 dev enp2s0
route add default gw 172.16.49.2

# for ssh key
ssh-keygen -q -N "" -t dsa -f /etc/ssh/ssh_host_dsa_key
ssh-keygen -q -N "" -t rsa -b 4096 -f /etc/ssh/ssh_host_rsa_key
ssh-keygen -q -N "" -t ecdsa -f /etc/ssh/ssh_host_ecdsa_key
ssh-keygen -q -N "" -t ed25519 -f /etc/ssh/ssh_host_ed25519_key

# let systemd have PID 1
exec /lib/systemd/systemd
EOF
chmod 755 init

# generate initrd
echo "Generating initrd... Destination is /boot/smy_initrd.gz"
find . -print0 | cpio --null -o --format=newc | gzip --best > /boot/smy_initrd.gz
