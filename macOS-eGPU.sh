#!/bin/bash

#   macOS-eGPU.sh
#
#   This script handles installation, updating and uninstallation of eGPU support for Mac.
#
#   Created by learex on 05.04.18.
#
#   Authors: learex
#   Homepage: https://github.com/learex/macOS-eGPU
#   License: https://github.com/learex/macOS-eGPU/blob/master/License.txt
#
#   USAGE TERMS of macOS-eGPU.sh
#   1. You may use this script for personal use.
#   2. You may continue development of this script at it's GitHub homepage.
#   3. You may not redistribute this script from outside of it's GitHub homepage.
#   4. You may not use this script, or portions thereof, for any commercial purposes.
#   5. You accept the license terms of all downloaded and/or executed content, even content that has not been downloaded and/or executed by macOS-eGPU.sh directly.
#
#   THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
#   IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
#   FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
#   AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
#   LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
#   OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
#   THE SOFTWARE.
#
#
#   To look up the usage of this script please see https://github.com/learex/macOS-eGPU




#   beginning of the script

#   Subroutine A: Preparations ##############################################################################################################
##  Subroutine A1: Basic preparations
#   create some space
echo
echo
echo "macOS-eGPU.sh has been started..."


#   paths
##  script specific information
branch="macOS10134"
warningOS="10.13.5"

gitPath="https://raw.githubusercontent.com/learex/macOS-eGPU/""$branch"

##  static download paths
### enabler paths
enabler1012ScriptOnline="https://raw.githubusercontent.com/goalque/automate-eGPU/master/automate-eGPU.sh"
enabler1013ListOnline="$gitPath""/Data/eGPUenabler1013.plist"
### NVIDIA driver paths
nvidiaDriverListOnline="https://gfe.nvidia.com/mac-update"
### CUDA driver paths
cudaDriverListOnline="$gitPath""/Data/cudaDriver.plist"
cudaToolkitListOnline="$gitPath""/Data/cudaToolkit.plist"
cudaAppListOnline="$gitPath""/Data/cudaApps.plist"
cudaDriverWebsite="http://www.nvidia.com/object/cuda-mac-driver.html"
cudaToolkitWebsite="https://developer.nvidia.com/cuda-downloads?target_os=MacOSX&target_arch=x86_64&target_version=1013&target_type=dmglocal"
### Thunderbolt 1/2 support path
tbEnabler1013ScriptOnline="https://raw.githubusercontent.com/mayankk2308/purge-wrangler/master/purge-wrangler.sh"

##  static system paths
### external functions
pbuddy="/usr/libexec/PlistBuddy"
closeAppScriptOnline="$gitPath""/Subroutines/closeApps.scpt"

##  static version paths
### NVIDIA driver version
nvidiaDriverVersionPath="/Library/Extensions/NVDAStartupWeb.kext/Contents/Info.plist"
### 10.13 enabler version
enabler1013VersionPath="/Library/Extensions/NVDAEGPUSupport.kext/Contents/Info.plist"
### CUDA path
cudaVersionPath="/usr/local/cuda/version.txt"
cudaDriverVersionPath="/Library/Frameworks/CUDA.framework/Versions/A/Resources/Info.plist"

##  static installation paths
###CUDA paths
cudaDriverVolPath="/Volumes/CUDADriver/"
cudaDriverPKGName="CUDADriver.pkg"
cudaToolkitVolPath="/Volumes/CUDAMacOSXInstaller/"
cudaToolkitPKGName="CUDAMacOSXInstaller.app/Contents/MacOS/CUDAMacOSXInstaller"

##  static uninstallation paths
### NVIDIA driver paths
nvidiaDriverUnInstallPKG="/Library/PreferencePanes/NVIDIA Driver Manager.prefPane/Contents/MacOS/NVIDIA Web Driver Uninstaller.app/Contents/Resources/NVUninstall.pkg"
### CUDA paths
cudaUnInstallScriptOnline="$gitPath""/Subroutines/cudaUninstall.sh"
cudaDeveloperDriverUnInstallScript="/usr/local/bin/uninstall_cuda_drv.pl"
cudaDriver1="/Library/Frameworks/CUDA.framework"
cudaDriver2="/Library/LaunchAgents/com.nvidia.CUDASoftwareUpdate.plist"
cudaDriver3="/Library/PreferencePanes/CUDA Preferences.prefPane"
cudaDriver4="/Library/Extensions/CUDA.kext"
### 10.12 enabler
enabler1012g1="/Library/Application Support/Automate-eGPU/"
enabler1012g2="/usr/local/bin/automate-eGPU.sh"
enabler1012r1="/Applications/Uninstall Rastafabi's eGPU Enabler.app"
enabler1012rUnInstallScriptOnline="$gitPath""/Subroutines/rastafabiUninstall.sh"

##  script finish behavior
scheduleReboot=false
doneSomething=false
listOfChanges="A list of what has been done:\n"

##  script parameter (flags)
### script parameter #Standard
install=false
uninstall=false
update=false
### script parameter #Packages
enabler=false
tEnabler=false
driver=false
cuda=0
### script parameter #Check
check=false
### script parameter #Advanced
reinstall=false
autoUpdate=false
noReboot=true
minimal=false
forceNew="stable"

##  internal rules
determine=false
customDriver=false
foundMatch=false
exitScript=false

##  wait times
waitTime=7
priorWaitTime=5

##  OS info
os=""
build=""
statSIP=128


#  temporary directory handling
dirName="$(uuidgen)"
dirName="$TMPDIR""macOS.eGPU.""$dirName"

## tmpdir creator
function mktmpdir {
    if ! [ -d "$dirName" ]
    then
        mkdir "$dirName"
    fi
}

##  tmpdir destructor
function cleantmpdir {
    if [ -d "$dirName" ]
    then
        rm -rf "$dirName"
    fi
}

#   DMG detachment
function dmgDetatch {
    if [ -d "$cudaDriverVolPath" ]
    then
        hdiutil detach "$cudaDriverVolPath"
    fi
    if [ -d "$cudaToolkitVolPath" ]
    then
        hdiutil detach "$cudaToolkitVolPath"
    fi
}

#   quit all running apps
function quitAllApps {
    echo "Wating until all apps are closed..."
    osascript <(curl -s "$closeAppScriptOnline")
}

#   finish handling
##  print all changes made to the system
function printChanges {
    echo
    echo
    echo -e "$listOfChanges"
}

##  print info about tweaking
function printTweaks {
    echo
    echo
    echo "Should the system not work see possible tweaks on the GitHub repository:"
    echo "https://github.com/learex/macOS-eGPU#tweaks"
}

##  wait handler
function waiter {
    if [ "$1" == 1 ]
    then
        echo "The system will reboot in 1 second ..."
    elif [ "$1" == 0 ]
    then
        echo "The system will reboot now ..."
    else
        echo "The system will reboot in $1 seconds ..."
    fi
    sleep "$1"
}

##  reboot handler
function rebootSystem {
    dmgDetatch
    cleantmpdir
    echo
    if ! "$scheduleReboot"
    then
        echo
        exit
    elif "$noReboot"
    then
        echo "A reboot of the system is recommended."
    else
        waiter "waitTime"
        sudo reboot
    fi
    echo
    exit
}

##  script interruption handler
function irupt {
    dmgDetatch
    cleantmpdir
    echo
    echo "The script has failed."
    if "$doneSomething"
    then
        printChanges
    else
        echo "Nothing has been changed."
    fi
    echo
    exit 1
}

##  manual script interruption
function trapIrupt {
    if ! "$exitScript"
    then
        exitScript=true
        echo "You pressed ^C. Exiting the script during execution might render your system in an unreparable state."
        echo "Recommendation: Let the script finish and then run again with uninstall parameter."
        echo "Press again to force quit."
    else
        irupt
    fi
}

trap trapIrupt INT
quitAllApps
#   Subroutine B: NIVIDA drivers ##############################################################################################################
#   Subroutine B1: check NVIDIA driver installation
function checkNvidiaDriverInstallation {

}
























