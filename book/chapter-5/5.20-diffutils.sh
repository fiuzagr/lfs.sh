#!/bin/bash

set -eu

ia_log "5.20." "Diffutils"
ia_log "Approximate build time:" "0.2 SBU"
ia_log "Required disk space:" "26 MB"
echo

package=diffutils-*.tar.xz
tmpDir=/tmp/diffutils

# extract packages in a tmp dir
tar -xf /sources/$package -C /tmp/
mv -v $tmpDir* $tmpDir
pushd $tmpDir

# configure
./configure --prefix=/tools

# compile
make

# run tests
make check

# install
make install

# removes tmp dir
popd
rm -rf $tmpDir

