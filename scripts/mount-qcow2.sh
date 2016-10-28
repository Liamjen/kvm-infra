#!/bin/bash

#sudo modprobe nbd max_part=8
#sudo qemu-nbd --connect=/dev/nbd0 /images02/$1.img
#sudo mkdir /mnt/$1
#sudo mount /dev/nbd0p$2 /mnt/$1

while getopts ":i:p:h" opt; do
    case ${opt} in
        h )
            echo 'example usage:'
            echo 'mount-qcow2.sh -i /path/to/disk.img -p 2'
            echo ' '
            echo 'options:'
            echo '-h,       show help'
            echo '-i,       full path to image file'
            echo '-p,       which parition to mount '
            echo '          1 is usually boot, 2 is usually root'
            exit 0
            ;;
        i )
            IMAGE=$OPTARG
            #echo "$IMAGE"
            ;;
        p )
            PARTITION=$OPTARG
            #echo "$PARTITION"
            ;;
    esac
done

if [ -z "$IMAGE" ]; then
    echo "Please supply an image path"
    exit 1;
elif [ -z "$PARTITION" ]; then
    echo "Please supply a parition. Hint: 1 is probably boot, 2 is probably root"
else
    sudo modprobe nbd max_part=8
    sudo qemu-nbd --connect=/dev/nbd0 $IMAGE
    IMAGE_NAME=`echo $IMAGE | rev | cut -d/ -f1 | rev | cut -d'.' -f1`
    #echo $IMAGE_NAME
    #echo $PARTITION
    sudo mkdir /mnt/$IMAGE_NAME
    sudo mount /dev/nbd0p$PARTITION /mnt/$IMAGE_NAME
    echo "Mounted disk image at /mnt/$IMAGE_NAME"
fi
