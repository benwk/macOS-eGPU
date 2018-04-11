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

superUser=$(id -u)
if [ "$superUser" == 0 ]
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
    exit 0
fi
















#   end of script
