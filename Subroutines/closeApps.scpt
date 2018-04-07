#!/bin/osascript
#   closeApps.scpt
#
#   This script handles CUDA driver uninstallation.
#
#   Created by learex on 07.04.18.
#
#   Authors: learex
#   Homepage: https://github.com/learex/macOS-eGPU

#   beginning of script

tell application "System Events" to set quitapps to name of every application process whose visible is true and name is not "Finder" and name is not "Terminal"repeat with closeall in quitapps	quit application closeallend repeat

#   end of script
