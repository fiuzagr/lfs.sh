#!/bin/bash

set -eu

echo "(chroot) 6.22" "Bzip2"
echo "Approximate build time:" "0.1 SBU"
echo "Required disk space:" "2.3 MB"
echo

package=bzip2-*.tar.gz
tmpDir=/tmp/bzip2

# extract packages in a tmp dir
tar -xf /sources/$package -C /tmp/
mv -v $tmpDir* $tmpDir
pushd $tmpDir

# apply path
patch -Np1 -i /sources/bzip2-1.0.6-install_docs-1.patch

# ensures relative symlinks
sed -i 's@\(ln -s -f \)$(PREFIX)/bin/@\1@' Makefile

# ensures correct location of the man pages
sed -i "s@(PREFIX)/man@(PREFIX)/share/man@g" Makefile

# prepare
make -f Makefile-libbz2_so
make clean

# compile
make

# install
make PREFIX=/usr install

# make some necessary symlinks and clean up
cp -v bzip2-shared /bin/bzip2
cp -av libbz2.so* /lib
ln -sv ../../lib/libbz2.so.1.0 /usr/lib/libbz2.so
rm -v /usr/bin/{bunzip2,bzcat,bzip2}
ln -sv bzip2 /bin/bunzip2
ln -sv bzip2 /bin/bzcat

# removes tmp dir
popd
rm -rf $tmpDir

