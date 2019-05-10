#!/bin/sh

echo "Prerpare stuff ... "
sudo apt-get update
sudo apt-get install git android-tools-adb android-tools-fastboot

# Setup ADB rules, ...
adb devices
sudo cp 51-android.rules /etc/udev/rules.d
cp adb_usb.ini ~/.android/

# Restart services
sudo service udev restart
adb kill-server
adb devices
