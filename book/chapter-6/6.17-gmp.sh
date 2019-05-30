#!/bin/bash

set -eu

echo "(chroot) 6.17" "Gmp"
echo "Approximate build time:" "1.3 SBU"
echo "Required disk space:" "61 MB"
echo

package=gmp-*.tar.xz
tmpDir=/tmp/gmp

# extract packages in a tmp dir
tar -xf /sources/$package -C /tmp/
mv -v $tmpDir* $tmpDir
pushd $tmpDir

# configure
./configure --prefix=/usr    \
            --enable-cxx     \
            --disable-static \
            --docdir=/usr/share/doc/gmp-6.1.2

# compile package and doc
make
make html

# run tests
make check 2>&1 | tee gmp-check-log
# ensure that all 190 tests in the test suite passed
awk '/# PASS:/{total+=$3} ; END{print total}' gmp-check-log
sleep 3

# install package and doc
make install
make install-html

# removes tmp dir
popd
rm -rf $tmpDir

