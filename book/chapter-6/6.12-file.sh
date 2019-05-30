#!/bin/bash

set -eu

echo "(chroot) 6.12" "File"
echo "Approximate build time:" "0.1 SBU"
echo "Required disk space:" "18 MB"
echo

package=file-*.tar.gz
tmpDir=/tmp/file

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

# removes tmp dir
popd
rm -rf $tmpDir

