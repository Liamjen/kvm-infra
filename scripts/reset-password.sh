#!/bin/bash -x

while getopts ":i:p:h" opt; do
    case ${opt} in
        h )
            echo 'example usage:'
            echo 'reset-password.sh -i /path/to/disk.img -p password'
            echo ' '
            echo 'options:'
            echo '-h,       show help'
            echo '-i,       full path to image file'
            echo '-p,       password to set it to'
            exit 0
            ;;
        i )
            IMAGE=$OPTARG
            #echo "$IMAGE"
            ;;
        p )
            PASSWORD=$OPTARG
            #echo "$PASSWORD"
            ;;
    esac
done

if [ -z "$IMAGE" ]; then
    echo "Please supply an image path"
    exit 1
elif [ -z "$PASSWORD" ]; then
    echo "Please supply a password"
    exit 1
else
#    sudo modprobe nbd max_part=8
    sudo qemu-nbd --connect=/dev/nbd0 $IMAGE
    IMAGE_NAME=`echo $IMAGE | rev | cut -d/ -f1 | rev | cut -d'.' -f1`
    sudo mkdir /mnt/$IMAGE_NAME
    sudo mount /dev/nbd0p2 /mnt/$IMAGE_NAME
    echo "Mounted disk image at /mnt/$IMAGE_NAME"
    CURRENT_PASS=`sudo cat /mnt/$IMAGE_NAME/etc/shadow | grep root | awk -F: '{print $2}'`
    NEW_PASS=`mkpasswd -m sha-512 $PASSWORD`
    out=`ls /mnt/$IMAGE_NAME/etc/shadow`
    sudo cat /mnt/$IMAGE_NAME/etc/shadow | sudo sed "s@$CURRENT_PASS@$NEW_PASS@" /mnt/$IMAGE_NAME/etc/shadow > /mnt/$IMAGE_NAME/etc/new_shadow
    sudo mv /mnt/$IMAGE_NAME/etc/new_shadow /mnt/$IMAGE_NAME/etc/shadow
    echo "Password changed"
    sudo umount /mnt/$IMAGE_NAME
    sudo qemu-nbd --disconnect /dev/nbd0
    sudo rm -rf /mnt/$IMAGE_NAME
    exit 0
fi
