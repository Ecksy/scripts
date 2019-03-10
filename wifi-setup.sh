#!/bin/sh

# Shell script to set up drivers for Alfa AWUS036xxx
# You must have an internet connection.
#Script was current as of 03-10-2019

# update your repositories
apt-get update

# install dkms if it isn't already
apt-get install dkms

# change directory to /usr/src
cd /usr/src

# if you have any other drivers installed,remove them like so:
rm -r rtl8812AU-4.3.22/

# get latest driver from github
# used to be: git clone https://github.com/aircrack-ng/rtl8812au
git clone https://github.com/gordboy/rtl8812au.git

# move into downloaded driver folder
cd rtl8812au/

# update files in working tree to match files in the index 
# this step doesn't seem to be necessary anymore, commented out
# git checkout --track remotes/origin/v5.2.20

# make drivers
make

# move into parent directory
cd ..

# debugging
dkms status

# rename file for use with dkms
mv rtl8812au/ rtl8812au-5.2.20

# dkms add driver
dkms add -m rtl8812au -v 5.2.20 

# build drivers
dkms build -m rtl8812au -v 5.2.20

# install drivers
dkms install -m rtl8812au -v 5.2.20

# debugging
lsmod

# summon new interface from the depths of the kernel
modprobe 8812au

# wifi interface should now appear.
ip link
