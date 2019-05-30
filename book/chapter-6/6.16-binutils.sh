#!/bin/bash

set -eu

echo "(chroot) 6.16" "Binutils"
echo "Approximate build time:" "6.9 SBU"
echo "Required disk space:" "4.9 MB"
echo

package=binutils-*.tar.xz
tmpDir=/tmp/binutils

# extract packages in a tmp dir
tar -xf /sources/$package -C /tmp/
mv -v $tmpDir* $tmpDir
pushd $tmpDir

# verify PTYs
expect -c "spawn ls"

# is recommended building in a dedicated dir
mkdir -v build
cd build

# configure
../configure --prefix=/usr       \
             --enable-gold       \
             --enable-ld=default \
             --enable-plugins    \
             --enable-shared     \
             --disable-werror    \
             --enable-64-bit-bfd \
             --with-system-zlib

# compile
make tooldir=/usr

# run tests
make -k check

# install
make tooldir=/usr install

# removes tmp dir
popd
rm -rf $tmpDir

