#!/bin/bash

set -eux

ia_log "3.1." "Introduction"
echo

lfsUrl="http://www.linuxfromscratch.org/lfs/view/stable"
wgetParams="-c -N -nv --progress=bar:force --show-progress"
syslinuxUrl="https://www.kernel.org/pub/linux/utils/boot/syslinux"
syslinuxPackage="syslinux-6.03.tar.xz"
syslinuxShasum="26d3986d2bea109d5dc0e4f8c4822a459276cf021125e8c9f23c3cca5d8c850e"

cd "$LFS/sources"

ia_log "Getting all source packages"
echo
wget $wgetParams "$lfsUrl/wget-list"
wget $wgetParams --input-file=wget-list

wget $wgetParams "$syslinuxUrl/$syslinuxPackage"


ia_log "Checking all source packages"
echo
wget $wgetParams "$lfsUrl/md5sums"
md5sum -c md5sums
echo "$syslinuxShasum $LFS/sources/$syslinuxPackage" | sha256sum -c -
