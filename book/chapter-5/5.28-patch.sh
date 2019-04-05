#!/bin/bash

set -eu

ia_log "5.28." "Patch"
ia_log "Approximate build time:" "0.2 SBU"
ia_log "Required disk space:" "12 MB"
echo

package=patch-*.tar.xz
tmpDir=/tmp/patch

# extract packages in a tmp dir
tar -xf /sources/$package -C /tmp/
mv -v $tmpDir* $tmpDir
pushd $tmpDir

# configure
./configure --prefix=/tools

# compile
make

# run tests
# tests fail in chapter 5
# make check

# install
make install

# removes tmp dir
popd
rm -rf $tmpDir

