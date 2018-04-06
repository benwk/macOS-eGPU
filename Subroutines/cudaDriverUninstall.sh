#!/bin/bash
#   cudaDriverUninstall.sh
#
#   This script handles CUDA driver uninstallation.
#
#   Created by learex on 07.04.18.
#
#   Authors: learex
#   Homepage: https://github.com/learex/macOS-eGPU

#   beginning of script

list="/usr/local/bin/.cuda_driver_uninstall_manifest_do_not_delete.txt\n/Library/Frameworks/CUDA.framework\n/Library/PreferencePanes/CUDA Preferences.prefPane\n/Library/LaunchDaemons/com.nvidia.cuda.launcher.plist\n/Library/LaunchDaemons/com.nvidia.cudad.plist\n/usr/local/bin/uninstall_cuda_drv.pl\n/usr/local/cuda/lib/libcuda.dylib\n/Library/Extensions/CUDA.kext\n/Library/LaunchAgents/com.nvidia.CUDASoftwareUpdate.plist\n/usr/local/cuda"
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
