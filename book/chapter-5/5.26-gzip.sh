#!/bin/bash

set -eu

ia_log "5.26." "Gzip"
ia_log "Approximate build time:" "0.1 SBU"
ia_log "Required disk space:" "10 MB"
echo

package=gzip-*.tar.xz
tmpDir=/tmp/gzip

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

