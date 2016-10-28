#!/bin/bash

#configfile=/etc/vfio-pci01.cfg

#vfiobind() {
#    dev="$1"
#        vendor=$(cat /sys/bus/pci_express/devices/$dev/vendor)
#        device=$(cat /sys/bus/pci_express/devices/$dev/device)
#        if [ -e /sys/bus/pci_express/devices/$dev/driver ]; then
#                echo $dev > /sys/bus/pci_express/devices/$dev/driver/unbind
#        fi
#        echo $vendor $device > /sys/bus/pci_express/drivers/vfio-pci/new_id
#
#}

#modprobe vfio-pci

#cat $configfile | while read line;do
#    echo $line | grep ^# >/dev/null 2>&1 && continue
#        vfiobind $line
#done

sudo qemu-system-x86_64 -enable-kvm -m 4096 -cpu host,kvm=off \
-smp 4,sockets=1,cores=4,threads=1 \
-bios /usr/share/OVMF/OVMF_CODE.fd -vga none \
#-device ioh3420,bus=pcie.0,addr=1c.0,multifunction=on,port=1,chassis=1,id=root.1 \
#-device vfio-pci,host=4b:00.0,bus=root.1,addr=00.0,multifunction=on,x-vga=on \
#-device vfio-pci,host=4b:00.1,bus=root.1,addr=00.1 \
-drive file=/home/backprop/ubuntu-final.img,if=none,id=disk,format=raw -device ide-hd,bus=ide.0,drive=disk 
#-cdrom /home/backprop/ubuntu-14.04.4-desktop-amd64.iso
exit 0

#-cdrom /home/backprop/ubuntu-14.04.4-desktop-amd64.iso \
