#!/bin/bash

set -eu

echo "(chroot) 6.18" "Mpfr"
echo "Approximate build time:" "1.0 SBU"
echo "Required disk space:" "37 MB"
echo

package=mpfr-*.tar.xz
tmpDir=/tmp/mpfr

# extract packages in a tmp dir
tar -xf /sources/$package -C /tmp/
mv -v $tmpDir* $tmpDir
pushd $tmpDir

# configure
./configure --prefix=/usr        \
            --disable-static     \
            --enable-thread-safe \
            --docdir=/usr/share/doc/mpfr-4.0.2

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

