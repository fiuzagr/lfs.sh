#!/bin/bash

set -eux

ia_log "6.2" "Preparing virtual kernel file systems"
echo

# creating fs directories
mkdir -pv $LFS/{dev,proc,sys,run}

# creating initial device nodes
mknod -m 600 $LFS/dev/console c 5 1
mknod -m 666 $LFS/dev/null c 1 3

# mounting /dev
mount -v --bind /dev $LFS/dev

# mounting virtual kernel fs
mount -vt devpts devpts $LFS/dev/pts -o gid=5,mode=620
mount -vt proc proc $LFS/proc
mount -vt sysfs sysfs $LFS/sys
mount -vt tmpfs tmpfs $LFS/run

if [ -h $LFS/dev/shm ]
then
  mkdir -pv $LFS/$(readlink $LFS/dev/shm)
fi

