#!/bin/bash

set -eu

echo "(chroot) 6.29" "Psmisc"
echo "Approximate build time:" "0.1 SBU"
echo "Required disk space:" "4.5 MB"
echo

package=psmisc-*.tar.xz
tmpDir=/tmp/psmisc

# extract packages in a tmp dir
tar -xf /sources/$package -C /tmp/
mv -v $tmpDir* $tmpDir
pushd $tmpDir

# configure
./configure --prefix=/usr

# compile
make

# install
make install

# move fuser and killall
mv -v /usr/bin/fuser   /bin
mv -v /usr/bin/killall /bin

# removes tmp dir
popd
rm -rf $tmpDir

