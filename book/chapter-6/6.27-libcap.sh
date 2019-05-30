#!/bin/bash

set -eu

echo "(chroot) 6.27" "Libcap"
echo "Approximate build time:" "0.1 SBU"
echo "Required disk space:" "1.4 MB"
echo

package=libcap-*.tar.xz
tmpDir=/tmp/libcap

# extract packages in a tmp dir
tar -xf /sources/$package -C /tmp/
mv -v $tmpDir* $tmpDir
pushd $tmpDir

# prevent static library from being installed
sed -i '/install.*STALIBNAME/d' libcap/Makefile

# compile
make

# install
make RAISE_SETFCAP=no lib=lib prefix=/usr install
chmod -v 755 /usr/lib/libcap.so.2.26

# move share libraries to /lib
mv -v /usr/lib/libcap.so.* /lib
ln -sfv ../../lib/$(readlink /usr/lib/libcap.so) /usr/lib/libcap.so

# removes tmp dir
popd
rm -rf $tmpDir

