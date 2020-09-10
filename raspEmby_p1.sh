#!/bin/bash
# This script download Emby then help the user setup his external drive to be used by Emby.
# This is part 1.

echo "At the end of the script, your computer will restart."
echo "Checking if your Raspberry can run Emby.."
cpu=$(cat /proc/cpuinfo | grep "model name")

if [[ "$cpu" == *"ARMv7"* ]]; then
        downloadLink="https://github.com/MediaBrowser/Emby.Releases/releases/download/4.4.3.0/emby-server-deb_4.4.3.0_armhf.deb"
elif [[ "$cpu" == *"ARMv8"* ]]; then
        downloadLink="https://github.com/MediaBrowser/Emby.Releases/releases/download/4.4.3.0/emby-server-deb_4.4.3.0_arm64.deb"
else
        echo "Your Raspberry doesn't have the requirements to install Emby"
        exit 0
fi

echo "Downloading Emby.."
$(wget "$downloadLink" -q --show-progress)
filename=$(ls | grep *.deb)
dpkg -i "$filename"
localIp=$(hostname -I | awk '{print $1}')
echo "To connect to Emby, access "$localIp":8096"
groupadd movies
usermod -aG movies emby
echo "What will be your new external drive name ?"
read newExternalDriveName
sudo mkdir -p /mnt/"$newExternalDriveName"
df
echo "Find the name of your external drive in this list, it's often something like '/dev/sda1', external drive are often mounted on /media, or you can guess by its size."
read externalDriveName
echo "UUID=$(lsblk -no UUID $externalDriveName") /media/"$newExternalDriveName" ntfs-3g permissions,nofail,auto 0 0" | sudo tee --append /etc/fstab

echo "Rebooting.."
sudo reboot
