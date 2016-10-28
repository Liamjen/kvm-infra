#!/bin/bash

sudo qemu-img create -f qcow2 /$1/$2.img 250G &&
sudo virt-install \
 --name $2 \
 --boot uefi \
 --machine q35 \
 --ram 16384 \
 --vcpus 2 \
 --disk path=/$1/$2.img,format=qcow2 \
 --location http://ftp.ubuntu.com/ubuntu/dists/trusty/main/installer-amd64 \
 --graphics none \
 --noautoconsole \
 -x "
    preseed/url=http://104.131.132.168/preseed.cfg
    console=ttyS0
    locale=en_US
    console-keymaps-at/keymap=us
    console-setup/ask_detect=false
    console-setup/layoutcode=us
    keyboard-configuration/layout=USA
    keyboard-configuration/variant=USA
    hostname=$2
    "
