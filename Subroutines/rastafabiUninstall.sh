#!/bin/bash
#   rastafabiUninstall.sh
#
#   This script handles uninstallation of rastafabi's eGPU enabler on macOS Sierra.
#
#   Created by learex on 07.04.18.
#
#   Authors: learex
#   Homepage: https://github.com/learex/macOS-eGPU

#   beginning of script

list="/Applications/Uninstall Rastafabi's eGPU Enabler.app\n/Library/Extensions/eGPU.kext\n/Library/Application Support/fpsoft\n/Library/LaunchAgents/com.fpsoft.eGPU_iMac_5k_Fix.plist\n/Library/LaunchAgents/com.fpsoft.eGPU_delay_Thunderbolt.plist"
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
