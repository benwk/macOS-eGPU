#!/bin/bash
#   cudaResidueUninstall.sh
#
#   This script handles CUDA uninstallation of forgotten files.
#
#   Created by learex on 07.04.18.
#
#   Authors: learex
#   Homepage: https://github.com/learex/macOS-eGPU

#   beginning of script

list="/Developer/NVIDIA/\n/usr/local/cuda"
list="$(echo -e $list)"
uninstalled=false
while read -r file
do
    if [ -e "$file" ]
    then
        uninstalled=true
        sudo rm -r -f -v "$file"
    fi
done <<< "$list"
if "$uninstalled"
then
    exit 0
else
    exit 1
fi

#   end of script
