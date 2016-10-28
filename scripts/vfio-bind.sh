#!/bin/bash

DEVLIST="0000:4b:00.0 0000:4b:00.1 0000:4c:00.0 0000:4c:00.1 0000:4d:00.0 0000:4d:00.1"

for dev in $DEVLIST
    do
        vendor=$(cat /sys/bus/pci/devices/$dev/vendor)
        device=$(cat /sys/bus/pci/devices/$dev/device)
	#echo $vendor
	#echo $device
        if [ -e /sys/bus/pci/devices/$dev/driver ]; then
	    echo $dev | sudo tee /sys/bus/pci/devices/$dev/driver/unbind
        fi

echo $vendor $device | sudo tee /sys/bus/pci/drivers/vfio-pci/new_id
sudo modprobe -i vfio-pci
done

