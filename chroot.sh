#!/usr/bin/env sh

# NOTE: you *will* want change these lines...
export HOSTNAME=host
export USER=server
export PASS=password
export TIMEZONE=Europe/Oslo

# variable from bootstrap.sh
export ROOT_PART=$1

# locale
sed -i 's/^#\(en_US\|zh_TW\)\(\.UTF-8\)/\1\2/g' /etc/locale.gen
locale-gen
echo "LANG=en_US.UTF-8" > /etc/locale.conf

# timezone and time sync
ln -sf /usr/share/zoneinfo/${TIMEZONE} /etc/localtime
hwclock --systohc
systemctl enable systemd-timesyncd


timedatectl set-ntp true


# hostname
echo $HOSTNAME > /etc/hostname
echo -e '127.0.0.1\tlocalhost' >>/etc/hosts
echo -e '::1\tlocalhost' >>/etc/hosts
echo -e "127.0.1.1\t$HOSTNAME.localdomain\t$HOSTNAME" >>/etc/hosts

# enable multilib
sed -i "/\[multilib\]/,/Include/"'s/^#//' /etc/pacman.conf


systemctl enable bluetooth
systemctl enable polkit

cpu_vendor=$(lscpu | grep Vendor | awk -F ': +' '{print $2}')
if [[ $cpu_vendor == "GenuineIntel" ]]; then
	pacman -S intel-ucode
fi

if [[ $cpu_vendor == "AuthenticAMD" ]]; then
	pacman -S amd-ucode
fi

# sudo
sed -i 's/# \(%wheel ALL=(ALL) ALL\)/\1/' /etc/sudoers



useradd -mG wheel,storage,power,video,audio $USER
echo "$USER:$PASS" | chpasswd
# disable root login
passwd -l root