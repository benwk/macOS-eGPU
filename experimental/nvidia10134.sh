#!/bin/bash

#   You may not redistribute this script under no circumstances. You may ONLY link to the post on eGPU.io.
#   You accept the license terms of all downloaded and/or executed content, even content that has not been downloaded and/or executed by this script directly.
#   You may not use this script, or portions thereof, for any commercial purposes.


#   THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
#   IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
#   FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
#   AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
#   LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
#   OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
#   THE SOFTWARE.



echo
echo

dirName="$(uuidgen)"
dirName="/var/tmp/""macOS-eGPU-""$dirName"


function exitFail {
    rm -rfv "$dirName"
    hdiutil detach "/Volumes/macOS High Sierra 10.13.3 Update Combo/"
    echo
    echo "The script has failed."
    exit
}

superUser=$(id -u)
if [ "$superUser" == 0 ]
then
    if [ "$1" == "--uninstall" ]
    then
        echo "The script will now uninstall..."
        echo "DO NOT STOP THE SCRIPT!"
        trap '' INT
        if [ -e "/Library/Extensions/NVDAEGPUSupport.kext" ]
        then
            rm -rfv "/Library/Extensions/NVDAEGPUSupport.kext"
        fi
        if [ -e "/Library/PreferencePanes/NVIDIA Driver Manager.prefPane/Contents/MacOS/NVIDIA Web Driver Uninstaller.app/Contents/Resources/NVUninstall.pkg" ]
        then
            installer -pkg "/Library/PreferencePanes/NVIDIA Driver Manager.prefPane/Contents/MacOS/NVIDIA Web Driver Uninstaller.app/Contents/Resources/NVUninstall.pkg" -target /
        fi
        if [ -e "/Library/Application Support/nvidia10134/AppleGPUWrangler.kext" ]
        then
            rm -rfv "/System/Library/Extensions/AppleGraphicsControl.kext/Contents/PlugIns/AppleGPUWrangler.kext"
            cp -R -f -v "/Library/Application Support/nvidia10134/AppleGPUWrangler.kext" "/System/Library/Extensions/AppleGraphicsControl.kext/Contents/PlugIns/"
            rm -rfv "/Library/Application Support/nvidia10134/"
            chown -R root:wheel /System/Library/Extensions/AppleGraphicsControl.kext/Contents/Plugins/AppleGPUWrangler.kext
            chmod -R 755 /System/Library/Extensions/AppleGraphicsControl.kext/Contents/Plugins/AppleGPUWrangler.kext
            touch /System/Library/Extensions
            kextcache -q -update-volume /
            touch /System/Library/Extensions
            kextcache -system-caches
        fi

        echo "The script has finished."
        reboot &
        exit
    else
        mkdir "$dirName"
        echo "The script will now install..."
        echo "DO NOT STOP THE SCRIPT!"
        trap '' INT
        echo "Downloading content and preparing content..."
        sleep 1
        echo
        curl -o "$dirName""/pbzx.zip" -L "https://github.com/NiklasRosenstein/pbzx/releases/download/v1.0.2/pbzx-1.0.2.zip"
        shaPbzxTemp=$(shasum -a 512 -b "$dirName""/pbzx.zip" | awk '{ print $1 }')
        echo "$shaPbzxTemp"
        if [ "$shaPbzxTemp" != "9b5cafef5eed22f0eef70c95f1aead30d2f6719b06972fb987ae6629ca13fc407cfe4a09e386318ba965f01054dac68f0abf32fa2d0b5a063b013ad9105a3730" ]
        then
            exitFail
        fi
        mkdir "$dirName""/pbzxParser"
        unzip "$dirName""/pbzx.zip" -d "$dirName""/pbzxParser/"

        echo
        curl -o "$dirName""/enabler.zip" "https://egpu.io/wp-content/uploads/wpforo/attachments/71/4793-NVDAEGPUSuppor-v8.zip"
        shaEnablerTemp=$(shasum -a 512 -b "$dirName""/enabler.zip" | awk '{ print $1 }')
        echo "$shaEnablerTemp"
        if [ "$shaEnablerTemp" != "dba78baa2c7202ff4bd316d8a6cb928058529fcf4f99a3d2eed286907aab9dfde147451348010d89b3bdebd5aad0e51ebe89ba08f7ac0d50ddaa6dccddf74cd8" ]
        then
            exitFail
        fi
        mkdir "$dirName""/enabler"
        unzip "$dirName""/enabler.zip" -d "$dirName""/enabler/"

        echo
        curl -o "$dirName""/nvidiaDriver.pkg" "https://images.nvidia.com/mac/pkg/387/WebDriver-387.10.10.10.30.103.pkg"
        shaDriverTemp=$(shasum -a 512 -b "$dirName""/nvidiaDriver.pkg" | awk '{ print $1 }')
        echo "$shaDriverTemp"
        if [ "$shaDriverTemp" != "d5943b93482c76af5e9565466a1c730d8cb2577bfe54d813d2c06fdea7f49c088b380958e7c6c61e3b660fc077f06b83ec633abf6b1b4a56d16a71180f0d481e" ]
        then
            exitFail
        fi

        echo
        curl -o "$dirName"/"macUpdate.dmg" "http://appldnld.apple.com/macos/091-62781-20180122-E05AC734-FD4B-11E7-9470-89FAE74B5A3D/macOSUpdCombo10.13.3.dmg"
        hdiutil attach "$dirName"/"macUpdate.dmg" -nobrowse
        if [ "$?" == 1 ]
        then
            exitFail
        fi

        echo
        echo "Installing NVIDIA drivers..."
        if [ -e "/Library/PreferencePanes/NVIDIA Driver Manager.prefPane/Contents/MacOS/NVIDIA Web Driver Uninstaller.app/Contents/Resources/NVUninstall.pkg" ]
        then
            installer -pkg "/Library/PreferencePanes/NVIDIA Driver Manager.prefPane/Contents/MacOS/NVIDIA Web Driver Uninstaller.app/Contents/Resources/NVUninstall.pkg" -target /
        fi
        installer -pkg "$dirName"/"nvidiaDriver.pkg" -target /

        echo "Installing enabler..."
        if [ -e "/Library/Extensions/NVDAEGPUSupport.kext" ]
        then
            rm -rfv "/Library/Extensions/NVDAEGPUSupport.kext"
        fi
        installer -pkg "$dirName""/enabler/NVDAEGPUSuppor-v8.pkg" -target /

        echo "expanding package..."
        sleep 1
        pkgutil --expand "/Volumes/macOS High Sierra 10.13.3 Update Combo/macOSUpdCombo10.13.3.pkg" "$dirName""/macUpdateExpansion"
        echo "Parsing package contents..."
        sleep 1
        mkdir "$dirName""/parsedUpdate"
        (cd "$dirName""/parsedUpdate"; "$dirName""/pbzxParser/pbzx" -n "$dirName""/macUpdateExpansion/macOSUpdCombo10.13.3.pkg/Payload" | cpio -idv)

        echo "Creating KEXT Backup"
        mkdir "/Library/Application Support/nvidia10134"
        cp -n -R "/System/Library/Extensions/AppleGraphicsControl.kext/Contents/PlugIns/AppleGPUWrangler.kext" "/Library/Application Support/nvidia10134/"

        echo "Patching System..."
        rm -rfv "/System/Library/Extensions/AppleGraphicsControl.kext/Contents/PlugIns/AppleGPUWrangler.kext"
        cp -R -f -v "$dirName""/parsedUpdate/System/Library/Extensions/AppleGraphicsControl.kext/Contents/PlugIns/AppleGPUWrangler.kext" "/System/Library/Extensions/AppleGraphicsControl.kext/Contents/PlugIns/"

        chown -R root:wheel /System/Library/Extensions/AppleGraphicsControl.kext/Contents/Plugins/AppleGPUWrangler.kext
        chmod -R 755 /System/Library/Extensions/AppleGraphicsControl.kext/Contents/Plugins/AppleGPUWrangler.kext
        touch /System/Library/Extensions
        kextcache -q -update-volume /
        touch /System/Library/Extensions
        kextcache -system-caches

        hdiutil detach "/Volumes/macOS High Sierra 10.13.3 Update Combo/"
        rm -rfv "$dirName"
        echo "The script has finished."
        reboot &
        exit
    fi
fi
















#   end of script
