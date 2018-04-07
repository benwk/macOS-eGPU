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
#   only Subroutine A3 contains function exectution before the very end

#   create some space
echo
echo

#   Subroutine A: Preparations ##############################################################################################################
##  Subroutine A1: Basic preparations: path definition

#   paths
##  script specific information
branch="macOS10134"
warningOS="10.13.5"
gitPath="https://raw.githubusercontent.com/learex/macOS-eGPU/""$branch"

##  external functions
pbuddy="/usr/libexec/PlistBuddy"

##  static data download paths
### enabler paths
enabler1013ListOnline="$gitPath""/Data/eGPUenabler1013.plist"
### NVIDIA driver paths
nvidiaDriverListOnline="https://gfe.nvidia.com/mac-update"
### CUDA driver paths
cudaDriverListOnline="$gitPath""/Data/cudaDriver.plist"
cudaToolkitListOnline="$gitPath""/Data/cudaToolkit.plist"
cudaAppListOnline="$gitPath""/Data/cudaApps.plist"
cudaDriverWebsite="http://www.nvidia.com/object/cuda-mac-driver.html"
cudaToolkitWebsite="https://developer.nvidia.com/cuda-downloads?target_os=MacOSX&target_arch=x86_64&target_version=1013&target_type=dmglocal"

##  dynamic download paths
### placeholder


##  static installation paths
##  enabler paths
enabler1012ScriptOnline="https://raw.githubusercontent.com/goalque/automate-eGPU/master/automate-eGPU.sh"
### Thunderbolt 1/2 support path
tEnabler1013ScriptOnline="https://raw.githubusercontent.com/mayankk2308/purge-wrangler/master/purge-wrangler.sh"
### CUDA paths
cudaDriverVolPath="/Volumes/CUDADriver/"
cudaDriverPKGName="CUDADriver.pkg"
cudaToolkitVolPath="/Volumes/CUDAMacOSXInstaller/"
cudaToolkitPKGName="CUDAMacOSXInstaller.app/Contents/MacOS/CUDAMacOSXInstaller"

##  dynamic installation paths
### placeholder


##  static uninstallation paths
### NVIDIA driver paths
nvidiaDriverUnInstallPKG="/Library/PreferencePanes/NVIDIA Driver Manager.prefPane/Contents/MacOS/NVIDIA Web Driver Uninstaller.app/Contents/Resources/NVUninstall.pkg"
### CUDA paths
cudaDeveloperDriverUnInstallScript="/usr/local/bin/uninstall_cuda_drv.pl"

##  dynamic uninstallation paths
### CUDA paths
cudaToolkitUnInstallDir=""
cudaToolkitUnInstallScriptName=""
cudaToolkitUnInstallScript=""


##  static test paths
### CUDA paths
cudaDriver1="/Library/Frameworks/CUDA.framework"
cudaDriver2="/Library/LaunchAgents/com.nvidia.CUDASoftwareUpdate.plist"
cudaDriver3="/Library/PreferencePanes/CUDA Preferences.prefPane"
cudaDriver4="/Library/Extensions/CUDA.kext"
cudaDeveloperDir="/Developer/NVIDIA/"
### 10.12 enabler
enabler1012g1="/Library/Application Support/Automate-eGPU/"
enabler1012g2="/usr/local/bin/automate-eGPU.sh"
enabler1012r1="/Applications/Uninstall Rastafabi's eGPU Enabler.app"
### 10.13 enabler
enabler1013="/Library/Extensions/NVDAEGPUSupport.kext"
### unlock thunderbolt enabler
tEnabler10131="/Library/Application Support/Purge-Wrangler/manifest.wglr"
tEnabler10132="/System/Library/Extensions/AppleGraphicsControl.kext/Contents/PlugIns/AppleGPUWrangler.kext/Contents/MacOS/AppleGPUWrangler"

##  dynamic test paths
### CUDA paths
cudaSamplesDir=""


##  static version paths
### NVIDIA driver version
nvidiaDriverVersionPath="/Library/Extensions/NVDAStartupWeb.kext/Contents/Info.plist"
### 10.13 enabler version
enabler1013VersionPath="/Library/Extensions/NVDAEGPUSupport.kext/Contents/Info.plist"
### CUDA path
cudaVersionPath="/usr/local/cuda/version.txt"
cudaDriverVersionPath="/Library/Frameworks/CUDA.framework/Versions/A/Resources/Info.plist"


##  script parameter (flags)
### script parameter #Standard
install=false
uninstall=false
update=false
### script parameter #Packages
enabler=false
tEnabler=false
driver=false
nvidiaDriverDownloadVersion=""
cuda=0
### script parameter #Check
check=false
### script parameter #Advanced
reinstall=false
autoUpdate=false
noReboot=false
minimal=false
forceNewest=false

##  internal rules
determine=false
customDriver=false
foundMatch=false
exitScript=false

##  script finish behavior
scheduleReboot=false
doneSomething=false
scheduleKextTouch=false
listOfChanges="A list of what has been done:\n"

##  wait times
waitTime=7
priorWaitTime=5

##  system information
### OS
os=""
build=""
statSIP=128
### CUDA driver
cudaDriverVersion=""
cudaToolkitDriverVersion=""
cudaVersionFull=""
cudaVersion=""
cudaVersionsInstalledList=""
cudaVersionsNum=0
### NVIDIA driver
nvidiaDriverVersion=""
nvidiaDriverBuildVersion=""
### 10.13 enabler
enabler1013BuildVersion=""
### Installed programs
programList=""
### installed eGPU software
####CUDA driver
cudaVersionInstalled=false
cudaDriverInstalled=false
cudaDeveloperDriverInstalled=false
cudaToolkitInstalled=false
cudaSamplesInstalled=false
####NVIDIA driver
nvidiaDriversInstalled=false
####10.13 enabler
enabler1013Installed=false
####10.12 enabler
enabler1012rInstalled=false
enabler1012gInstalled=false
####thunderbolt enabler
tEnabler1013Installed=false
tEnabler1013InstallStatus=0




##  Subroutine A2: Basic preparations: function definition

#  temporary directory handling
dirName="$(uuidgen)"
dirName="$TMPDIR""macOS.eGPU.""$dirName"

################################################    no function exectuion here due to cross referencing
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

#   system cleanup
function systemClean {
    cleantmpdir
    dmgDetatch
}

#   quit all running apps
function quitAllApps {
    echo "Closing all apps..."
    appsToQuit=$(osascript -e 'tell application "System Events" to set quitapps to name of every application process whose visible is true and name is not "Finder" and name is not "Terminal"' -e 'return quitapps')
    appsToQuit="${appsToQuit//, /\n}"
    appsToQuit="$(echo -e $appsToQuit)"
    while read -r appNameToQuit
    do
        killall "$appNameToQuit"
    done <<< "$appsToQuit"
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
    trapWithoutWarning
    echo "To safely stop the script now press ^C."
    if [ "$1" == 1 ]
    then
        echo "The script will continue in 1 second ..."
    elif [ "$1" == 0 ]
    then
        echo "The system will continue now ..."
    else
        echo "The system will continue in $1 seconds ..."
    fi
    sleep "$1"
    trapWithWarning
}

##  reboot handler
function rebootSystem {
    systemClean
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
        sudo reboot &
    fi
    echo
    exit
}

##finish behavior
function finish {
    systemClean
    echo
    echo
    echo
    echo "The script has finished successfully."
    if [ "$doneSomething" == 1 ]
    then
        printChanges
        printTweaks
        rebootSystem
    else
        printTweaks
        echo
        echo "Nothing has been changed."
    fi
    echo
    exit
}

##  script interruption handler
function irupt {
    systemClean
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

function ask {
    echo -e "$1"
    read -p "$2"" [y]es [n]o : " -n 1 -r
    echo
    if ! [[ "$REPLY" =~ ^[Yy]$ ]]
    then
        if ! "$noReboot"
        then
            echo "The reboot will be omitted."
            noReboot=true
        fi
        irupt
    fi
}

##  manual script interruption
### Trap handler
function trapIrupt {
    if ! "$exitScript"
    then
        exitScript=true
        echo
        echo "You pressed ^C. Exiting the script during execution might render your system unrepairable."
        echo "Recommendation: Let the script finish and then run again with uninstall parameter."
        echo "Press again to force quit. Beware of the consequenses."
        sleep 5
    else
        irupt
    fi
}
### trap functions
####trap variant with warning
function trapWithWarning {
    trap trapIrupt INT
}

####trap variant without warning
function trapWithoutWarning {
    trap '{ echo; echo "Abort..."; irupt; }' INT
}

####deactivate abort
function trapLock {
    trap '' INT
}

####activate abort
function trapUnlock {
    trap - INT
}

#   startup warnings
function scriptWarningBegin {
    trapWithoutWarning
    echo "All apps will be force closed. Quit (press ^C) now to abort."
    echo "Do not use without backup."
    echo "It is strongly recommended to use the uninstall function before every macOS update/upgrade."
    echo "The script will continue in 10 seconds. Quit (press ^C) now if you don't have a backup."
    trap '{ echo; echo "You aborted the script. Nothing has been changed."; exit 1; }' INT
    sleep 10
    trapLock
    echo
    echo
    echo "macOS-eGPU.sh has been started..."
    echo "Do not force quit the script!"
    echo "It might render your Mac unrepairable."
    echo
    echo
}

################################################    /no function exectuion here due to cross referencing




##  Subroutine A3: Parameter - here are the only function executions before the very end
### Parse parameters
lastParam=""
for options in "$@"
do
    case "$options"
    in
    "--install" | "-i")
        if "$uninstall" || "$update" || "$check"
        then
            echo "ERROR: Conflicting arguments with --install | -i"
            irupt
        fi
        install=true
        ;;
    "--uninstall" | "-U")
        if "$install" || "$update" || "$check" || "$forceNewest" || "$reinstall" || "$check"
        then
            echo "ERROR: Conflicting arguments with --uninstall | -u"
            irupt
        fi
        uninstall=true
        ;;
    "--update" | "-u")
        if "$install" || "$uninstall" || "$check"
        then
            echo "ERROR: Conflicting arguments with --update | -U"
            irupt
        fi
        update=true
        ;;
    "--checkSystem" | "-C")
        if "$uninstall" || "$update" || "$install" || "$reinstall" || [ "$forceNewest" != "stable" ] || [ "$driver" || "$reinstall" || "$cuda" || "$minimal" || "$enabler"
        then
            echo "ERROR: Conflicting arguments with --check | -C"
            irupt
        fi
        check=true
        ;;
    "--nvidiaDriver" | "-n")
        if "$update" || "$check"
        then
            echo "ERROR: Conflicting arguments with --driver | -d"
            irupt
        fi
        driver=true
        ;;
    "--forceReinstall" | "-R")
        if "$uninstall" || "$check"
        then
            echo "ERROR: Conflicting arguments with --forceReinstall | -r"
            irupt
        fi
        reinstall=true
        ;;
    "--forceNewest" | "-N")
        if "$uninstall" || "$check"
        then
            echo "ERROR: Conflicting arguments with --forceNewest | -n"
            irupt
        fi
        forceNewest=true
        ;;
    "--eGPUsupport" | "-e")
        if "$update" || "$check"
        then
            echo "ERROR: Conflicting arguments with --eGPUsupport | -e"
            irupt
        fi
        enabler=true
        ;;
    "--unlockThunderbolt" | "-T")
        if "$update" || "$check"
        then
            echo "ERROR: Conflicting arguments with --unlockThunderbolt | -T"
            irupt
        fi
        tEnabler=true
        ;;
    "--cudaDriver" | "-c")
        if [ "$cuda" != 0 ] || "$check"
        then
            echo "ERROR: Conflicting arguments with --cudaDriver | -c"
            irupt
        fi
        cuda=1
        ;;
    "--cudaDeveloperDriver" | "-D")
        if [ "$cuda" != 0 ] || "$check"
        then
            echo "ERROR: Conflicting arguments with --cudaDeveloperDriver | -D"
            irupt
        fi
        cuda=2
        ;;
    "--cudaToolkit" | "-t")
        if [ "$cuda" != 0 ] || "$check"
        then
            echo "ERROR: Conflicting arguments with --cudaToolkit | -t"
            irupt
        fi
        cuda=3
        ;;
    "--cudaSamples" | "-s")
        if [ "$cuda" != 0 ] || "$check"
        then
            echo "ERROR: Conflicting arguments with --cudaSamples | -s"
            irupt
        fi
        cuda=4
        ;;
    "--mininmal" | "-m")
        if "$update" || "$check"
        then
            echo "ERROR: Conflicting arguments with --mininmal | -m"
            irupt
        fi
        minimal=true
        ;;
    "--noReboot" | "-r")
        noReboot=true
        ;;
    *)
        if [ "$lastParam" == "--driver" ] || [ "$lastParam" == "-d" ]
        then
            if "$forceNewest"
            then
                echo "ERROR: Conflicting arguments with --driver [revision] | -d [revision]"
                irupt
            fi
            customDriver=true
            nvidiaDriverDownloadVersion="$options"
        else
            echo "unrecognized parameter: ""$options"
            echo "The usage of this script is explained here in full detail:"
            echo "https://github.com/learex/macOS-eGPU"
            irupt
        fi
    esac
    lastParam="$options"
done

# ask license question
ask "Further execution requires explicit acceptance of the licensing terms.\nTo read the full license document goto:\nhttps://github.com/learex/macOS-eGPU/blob/master/License.txt" "Do you agree with the license terms?"

if ! "$noReboot"
then
    echo "The system will reboot after successfull completion."
    waiter "priorWaitTime"
fi

#   set standards
if ! ("$install" && "$uninstall" && "$update" && "$check")
then
    install=true
fi

if ! ("$enabler" && "$driver" && "$cuda" && "$tEnabler")
then
    determine=true
fi

#   Subroutine B: System checks ##############################################################################################################
#   Subroutine B1: define system information functions

##  get OS version and build number
function fetchOSinfo {
    os="$(sw_vers -productVersion)"
    build="$(sw_vers -buildVersion)"
}

##  get current SIP status
##  0: completely disabled, 127: fully enabled, 128: error, 31: --without KEXT
##  Binary of: Apple Internal | Kext Signing | Filesystem Protections | Debugging Restrictions | DTrace Restrictions | NVRAM Protections | BaseSystem Verification
function fetchSIPstat {
    SIP="$(csrutil status)"
    if [ "${SIP: -2}" == "d." ]
    then
        SIP="${SIP::37}"
        SIP="${SIP: -1}"
        case "$SIP"
        in
        "e")
            statSIP=127
            ;;
        "d")
            statSIP=0
            ;;
        *)
            statSIP=128
            ;;
        esac
    else
        SIP1="${SIP::102}"
        SIP1="${SIP1: -1}"
        SIP2="${SIP::126}"
        SIP2="${SIP2: -1}"
        SIP3="${SIP::160}"
        SIP3="${SIP3: -1}"
        SIP4="${SIP::193}"
        SIP4="${SIP4: -1}"
        SIP5="${SIP::223}"
        SIP5="${SIP5: -1}"
        SIP6="${SIP::251}"
        SIP6="${SIP6: -1}"
        SIP7="${SIP::285}"
        SIP7="${SIP7: -1}"
        p=1
        statSIP=0
        for SIPX in "$SIP7" "$SIP6" "$SIP5" "$SIP4" "$SIP3" "$SIP2" "$SIP1"
        do
            if [ "$SIPX" == "e" ]
            then
                statSIP="$(expr $statSIP + $p)"
            fi
            p="$(expr $p \* 2)"
        done
    fi
}




#   Subroutine B2: define CUDA information functions
##  reset previous CUDA checks
function checkCudaInstallReset {
    cudaVersionFull=""
    cudaVersion=""
    cudaVersionsInstalledList=""
    cudaVersionsNum=0
    cudaVersionInstalled=false
    cudaDriverInstalled=false
    cudaDeveloperDriverInstalled=false
    cudaToolkitInstalled=false
    cudaSamplesInstalled=false
}

##  fetch the toolkit version installed (pretest needed!)
function readCudaDeveloperVersion {
    cudaVersionFull="$(cat $cudaVersionPath)"
    cudaVersionFull="${cudaVersionFull##CUDA Version }"
    cudaVersion="${cudaVersionFull%.*}"
}

##  fetch multiple tookit versions (pretest needed!)
function readCudaToolkitVersions {
    cudaDirContent="$(ls $cudaDeveloperDir)"
    while read -r folder
    do
        if [ "${folder%%-*}" == "CUDA" ]
        then
            cudaVersionsInstalledList=$(echo -e "$cudaVersionsInstalledList""${folder#CUDA-};")
        fi
    done <<< "$cudaDirContent"
    cudaVersionsInstalledList="${cudaVersionsInstalledList//;/\n}"
    cudaVersionsInstalledList="$(echo -e -n $cudaVersionsInstalledList)"
    cudaVersionsInstalledList="$(echo $cudaVersionsInstalledList | wc -l | xargs)"
}

##  fetch which parts are installed
function refineCudaToolkitInstallationStatus {
    if "$cudaVersionInstalled"
    then
        cudaToolkitUnInstallDir="/Developer/NVIDIA/CUDA-""$cudaVersion""/bin/"
        cudaToolkitUnInstallScriptName="uninstall_cuda_""$cudaVersion"".pl"
        cudaToolkitUnInstallScript="$cudaToolkitUnInstallDir""$cudaToolkitUnInstallScript"
        cudaSamplesDir="/Developer/NVIDIA/CUDA-""$cudaVersion""/samples/"
        if [ -d "$cudaSamplesDir" ]
        then
            cudaSamplesInstalled=true
        fi
        if [ -e "$cudaToolkitUnInstallScriptPath" ]
        then
            cudaToolkitInstalled=true
        fi
    fi
}

##  see if the cuda drivers are installed
function checkCudaDriverInstall {
    if [ -e "$cudaDriver1" ] || [ -e "$cudaDriver2" ] || [ -e "$cudaDriver3" ] || [ -e "$cudaDriver4" ]
    then
        cudaDriverVersion=$("$pbuddy" -c "Print CFBundleVersion" "$cudaDriverVersionPath")
        cudaDriverInstalled=true
    fi
}

##  preform the complete cuda check
function checkCudaInstall {
    checkCudaInstallReset
    if [ -e "$cudaVersionPath" ]
    then
        cudaVersionInstalled=true
        readCudaDeveloperVersion
    fi
    if [ -d "$cudaDeveloperDir" ]
    then
        readCudaToolkitVersions
        refineCudaToolkitInstallationStatus
    fi
    if [ -e "$cudaDeveloperDriverUnInstallScriptPath" ]
    then
        cudaDeveloperDriverInstalled=1
    fi
    checkCudaDriverInstall
}




#   Subroutine B3: define NVIDIA driver information functions
##  reset previous driver checks
function checkNvidiaDriverInstallReset {
    nvidiaDriversInstalled=false
    nvidiaDriverVersion=""
    nvidiaDriverBuildVersion=""
}

##  check if NVIDIA drivers are installed
function checkNvidiaDriverInstall {
    checkNvidiaDriverInstallReset
    if [ -e "$nvidiaDriverUnInstallPKG" ]
    then
        nvidiaDriversInstalled=true
        nvidiaDriverVersion=$("$pbuddy" -c "Print CFBundleGetInfoString" "$nvidiaDriverVersionPath")
        nvidiaDriverVersion="${nvidiaDriverVersion##* }"
        nvidiaDriverBuildVersion=$("$pbuddy" -c "Print IOKitPersonalities:NVDAStartup:NVDARequiredOS" "$nvidiaDriverVersionPath")
    fi
}




#   Subroutine B4: define enabler1012g information functions
function checkEnabler1012gInstall {
    enabler1012gInstalled=false
    if [ -d "$enabler1012g1" ] || [ -e "$enabler1012g2" ]
    then
        enabler1012gInstalled=true
    fi
}




#   Subroutine B5: define enabler1012r information functions
function checkEnabler1012rInstall {
    enabler1012rInstalled=false
    if [ -e "$enabler1012r1" ]
    then
        enabler1012rInstalled=true
    fi
}




#   Subroutine B6: define enabler1013 information functions
##  reset previous enabler checks
function checkEnabler1013InstallReset {
    enabler1013Installed=false
    enabler1013BuildVersion=""
}
##  check if eGPU support is installed
function checkEnabler1013Install {
    checkEnabler1013InstallReset
    if [ -e "$enabler1013" ]
    then
        enabler1013Installed=true
        enabler1013BuildVersion=$("$pbuddy" -c "Print IOKitPersonalities:NVDAStartup:NVDARequiredOS" "$eGPUBuildVersionPath")
    fi
}




#   Subroutine B7: define unlock thunderbolt information functions
##  get detailed information about the TEnabler installation
##  Binary: upgrade | update | patchedMatch | unPatchedMatch | patched == unPatched
function refineTEnabler1013Install {
    checkSumWrangler=$(shasum -a 256 "$tEnabler10132" | awk '{ print $1 }')
    fetchOSinfo

    file=""
    while read -r line
    do
        file="$file""$line\n"
    done <<< "$(cat $tEnabler10131)"
    file="$(echo -e -n $file)"
    shaUnPatched=$(echo "$file" | sed -n 1p)
    shaPatched=$(echo "$file" | sed -n 2p)
    tMacOSVersion=$(echo "$file" | sed -n 3p)
    tMacOSBuild=$(echo "$file" | sed -n 4p)

    tEnabler1013Upgrade=0
    tEnabler1013Update=0
    tEnabler1013PatchedMatch=0
    tEnabler1013UnPatchedMatch=0
    tEnabler1013PatchUnPatch=0
    if [ "$os" != "$tMacOSVersion" ]
    then
        tEnabler1013Upgrade=1
    fi
    if [ "$build" != "$tMacOSBuild" ]
    then
        tEnabler1013Update=1
    fi
    if [ "$shaPatched" == "$checkSumWrangler" ]
    then
        tEnabler1013PatchedMatch=1
    fi
    if [ "$shaUnPatched" == "$checkSumWrangler" ]
    then
        tEnabler1013UnPatchedMatch=1
    fi
    if [ "$shaPatched" == "$shaUnPatched" ]
    then
        tEnabler1013PatchUnPatch=1
    fi
    tEnabler1013InstallStatus="$(expr $tEnabler1013PatchUnPatch + $tEnabler1013UnPatchedMatch \* 2 + $tEnabler1013PatchedMatch \* 4 + $tEnabler1013Update \* 8 + $tEnabler1013Upgrade \* 16)"

    if [ "$tEnabler1013PatchedMatch" == 1 ] && [ "$tEnabler1013PatchUnPatch" == 0 ]
    then
        tEnabler1013Installed=true
    fi
}

##  check if thounderbolt unlock patch is in use
function checkTEnabler1013Install {
    tEnabler1013Installed=false
    if [ -d "$tEnabler1" ]
    then
        refineTEnabler1013Install
    fi
}




#   Subroutine B8: fetch all installations at once
function fetchInstalledSoftware {
    checkCudaInstall
    checkNvidiaDriverInstall
    checkEnabler1012gInstall
    checkEnabler1012rInstall
    checkEnabler1013Install
    checkTEnabler1013Install
}




#   Subroutine B9: fetch all installed programs in /Applications
function fetchInstalledPrograms {
    appListPaths="$(find /Applications/ -iname *.app)"
    appList=""
    while read -r app
    do
        appTemp="${app##*/}"
        appList="$appList""${appTemp%.*}"";"
    done <<< "$appListPaths"
    appList="${appList//;/\n}"
    programList="$(echo -e -n $appList)"
}




#   Subroutine C: Custom uninstall scripts ##############################################################################################################
function genericUninstaller {
    fileListUninstall="$(echo -e $1)"
    genericUninstalled=false
    while read -r genericFile
    do
    if [ -e "$genericFile" ]
    then
        genericUninstalled=true
        sudo rm -r -f -v "$genericFile"
    fi
    done <<< "$fileListUninstall"
    if "$genericUninstalled"
    then
        return 0
    else
        return 1
    fi
}


#   Subroutine D: Uninstallers ##############################################################################################################
#   Subroutine D1: define CUDA uninstaller
##  uninstall CUDA Driver
function uninstallCudaDriver {
    genericUninstaller "/usr/local/bin/.cuda_driver_uninstall_manifest_do_not_delete.txt\n/Library/Frameworks/CUDA.framework\n/Library/PreferencePanes/CUDA Preferences.prefPane\n/Library/LaunchDaemons/com.nvidia.cuda.launcher.plist\n/Library/LaunchDaemons/com.nvidia.cudad.plist\n/usr/local/bin/uninstall_cuda_drv.pl\n/usr/local/cuda/lib/libcuda.dylib\n/Library/Extensions/CUDA.kext\n/Library/LaunchAgents/com.nvidia.CUDASoftwareUpdate.plist\n/usr/local/cuda"
    if [ "$?" == 0 ]
    then
        doneSomething=true
        scheduleReboot=true
        listOfChanges="$listOfChanges""\n""-CUDA $cudaDriverVersion drivers have been uninstalled"
    fi
}

##  uninstall CUDA residue
function uninstallCudaResidue {
    genericUninstaller "/Developer/NVIDIA/\n/usr/local/cuda"
    if [ "$?" == 0 ]
    then
        doneSomething=true
        scheduleReboot=true
        listOfChanges="$listOfChanges""\n""-CUDA residue has been removed"
    fi
}

##  uninstall CUDA Developer Driver
function uninstallCudaDeveloperDriver {
    if [ -e "$cudaDeveloperDriverUnInstallScript" ]
    then
        sudo perl "$cudaDeveloperDriverUnInstallScript"
        doneSomething=true
        listOfChanges="$listOfChanges""\n""-CUDA $cudaDriverVersion developer drivers have been uninstalled"
    fi
}

##  uninstall CUDA toolkit
function uninstallCudaToolkit {
    if [ -e "$cudaToolkitUnInstallScript" ]
    then
        sudo perl "$cudaToolkitUnInstallScript"
        listOfChanges="$listOfChanges""\n""-CUDA $cudaVersion toolkit has been uninstalled"
        doneSomething=true
    fi
}

##  uninstall CUDA samples
function uninstallCudaSamples {
    if [ -e "$cudaSamplesDir" ] && [ -e "$cudaToolkitUnInstallScript" ]
    then
        sudo perl "$cudaToolkitUnInstallScript" --manifest="$cudaToolkitUnInstallDir"".cuda_samples_uninstall_manifest_do_not_delete.txt"
        listOfChanges="$listOfChanges""\n""-CUDA $cudaVersion samples have been uninstalled"
        doneSomething=true
    fi
}

##  uninstall CUDA multiple versions
function uninstallCudaVersions {
    checkCudaInstall
    while read -r version
    do
        cudaVersion="$version"
        cudaToolkitUnInstallDir="/Developer/NVIDIA/CUDA-""$cudaVersion""/bin/"
        cudaToolkitUnInstallScriptName="uninstall_cuda_""$cudaVersion"".pl"
        cudaToolkitUnInstallScript="$cudaToolkitUnInstallDir""$cudaToolkitUnInstallScript"
        uninstallCudaToolkit
    done <<< "$cudaVersionsInstalledList"
    uninstallCudaDeveloperDriver
    uninstallCudaDriver
    uninstallCudaResidue
}

##  CUDA uninstaller
function uninstallCuda {
    checkCudaInstall
    if [[ "$cudaVersions" > 1 ]]
    then
        uninstallCudaVersions
    else
        if [ "$cuda" == 1 ] || [ "$cuda" == 2 ]
        then
            uninstallCudaSamples
            uninstallCudaToolkit
            uninstallCudaResidue
            uninstallCudaDriver
        elif [ "$cuda" == 3 ]
        then
            uninstallCudaSamples
            uninstallCudaToolkit
            uninstallCudaResidue
        elif [ "$cuda" == 4 ]
        then
            uninstallCudaSamples
        fi
    fi
}

#   Subroutine D2: define NVIDIA driver uninstaller
function uninstallNvidiaDriver {
    checkNvidiaDriverInstall
    if "$nvidiaDriversInstalled"
    then
        sudo installer -pkg "$nvidiaDriverUnInstallPath" -target /
        listOfChanges="$listOfChanges""\n""-NVIDIA drivers have been uninstalled"
        scheduleReboot=true
        doneSomething=true
        scheduleKextTouch=true
    fi
}

#   Subroutine D3: define enabler1012g uninstaller
function uninstallEnabler1012g {
    checkEnabler1012gInstall
    if "$enabler1012gInstalled"
    then
        cd "$dirName"/
        chmod +x automate-eGPU.sh
        sudo ./automate-eGPU.sh -uninstall
        rm automate-eGPU.sh
        scheduleReboot=true
        doneSomething=true
        scheduleKextTouch=true
        listOfChanges="$listOfChanges""\n""-eGPU support (Sierra) has been uninstalled"
    fi
}

#   Subroutine D4: define enabler1012r uninstaller
function uninstallEnabler1012r {
    checkEnabler1012rInstall
    if "$enabler1012rInstalled"
    then
        genericUninstaller "/Applications/Uninstall Rastafabi's eGPU Enabler.app\n/Library/Extensions/eGPU.kext\n/Library/Application Support/fpsoft\n/Library/LaunchAgents/com.fpsoft.eGPU_iMac_5k_Fix.plist\n/Library/LaunchAgents/com.fpsoft.eGPU_delay_Thunderbolt.plist"
        if [ "$?" == 0 ]
        then
            scheduleReboot=true
            doneSomething=true
            scheduleKextTouch=true
            listOfChanges="$listOfChanges""\n""-eGPU support (Sierra) has been uninstalled"
        fi
    fi
}

#   Subroutine D5: define enabler1013 uninstaller
function uninstallEnabler1013 {
    checkEnabler1013Install
    if "$enabler1013Installed"
    then
        sudo rm -r -f -v "$enabler1013"
        listOfChanges="$listOfChanges""\n""-eGPU support (High Sierra) has been uninstalled"
        scheduleReboot=true
        doneSomething=true
        scheduleKextTouch=true
    fi
}

#   Subroutine D6: define unlock thunderbolt uninstaller
function uninstallTEnabler1013 {
    cd "$dirName"

}








#   end of script




















