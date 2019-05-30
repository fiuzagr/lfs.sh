#!/bin/bash

set -eu

echo "(chroot) 6.11" "Zlib"
echo "Approximate build time:" "0.1 SBU"
echo "Required disk space:" "4.4 MB"
echo

package=zlib-*.tar.xz
tmpDir=/tmp/zlib

# extract packages in a tmp dir
tar -xf /sources/$package -C /tmp/
mv -v $tmpDir* $tmpDir
pushd $tmpDir

# configure
./configure --prefix=/usr

# compile
make

# run tests
make check

# install
make install

# make shared libs
mv -v /usr/lib/libz.so.* /lib
ln -sfv ../../lib/$(readlink /usr/lib/libz.so) /usr/lib/libz.so

# removes tmp dir
popd
rm -rf $tmpDir

