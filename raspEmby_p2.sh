#!/bin/bash
# This script download Emby then help the user setup his external drive to be used by Emby.
# This is part 1.

echo "What was your external drive name ?"
read externalDriveName

sudo chown -R root:movies /media/"$externalDriveName"
sudo chmod -R u+rwX /media/"$externalDriveName"
sudo chmod -R g+rwX /media/"$externalDriveName"
sudo chmod -R o+rX /media/"$externalDriveName"
echo "Restarting Emby server.."
sudo systemctl restart emby-server
echo "And we're done !"