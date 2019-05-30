#!/bin/bash

set -eu

echo "(chroot) 6.19" "Mpc"
echo "Approximate build time:" "0.3 SBU"
echo "Required disk space:" "22 MB"
echo

package=mpc-*.tar.gz
tmpDir=/tmp/mpc

# extract packages in a tmp dir
tar -xf /sources/$package -C /tmp/
mv -v $tmpDir* $tmpDir
pushd $tmpDir

# configure
./configure --prefix=/usr    \
            --disable-static \
            --docdir=/usr/share/doc/mpc-1.1.0

# compile package and doc
make
make html

# run tests
make check

# install package and doc
make install
make install-html

# removes tmp dir
popd
rm -rf $tmpDir

