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
currentOS="10.13.4"
cudaLatest=true
toolkitLatest=true
gitPath="https://raw.githubusercontent.com/learex/macOS-eGPU/""$branch"

##  external functions
pbuddy="/usr/libexec/PlistBuddy"

##  static data download paths
### enabler paths
enabler1013ListOnline="$gitPath""/Data/eGPUenabler1013.plist"
enablerAMDLegacyDonwloadLink="https://egpu.io/wp-content/uploads/2018/04/automate-eGPU.kext_-1.zip"
enablerAMDLegacyChecksum="2c93ef2e99423e0a1223d356772bd67d6083da69489fb3cf61dfbb69237eba1aaf453b7dc571cfe729e8b8bc1f92fcf29f675f60cd7dba9ec9b2723bac8f6bb7"
### NVIDIA driver paths
nvidiaDriverNListOnline="https://gfe.nvidia.com/mac-update"
nvidiaDriverListOnline="$gitPath""/Data/nvidiaDriver.plist"
### CUDA driver paths
cudaDriverListOnline="$gitPath""/Data/cudaDriver.plist"
cudaToolkitListOnline="$gitPath""/Data/cudaToolkit.plist"
cudaAppListOnline="$gitPath""/Data/cudaApps.plist"
cudaDriverWebsite="http://www.nvidia.com/object/cuda-mac-driver.html"
cudaToolkitWebsite="https://developer.nvidia.com/cuda-downloads?target_os=MacOSX&target_arch=x86_64&target_version=1013&target_type=dmglocal"

##  dynamic download paths
### CUDA driver paths
cudaDriverDownloadLink=""
cudaDriverDownloadVersion=""
cudaToolkitDownloadLink=""
cudaToolkitDownloadVersion=""
cudaToolkitDriverDownloadVersion=""
### NVIDIA driver paths
#nvidiaDriverDownloadVersion="" (below --driver)
nvidiaDriverDownloadLink=""
nvidiaDriverDownloadChecksum=""
### enabler paths
enabler1013DownloadLink=""
enabler1013DownloadChecksum=""



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
enabler1013DownloadPKGName=""


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
tEnabler10133="/usr/local/bin/purge-wrangler.sh"
### AMD Legacy enabler
AMDLegacyEnabler1="/Library/Extensions/automate-eGPU.kext"

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
foundMatchCudaDriver=false
foundMatchCudaToolkit=false
foundMatchNvidiaDriver=false
foundMatchEnabler1013=false
forceCudaDriverStable=false
forceCudaToolkitStable=false
forceNvidiaDriverStable=false
omitEnabler1013=false
omitTEnabler=false
omitAMDLegacyEnabler=false
omitNvidiaDriver=false
omitCuda=false
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
####AMD Legacy Enabler
AMDLegacyEnablerInstalled=false




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
        hdiutil detach "$cudaDriverVolPath" -quiet
    fi
    if [ -d "$cudaToolkitVolPath" ]
    then
        hdiutil detach "$cudaToolkitVolPath" -quiet
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
    appsToQuitTemp=$(osascript -e 'tell application "System Events" to set quitapps to name of every application process whose visible is true and name is not "Finder" and name is not "Terminal"' -e 'return quitapps')
    appsToQuitTemp="${appsToQuitTemp//, /\n}"
    appsToQuitTemp="$(echo -e $appsToQuitTemp)"
    while read -r appNameToQuitTemp
    do
        killall "$appNameToQuitTemp"
    done <<< "$appsToQuitTemp"
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

##  generic ask function
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

##  check if script is run as root
function checkRootPrivileges {
    if [ "$(id -u)" != 0 ]
    then
        echo "To continue elevated privileges are needed."
        echo "Please enter your password below:"
        sudo -v
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

#   startup warnings
function scriptWarningBegin {
    trapWithoutWarning
    echo "All apps will be force closed. Quit (press ^C) now to abort."
    sleep 2
    echo "Do not use without backup."
    sleep 2
    echo "It is strongly recommended to use the uninstall function before every macOS update/upgrade."
    sleep 2
    echo "Quit (press ^C) now if you don't have a backup."
    sleep 2
    trapLock
    echo
    echo
    echo "macOS-eGPU.sh has been started..."
    echo "Do not force quit the script!"
    echo "It might render your Mac unrepairable."
    sleep 2
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
        if "$uninstall" || "$update" || "$install" || "$reinstall" || "$forceNewest" || "$driver" || "$reinstall" || "$cuda" || "$minimal" || "$enabler"
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

if ( ! "$noReboot" ) && ( ! "$check" )
then
    echo "The system will reboot after successfull completion."
    waiter "$priorWaitTime"
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
    SIPTemp="$(csrutil status)"
    if [ "${SIPTemp: -2}" == "d." ]
    then
        SIPTemp="${SIPTemp::37}"
        SIPTemp="${SIPTemp: -1}"
        case "$SIPTemp"
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
        SIP1Temp="${SIPTemp::102}"
        SIP1Temp="${SIP1Temp: -1}"
        SIP2Temp="${SIPTemp::126}"
        SIP2Temp="${SIP2Temp: -1}"
        SIP3Temp="${SIPTemp::160}"
        SIP3Temp="${SIP3Temp: -1}"
        SIP4Temp="${SIPTemp::193}"
        SIP4Temp="${SIP4Temp: -1}"
        SIP5Temp="${SIPTemp::223}"
        SIP5Temp="${SIP5Temp: -1}"
        SIP6Temp="${SIPTemp::251}"
        SIP6Temp="${SIP6Temp: -1}"
        SIP7Temp="${SIPTemp::285}"
        SIP7Temp="${SIP7Temp: -1}"
        pTemp=1
        statSIP=0
        for SIPXTemp in "$SIP7Temp" "$SIP6Temp" "$SIP5Temp" "$SIP4Temp" "$SIP3Temp" "$SIP2Temp" "$SIP1Temp"
        do
            if [ "$SIPXTemp" == "e" ]
            then
                statSIP="$(expr $statSIP + $pTemp)"
            fi
            pTemp="$(expr $pTemp \* 2)"
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
    cudaDirContentTemp="$(ls $cudaDeveloperDir)"
    while read -r folderTemp
    do
        if [ "${folderTemp%%-*}" == "CUDA" ]
        then
            cudaVersionsInstalledList="$cudaVersionsInstalledList""${folderTemp#CUDA-}\n"
        fi
    done <<< "$cudaDirContentTemp"
    cudaVersionsInstalledList="$(echo -e -n $cudaVersionsInstalledList)"
    cudaVersionsNum="$(echo $cudaVersionsInstalledList | wc -l | xargs)"
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
        cudaDeveloperDriverInstalled=true
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
        if ! [ -e "$enabler1012g2" ]
        then
            curl -s "$enabler1012ScriptOnline" > "$enabler1012g2"
        fi
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
    checkSumWranglerTemp=$(shasum -a 512 "$tEnabler10132" | awk '{ print $1 }')
    fetchOSinfo

    fileTemp=""
    while read -r lineTemp
    do
        fileTemp="$fileTemp""$lineTemp\n"
    done <<< "$(cat $tEnabler10131)"
    fileTemp="$(echo -e -n $fileTemp)"
    shaUnPatchedTemp=$(echo "$fileTemp" | sed -n 1p)
    shaPatchedTemp=$(echo "$fileTemp" | sed -n 2p)
    tMacOSVersionTemp=$(echo "$fileTemp" | sed -n 3p)
    tMacOSBuildTemp=$(echo "$fileTemp" | sed -n 4p)

    tEnabler1013UpgradeTemp=0
    tEnabler1013UpdateTemp=0
    tEnabler1013PatchedMatchTemp=0
    tEnabler1013UnPatchedMatchTemp=0
    tEnabler1013PatchUnPatchTemp=0
    if [ "$os" != "$tMacOSVersionTemp" ]
    then
        tEnabler1013Upgrade=1
    fi
    if [ "$build" != "$tMacOSBuildTemp" ]
    then
        tEnabler1013Update=1
    fi
    if [ "$shaPatchedTemp" == "$checkSumWranglerTemp" ]
    then
        tEnabler1013PatchedMatchTemp=1
    fi
    if [ "$shaUnPatchedTemp" == "$checkSumWranglerTemp" ]
    then
        tEnabler1013UnPatchedMatchTemp=1
    fi
    if [ "$shaPatchedTemp" == "$shaUnPatchedTemp" ]
    then
        tEnabler1013PatchUnPatchTemp=1
    fi
    tEnabler1013InstallStatus="$(expr $tEnabler1013PatchUnPatchTemp + $tEnabler1013UnPatchedMatchTemp \* 2 + $tEnabler1013PatchedMatchTemp \* 4 + $tEnabler1013UpdateTemp \* 8 + $tEnabler1013UpgradeTemp \* 16)"

    if [ "$tEnabler1013PatchedMatchTemp" == 1 ] && [ "$tEnabler1013PatchUnPatchTemp" == 0 ]
    then
        tEnabler1013Installed=true
        if ! [ -e "$tEnabler10133" ]
        then
            curl -s "$tEnabler1013ScriptOnline" > "$tEnabler10133"
        fi
    fi
}

##  check if thounderbolt unlock patch is in use
function checkTEnabler1013Install {
    tEnabler1013Installed=false
    if [ -e "$tEnabler1" ]
    then
        refineTEnabler1013Install
    fi
}





#   Subroutine B8: fetch all installed programs in /Applications
function fetchInstalledPrograms {
    appListPathsTemp="$(find /Applications/ -iname *.app)"
    appListTemp=""
    while read -r appTemp
    do
        appTemp="${appTemp##*/}"
        appListTemp="$appList""${appTemp%.*}""\n"
    done <<< "$appListPathsTemp"
    programList="$(echo -e -n $appListTemp)"
}




#   Subroutines B9: check if NVIDIA dGPU, thunderbolt peripherals and external Monitors are connected
function fetchSystemStatus {

}


function checkAMDLagacyEnabler {
    if [ -e "$AMDLegacyEnabler1" ]
    then
        AMDLegacyEnablerInstalled=true
    fi
}




#   Subroutine B10: fetch all installations at once
function fetchInstalledSoftware {
    checkCudaInstall
    checkNvidiaDriverInstall
    checkEnabler1012gInstall
    checkEnabler1012rInstall
    checkEnabler1013Install
    checkTEnabler1013Install
    checkAMDLagacyEnabler
}

#   Subroutine C: Custom uninstall scripts ##############################################################################################################
function genericUninstaller {
    fileListUninstallTemp="$(echo -e $1)"
    genericUninstalledTemp=false
    while read -r genericFileTemp
    do
    if [ -e "$genericFileTemp" ]
    then
        genericUninstalledTemp=true
        sudo rm -r -f "$genericFileTemp"
    fi
    done <<< "$fileListUninstallTemp"
    if "$genericUninstalledTemp"
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
        sudo perl "$cudaDeveloperDriverUnInstallScript" --silent
        doneSomething=true
        listOfChanges="$listOfChanges""\n""-CUDA $cudaDriverVersion developer drivers have been uninstalled"
    fi
}

##  uninstall CUDA toolkit
function uninstallCudaToolkit {
    if [ -e "$cudaToolkitUnInstallScript" ]
    then
        sudo perl "$cudaToolkitUnInstallScript" --silent
        listOfChanges="$listOfChanges""\n""-CUDA $cudaVersion toolkit has been uninstalled"
        doneSomething=true
    fi
}

##  uninstall CUDA samples
function uninstallCudaSamples {
    if [ -e "$cudaSamplesDir" ] && [ -e "$cudaToolkitUnInstallScript" ]
    then
        sudo perl "$cudaToolkitUnInstallScript" --manifest="$cudaToolkitUnInstallDir"".cuda_samples_uninstall_manifest_do_not_delete.txt" --silent
        listOfChanges="$listOfChanges""\n""-CUDA $cudaVersion samples have been uninstalled"
        doneSomething=true
    fi
}

##  uninstall CUDA multiple versions
function uninstallCudaVersions {
    checkCudaInstall
    while read -r versionTemp
    do
        cudaVersion="$versionTemp"
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
    checkCudaInstall
}




#   Subroutine D2: define NVIDIA driver uninstaller
function uninstallNvidiaDriver {
    checkNvidiaDriverInstall
    if "$nvidiaDriversInstalled"
    then
        sudo installer -pkg "$nvidiaDriverUnInstallPKG" -target /
        listOfChanges="$listOfChanges""\n""-NVIDIA drivers have been uninstalled"
        scheduleReboot=true
        doneSomething=true
        scheduleKextTouch=true
    fi
    checkNvidiaDriverInstall
}




#   Subroutine D3: define enabler1012g uninstaller
function uninstallEnabler1012g {
    checkEnabler1012gInstall
    if "$enabler1012gInstalled"
    then
        sudo bash "$enabler1012g2" -uninstall
        if [ -e "$enabler1012g2" ]
        then
            rm -r -f "$enabler1012g2"
        fi
        scheduleReboot=true
        doneSomething=true
        scheduleKextTouch=true
        listOfChanges="$listOfChanges""\n""-eGPU support (Sierra) has been uninstalled"
    fi
    checkEnabler1012gInstall
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
    checkEnabler1012rInstall
}




#   Subroutine D5: define enabler1013 uninstaller
function uninstallEnabler1013 {
    checkEnabler1013Install
    if "$enabler1013Installed"
    then
        sudo rm -rf "$enabler1013"
        listOfChanges="$listOfChanges""\n""-eGPU support (High Sierra) has been uninstalled"
        scheduleReboot=true
        doneSomething=true
        scheduleKextTouch=true
    fi
    checkEnabler1013Install
}




#   Subroutine D6: define unlock thunderbolt uninstaller
function uninstallTEnabler1013 {
    checkTEnabler1013Install
    if "$tEnabler1013Installed"
    then
        sudo bash "$tEnabler10133" recover
        if [ -e "$tEnabler10133" ]
        then
            sudo rm -rf "$tEnabler10133"
        fi
        listOfChanges="$listOfChanges""\n""-Thunderbolt unlock has been uninstalled"
        scheduleReboot=true
        doneSomething=true
        scheduleKextTouch=true
    fi
    checkTEnabler1013Install
}




#   Subroutine D7: define AMD Legacy uninstaller
function uninstallAMDLagacyEnabler {
    if [ -e "$AMDLegacyEnabler1" ]
    then
        sudo rm -rf "$AMDLegacyEnabler1"
        listOfChanges="$listOfChanges""\n""-AMD Legacy enabler has been uninstalled"
        scheduleReboot=true
        doneSomething=true
        scheduleKextTouch=true
    fi
}




#   Subroutine E: Downloader ##############################################################################################################
#   Subroutine E1: define CUDA driver downloader
##  CUDA driver Information
function downloadCudaDriverInformation {
    mktmpdir
    foundMatchCudaDriver=false
    if (( "$cudaLatest" && [ "${currentOS::5}" == "${os::5}" ] ) || "$forceNewest" ) && ( ! "$forceCudaDriverStable" )
    then
        cudaWebsiteLocalTemp="$dirName""/cudaWebsite.html"
        curl -s -L "$cudaDriverWebsite" > "$cudaWebsiteLocalTemp"
        cudaDriverDownloadLink=$(cat "$cudaWebsiteLocalTemp" | grep -e download)
        cudaDriverDownloadLink="${cudaDriverDownloadLink##*http}"
        cudaDriverDownloadLink="${cudaDriverDownloadLink%%.dmg*}"
        cudaDriverDownloadLink="http""$cudaDriverDownloadLink"".dmg"
        cudaDriverDownloadVersion="${cudaDriverDownloadLink%_*}"
        cudaDriverDownloadVersion="${cudaDriverDownloadVersion##*_}"
        rm "$cudaWebsiteLocalTemp"
        foundMatchCudaDriver=true
    else
        cudaDriverListLocalTemp="$dirName""/cudaDriverList.plist"
        curl -s "$cudaDriverListOnline" > "$cudaDriverListLocalTemp"
        driversTemp=$("$pbuddy" -c "Print updates:" "$cudaDriverListLocalTemp" | grep "OS" | awk '{print $3}')
        driverCountTemp=$(echo "$driversTemp" | wc -l | xargs)
        for index in `seq 0 $(expr $driverCountTemp - 1)`
        do
            osTemp=$("$pbuddy" -c "Print updates:$index:OS" "$cudaDriverListLocalTemp")
            cudaDriverPathTemp=$("$pbuddy" -c "Print updates:$index:downloadURL" "$cudaDriverListLocalTemp")
            cudaDriverVersionTemp=$("$pbuddy" -c "Print updates:$index:version" "$cudaDriverListLocalTemp")

            if [ "${os::5}" == "$osTemp" ]
            then
                cudaDriverDownloadLink="$cudaDriverPathTemp"
                cudaDriverDownloadVersion="$cudaDriverVersionTemp"
                foundMatchCudaDriver=true
            fi
        done
        rm "$cudaDriverListLocalTemp"
    fi
}

##  CUDA driver download
function downloadCudaDriverDownloadFallback {
    forceCudaDriverStable=true
    downloadCudaDriverInformation
    if "$foundMatchCudaDriver"
    then
        mktmpdir
        curl -o "$dirName""/cudaDriver.dmg" "$cudaDriverDownloadLink"
        hdiutil attach "$dirName""/cudaDriver.dmg" -quiet -nobrowse
        if [ "$?" == 1 ]
        then
            omitCuda=true
        fi
    else
        omitCuda=true
    fi

}
function downloadCudaDriver {
    downloadCudaDriverInformation
    if "$foundMatchCudaDriver"
    then
        mktmpdir
        curl -o "$dirName""/cudaDriver.dmg" "$cudaDriverDownloadLink"
        hdiutil attach "$dirName""/cudaDriver.dmg" -quiet -nobrowse
        if [ "$?" == 1 ]
        then
            downloadCudaDriverDownloadFallback
        fi
    else
        downloadCudaDriverDownloadFallback
    fi
}




#   Subroutine E2: define CUDA toolkit downloader
##  CUDA toolkit Information
function downloadCudaToolkitInformation {
    mktmpdir
    foundMatchCudaToolkit=false
    if (( "$toolkitLatest" && [ "${currentOS::5}" == "${os::5}" ] ) || "$forceNewest" ) && ( ! "$forceCudaToolkitStable" )
    then
        cudaWebsiteLocalTemp="$dirName""/cudaWebsite.html"
        curl -s "$cudaToolkitWebsite" > "$cudaWebsiteLocalTemp"
        cudaToolkitDownloadLink=$(cat "$cudaWebsiteLocalTemp" | grep -e mac | grep -e local_installers)
        cudaToolkitDownloadLink="${cudaToolkitDownloadLink#*/compute/cuda/}"
        cudaToolkitDownloadLink="${cudaToolkitDownloadLink%%_mac*}"
        cudaToolkitDownloadLink="https://developer.nvidia.com/compute/cuda/""$cudaToolkitDownloadLink""_mac"
        cudaToolkitDownloadVersion="${cudaToolkitDownloadLink%_*}"
        cudaToolkitDownloadVersion="${cudaToolkitDownloadVersion##*_}"
        rm "$cudaWebsiteLocalTemp"
        foundMatchCudaToolkit=true
    else
        cudaToolkitListTemp="$dirName""/cudaToolkitList.plist"
        curl -s "$cudaToolkitListOnline" > "$cudaToolkitListTemp"
        driversTemp=$("$pbuddy" -c "Print updates:" "$cudaToolkitListTemp" | grep "OS" | awk '{print $3}')
        driverCountTemp=$(echo "$driversTemp" | wc -l | xargs)
        for index in `seq 0 $(expr $driverCountTemp - 1)`
        do
            osTemp=$("$pbuddy" -c "Print updates:$index:OS" "$cudaToolkitListTemp")
            cudaToolkitPathTemp=$("$pbuddy" -c "Print updates:$index:downloadURL" "$cudaToolkitListTemp")
            cudaToolkitVersionTemp=$("$pbuddy" -c "Print updates:$index:version" "$cudaToolkitListTemp")
            cudaToolkitDriverVersionTemp=$("$pbuddy" -c "Print updates:$index:driverVersion" "$cudaToolkitListTemp")
            if [ "${os::5}" == "$osTemp" ]
            then
                cudaToolkitDownloadLink="$cudaToolkitPathTemp"
                cudaToolkitDownloadVersion="$cudaToolkitVersionTemp"
                cudaToolkitDriverDownloadVersion="$cudaToolkitDriverVersionTemp"
                foundMatchCudaToolkit=true
            fi
        done
        rm "$cudaToolkitListTemp"
    fi
}

##  CUDA toolkit download
function downloadCudaToolkitDownloadFallback {
    forceCudaToolkitStable=true
    downloadCudaToolkitInformation
    if "$foundMatchCudaToolkit"
    then
        mktmpdir
        curl -o -L "$dirName""/cudaToolkit.dmg" "$cudaToolkitDownloadLink"
        hdiutil attach "$dirName""/cudaToolkit.dmg" -quiet -nobrowse
        if [ "$?" == 1 ]
        then
            omitCuda=true
        fi
    else
        omitCuda=true
    fi
}
function downloadCudaToolkit {
    downloadCudaToolkitInformation
    if "$foundMatchCudaToolkit"
    then
        mktmpdir
        curl -o -L "$dirName""/cudaToolkit.dmg" "$cudaToolkitDownloadLink"
        hdiutil attach "$dirName""/cudaToolkit.dmg" -quiet -nobrowse
        if [ "$?" == 1 ]
        then
            downloadCudaToolkitDownloadFallback
        fi
    else
        downloadCudaToolkitDownloadFallback
    fi
}




#   Subroutine E3: define NVIDIA driver downloader
##  NVIDIA driver Information
function downloadNvidiaDriverInformation {
    mktmpdir
    foundMatchNvidiaDriver=false
    if "$forceNewest" && ( ! "$forceNvidiaDriverStable" )
    then
        nvidiaDriverListTemp="$dirName""/nvidiaDriver.plist"
        curl -s "$nvidiaDriverNListOnline" > "$nvidiaDriverListTemp"
        driversTemp=$("$pbuddy" -c "Print updates:" "$nvidiaDriverListTemp" | grep "OS" | awk '{print $3}')
        driverCountTemp=$(echo "$driversTemp" | wc -l | xargs)
        for index in `seq 0 $(expr $driverCountTemp - 1)`
        do
            buildTemp=$("$pbuddy" -c "Print updates:$index:OS" "$nvidiaDriverListTemp")
            nvidiaDriverVersionTemp=$("$pbuddy" -c "Print updates:$index:version" "$nvidiaDriverListTemp")
            nvidiaDriverLinkTemp=$("$pbuddy" -c "Print updates:$index:downloadURL" "$nvidiaDriverListTemp")
            nvidiaDriverChecksumTemp=$("$pbuddy" -c "Print updates:$index:checksum" "$nvidiaDriverListTemp")

            if [ "$build" == "$buildTemp" ]
            then
                nvidiaDriverDownloadVersion="$nvidiaDriverVersionTemp"
                nvidiaDriverDownloadLink="$nvidiaDriverLinkTemp"
                nvidiaDriverDownloadChecksum="$nvidiaDriverChecksumTemp"
                foundMatchNvidiaDriver=true
            fi
        done
        rm "$nvidiaDriverListTemp"
    elif "$customDriver"  && ( ! "$forceNvidiaDriverStable" )
    then
        nvidiaDriverLisTempt="$dirName""/nvidiaDriver.plist"
        curl -s "$nvidiaDriverNListOnline" > "$nvidiaDriverListTemp"
        drivers=$("$pbuddy" -c "Print updates:" "$nvidiaDriverListTemp" | grep "OS" | awk '{print $3}')
        driverCount=$(echo "$drivers" | wc -l | xargs)
        for index in `seq 0 $(expr $driverCount - 1)`
        do
            buildTemp=$("$pbuddy" -c "Print updates:$index:OS" "$nvidiaDriverListTemp")
            nvidiaDriverVersionTemp=$("$pbuddy" -c "Print updates:$index:version" "$nvidiaDriverListTemp")
            nvidiaDriverLinkTemp=$("$pbuddy" -c "Print updates:$index:downloadURL" "$nvidiaDriverListTemp")
            nvidiaDriverChecksumTemp=$("$pbuddy" -c "Print updates:$index:checksum" "$nvidiaDriverListTemp")

            if [ "$nvidiaDriverDownloadVersion" == "$nvidiaDriverVersionTemp" ]
            then
                nvidiaDriverDownloadVersion="$nvidiaDriverVersionTemp"
                nvidiaDriverDownloadLink="$nvidiaDriverLinkTemp"
                nvidiaDriverDownloadChecksum="$nvidiaDriverChecksumTemp"
                foundMatchNvidiaDriver=true
            fi
        done
        rm "$nvidiaDriverListTemp"
    else
        nvidiaDriverListTemp="$dirName""/nvidiaDriver.plist"
        curl -s "$nvidiaDriverListOnline" > "$nvidiaDriverListTemp"
        drivers=$("$pbuddy" -c "Print updates:" "$nvidiaDriverListTemp" | grep "OS" | awk '{print $3}')
        driverCount=$(echo "$drivers" | wc -l | xargs)
        for index in `seq 0 $(expr $driverCount - 1)`
        do
            buildTemp=$("$pbuddy" -c "Print updates:$index:build" "$nvidiaDriverListTemp")
            nvidiaDriverVersionTemp=$("$pbuddy" -c "Print updates:$index:version" "$nvidiaDriverListTemp")
            nvidiaDriverLinkTemp=$("$pbuddy" -c "Print updates:$index:downloadURL" "$nvidiaDriverListTemp")
            nvidiaDriverChecksumTemp=$("$pbuddy" -c "Print updates:$index:checksum" "$nvidiaDriverListTemp")

            if [ "$build" == "$buildTemp" ]
            then
                nvidiaDriverDownloadVersion="$nvidiaDriverVersionTemp"
                nvidiaDriverDownloadLink="$nvidiaDriverLinkTemp"
                nvidiaDriverDownloadChecksum="$nvidiaDriverChecksumTemp"
                foundMatchNvidiaDriver=true
            fi
        done
        rm "$nvidiaDriverListTemp"
    fi
}

##  NVIDIA driver download
function downloadNvidiaDriverDownloadFallback {
    forceNvidiaDriverStable=true
    downloadNvidiaDriverInformation
    if "$foundMatchNvidiaDriver"
    then
        mktmpdir
        curl -o "$dirName""/nvidiaDriver.pkg" "$nvidiaDriverDownloadLink"
        nvidiaDriverChecksumTemp=$(shasum -a 512 -b "$dirName""/nvidiaDriver.pkg" | awk '{ print $1 }')
        if [ "$nvidiaDriverDownloadChecksum" != "$nvidiaDriverChecksumTemp" ]
        then
            omitNvidiaDriver=true
        fi
    else
        omitNvidiaDriver=true
    fi
}
function downloadNvidiaDriver {
    downloadNvidiaDriverInformation
    if "$foundMatchNvidiaDriver"
    then
        mktmpdir
        curl -o "$dirName""/nvidiaDriver.pkg" "$nvidiaDriverDownloadLink"
        nvidiaDriverChecksumTemp=$(shasum -a 512 -b "$dirName""/nvidiaDriver.pkg" | awk '{ print $1 }')
        if [ "$nvidiaDriverDownloadChecksum" != "$nvidiaDriverChecksumTemp" ]
        then
            downloadNvidiaDriverDownloadFallback
        fi
    else
        downloadNvidiaDriverDownloadFallback
    fi
}




#   Subroutine E4: define enabler downloader
##  eGPU enabler Information
function downloadEnabler1013Information {
    mktmpdir
    enabler1013ListTemp="$dirName""/eGPUenabler.plist"
    curl -s "$eGPUEnablerListOnline" > "$enabler1013ListTemp"

    enablersTemp=$("$pbuddy" -c "Print updates:" "$enabler1013ListTemp" | grep "build" | awk '{print $3}')
    enablerCountTemp=$(echo "$enablersTemp" | wc -l | xargs)
    foundMatch=false
    for index in `seq 0 $(expr $enablerCountTemp - 1)`
    do
        buildTemp=$("$pbuddy" -c "Print updates:$index:build" "$enabler1013ListTemp")
        enabler1013ChecksumTemp=$("$pbuddy" -c "Print updates:$index:checksum" "$enabler1013ListTemp")
        enabler1013PKGNameTemp=$("$pbuddy" -c "Print updates:$index:packageName" "$enabler1013ListTemp")
        enabler1013DownloadLinkTemp=$("$pbuddy" -c "Print updates:$index:downloadURL" "$enabler1013ListTemp")
        if [ "$build" == "$buildTemp" ]
        then
            enabler1013DownloadPKGName="$enabler1013PKGNameTemp"
            enabler1013DownloadLink="$enabler1013DownloadLinkTemp"
            enabler1013DownloadChecksum="$enabler1013ChecksumTemp"
            foundMatchEnabler1013=true
        fi
    done
    rm "$enabler1013ListTemp"
}

##  eGPU enabler download
function downloadEnabler1013 {
    downloadEnabler1013Information
    if "$foundMatchEnabler1013"
    then
        mktmpdir
        curl -o "$dirName""/enabler.zip" "$enabler1013DownloadLink"
        enabler1013ChecksumTemp=$(shasum -a 512 -b "$dirName""/enabler.zip" | awk '{ print $1 }')
        if [ "$enabler1013DownloadChecksum" != "$enabler1013ChecksumTemp" ]
        then
            omitEnabler1013=true
        else
            unzip -qq "$dirName""/enabler.zip" -d "$dirName""/"
        fi
        rm -rf "$dirName""/enabler.zip"
    else
        omitEnabler1013=true
    fi
}





#   Subroutine E5: define AMD support downloader
##  AMD eGPU enabler Information
function downloadAMDLagacyEnabler {
    mktmpdir
    curl -o "$dirName""/AMDLegacy.zip" "$enablerAMDLegacyDonwloadLink"
    enablerAMDLegacyChecksumTemp=$(shasum -a 512 -b "$dirName""/AMDLegacy.zip" | awk '{ print $1 }')
    if [ "$enablerAMDLegacyChecksum" != "$enablerAMDLegacyChecksumTemp ]
    then
        omitAMDLegacyEnabler=true
    else
        unzip -qq "$dirName""/AMDLegacy.zip" -d "$dirName""/"
    fi
    rm -rf "$dirName""/AMDLegacy.zip"
}






#   Subroutine F: Installer ##############################################################################################################
#   Subroutine F1: define CUDA driver installer
function installCudaDriver {
    if ! "$omitCuda"
    then
        if [ -e "$cudaDriverVolPath""$cudaDriverPKGName" ]
        then
            sudo installer -pkg "$cudaDriverVolPath""$cudaDriverPKGName" -target / &>/dev/null
            listOfChanges="$listOfChanges""\n""-CUDA drivers have been installed"
            scheduleReboot=true
            doneSomething=true
            scheduleKextTouch=true
            hdiutil detach "$cudaDriverVolPath" -quiet
            rm -rf "$dirName""/cudaDriver.dmg"
        fi
    fi
}




#   Subroutine F2: define CUDA toolkit installer
function installCudaToolkitBranch {
    if ! "$omitCuda"
    then
        if [ -e "$cudaToolkitVolPath""$cudaToolkitPKGName" ]
        then
            if [ "$cuda" == 2 ]
            then
                sudo "$cudaToolkitVolPath""$cudaToolkitPKGName" --accept-eula --silent --no-window --install-package="cuda-driver" &>/dev/null
                listOfChanges="$listOfChanges""\n""-CUDA developer drivers have been installed"
                scheduleReboot=true
                doneSomething=true
                scheduleKextTouch=true
            elif [ "$cuda" == 3 ]
            then
                sudo "$cudaToolkitVolPath""$cudaToolkitPKGName" --accept-eula --silent --no-window --install-package="cuda-driver" --install-package="cuda-toolkit" &>/dev/null
                listOfChanges="$listOfChanges""\n""-CUDA developer drivers have been installed"
                listOfChanges="$listOfChanges""\n""-CUDA toolkit has been installed"
                scheduleReboot=true
                doneSomething=true
                scheduleKextTouch=true
            elif [ "$cuda" == 4 ]
                sudo "$cudaToolkitVolPath""$cudaToolkitPKGName" --accept-eula --silent --no-window --install-package="cuda-driver" --install-package="cuda-toolkit" --install-package="cuda-samples" &>/dev/null
                listOfChanges="$listOfChanges""\n""-CUDA developer drivers have been installed"
                listOfChanges="$listOfChanges""\n""-CUDA toolkit has been installed"
                listOfChanges="$listOfChanges""\n""-CUDA samples have been installed"
                scheduleReboot=true
                doneSomething=true
                scheduleKextTouch=true
            fi
            hdiutil detach "$cudaToolkitVolPath" -quiet
            rm -rf "$dirName""/cudaToolkit.dmg"
        fi
    fi
}


#   Subroutine F3: define NVIDIA driver installer
##  Patch installation requirements for new NVIDIA drivers
function patchNvidiaDriverNew {
    mktmpdir
    fetchOSinfo

    expansionTemp="$dirName""/nvidiaDriverExpansion"
    payloadTemp="$dirName""/payloadExpansion"
    mkdir "$payloadTemp"


    sudo pkgutil --expand "$dirName""/nvidiaDriver.pkg" "$expansionTemp"

    driverPathTemp=$(ls "$expansionTemp" | grep "NVWebDrivers.pkg")
    driverPathTemp="$expansionTemp""/""$driverPathTemp"

    sudo cat "$expansionTemp""/Distribution" | sed '/installation-check/d' | sudo tee "$expansionTemp""/PatchDist" &> /dev/null
    sudo mv "$expansionTemp""/PatchDist" "$expansionTemp""/Distribution"

    (cd "$payloadTemp"; sudo cat "$driverPathTemp""/Payload" | gunzip -dc | cpio -i --quiet)
    $pbuddy -c "Set IOKitPersonalities:NVDAStartup:NVDARequiredOS ""$build" "$payloadTemp""/Library/Extensions/NVDAStartupWeb.kext/Contents/Info.plist"
    sudo chown -R root:wheel "$payloadTemp/"*

    (cd "$payloadTemp"; sudo find . | sudo cpio -o --quiet | gzip -c | sudo tee "$driverPathTemp""/Payload" &> /dev/null)
    (cd "$payloadTemp"; sudo mkbom . "$driverPathTemp""/Bom")

    sudo rm -rf "$payloadTemp"
    sudo rm -rf "$dirName""/nvidiaDriver.pkg"

    sudo pkgutil --flatten "$expansionTemp" "$dirName""/nvidiaDriver.pkg"
    sudo chown "$(id -un):$(id -gn)" "$dirName""/nvidiaDriver.pkg"

    sudo rm -rf "$expansionTemp"
}

function patchNvidiaDriverOld {
    sudo "$pbuddy" -c "Set IOKitPersonalities:NVDAStartup:NVDARequiredOS ""$build" "$nvidiaDriverVersionPath"
}

function installNvidiaDriver {
    if ! "$omitNvidiaDriver"
    then
        if [ -e "$dirName""/nvidiaDriver.pkg" ]
        then
            sudo installer -pkg "$dirName""/nvidiaDriver.pkg" -target / &>/dev/null
        fi
    fi
}
























#   end of script
