#!/bin/bash

set -eu

ia_log "5.33." "Textinfo"
ia_log "Approximate build time:" "0.3 SBU"
ia_log "Required disk space:" "104 MB"
echo

package=texinfo-*.tar.xz
tmpDir=/tmp/texinfo

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

