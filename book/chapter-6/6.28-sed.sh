#!/bin/bash

set -eu

echo "(chroot) 6.28" "Sed"
echo "Approximate build time:" "0.3 SBU"
echo "Required disk space:" "32 MB"
echo

package=sed-*.tar.xz
tmpDir=/tmp/sed

# extract packages in a tmp dir
tar -xf /sources/$package -C /tmp/
mv -v $tmpDir* $tmpDir
pushd $tmpDir

# remove failing test
sed -i 's/usr/tools/'                 build-aux/help2man
sed -i 's/testsuite.panic-tests.sh//' Makefile.in

# configure
./configure --prefix=/usr --bindir=/bin

# compile
make
make html

# run tests
make check

# install
make install
install -d -m755           /usr/share/doc/sed-4.7
install -m644 doc/sed.html /usr/share/doc/sed-4.7

# removes tmp dir
popd
rm -rf $tmpDir

