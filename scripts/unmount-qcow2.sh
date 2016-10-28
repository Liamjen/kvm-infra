#!/bin/bash

while getopts ":n:h" opt; do
    case ${opt} in
        h )
            echo 'example usage:'
            echo 'unmount-qcow2.sh -n ubuntu-4e'
            echo ' '
            echo 'options:'
            echo '-h,     show help'
            echo '-n,     name of the disk you mounted'
            exit 0
            ;;
        n ) 
            NAME=$OPTARG
            ;;
    esac    
done

if [ -z "$NAME" ]; then
    echo "Please supply the name of the disk"
else
    sudo qemu-nbd --disconnect /dev/nbd0
    sudo umount /mnt/$NAME
    sudo rm -rf /mnt/$NAME
fi
