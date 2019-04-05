#!/bin/bash

set -eu

ia_log "5.32." "Tar"
ia_log "Approximate build time:" "0.3 SBU"
ia_log "Required disk space:" "38 MB"
echo

package=tar-*.tar.xz
tmpDir=/tmp/tar

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

