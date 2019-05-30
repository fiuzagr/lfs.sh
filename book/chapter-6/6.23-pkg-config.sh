#!/bin/bash

set -eu

echo "(chroot) 6.23" "Pkg-config"
echo "Approximate build time:" "0.3 SBU"
echo "Required disk space:" "30 MB"
echo

package=pkg-config-*.tar.gz
tmpDir=/tmp/pkg-config

# extract packages in a tmp dir
tar -xf /sources/$package -C /tmp/
mv -v $tmpDir* $tmpDir
pushd $tmpDir

# configure
./configure --prefix=/usr              \
            --with-internal-glib       \
            --disable-host-tool        \
            --docdir=/usr/share/doc/pkg-config-0.29.2

# compile
make

# run tests
make check

# install
make install

# removes tmp dir
popd
rm -rf $tmpDir

