#!/bin/bash

set -eu

echo "(chroot) 6.26" "Acl"
echo "Approximate build time:" "0.1 SBU"
echo "Required disk space:" "6.4 MB"
echo

package=acl-*.tar.gz
tmpDir=/tmp/acl

# extract packages in a tmp dir
tar -xf /sources/$package -C /tmp/
mv -v $tmpDir* $tmpDir
pushd $tmpDir

# configure
./configure --prefix=/usr         \
            --bindir=/bin         \
            --disable-static      \
            --libexecdir=/usr/lib \
            --docdir=/usr/share/doc/acl-2.2.53

# compile
make

# install
make install

# move share libraries to /lib
mv -v /usr/lib/libacl.so.* /lib
ln -sfv ../../lib/$(readlink /usr/lib/libacl.so) /usr/lib/libacl.so

# removes tmp dir
popd
rm -rf $tmpDir

