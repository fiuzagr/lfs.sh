#!/bin/bash

set -eu

echo "(chroot) 6.25" "Attr"
echo "Approximate build time:" "0.1 SBU"
echo "Required disk space:" "4.2 MB"
echo

package=attr-*.tar.gz
tmpDir=/tmp/attr

# extract packages in a tmp dir
tar -xf /sources/$package -C /tmp/
mv -v $tmpDir* $tmpDir
pushd $tmpDir

# configure
./configure --prefix=/usr     \
            --bindir=/bin     \
            --disable-static  \
            --sysconfdir=/etc \
            --docdir=/usr/share/doc/attr-2.4.48

# compile
make

# run tests
make check

# install
make install

# move share libraries to /lib
mv -v /usr/lib/libattr.so.* /lib
ln -sfv ../../lib/$(readlink /usr/lib/libattr.so) /usr/lib/libattr.so

# removes tmp dir
popd
rm -rf $tmpDir

