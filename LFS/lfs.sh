#!/bin/bash

export LFS=/mnt/lfs
export LFS_TGT=x86_64-lfs-linux-gnu
export LFS_DISK=/dev/sda
#check if the file is munted or not , all mounted files can be checked on /proc/mounts/

if ! grep -q "$LFS" /proc/mounts; then
  source setupdisk.sh "$LFS_DISK"
  #as the patition has been created mount it to use it b a system
  sudo mount "$(LFS_DISK)2" "LFS"
  #change the owner to myself
  sudo chown -v $USER "$LFS"
fi
#this is where intermidiate cross compiler compiling from A to B will sit
mkdir -pv $LFS/sources
mkdir -pv $LFS/tools

mkdir -pv $LFS/boot
mkdir -pv $LFS/etc
mkdir -pv $LFS/bin
mkdir -pv $LFS/lib
mkdir -pv $LFS/sbin
mkdir -pv $LFS/usr
mkdir -pv $LFS/var

case $(uname -m) in
x86_64) mkdir -pv $LFS/lib64 ;;
esac

#after the directories are created now start installing stuff
