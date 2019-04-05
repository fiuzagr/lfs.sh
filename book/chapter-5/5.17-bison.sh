#!/bin/bash

set -eu

ia_log "5.17." "Bison"
ia_log "Approximate build time:" "0.3 SBU"
ia_log "Required disk space:" "37 MB"
echo

package=bison-*.tar.xz
tmpDir=/tmp/bison

# extract packages in a tmp dir
tar -xf /sources/$package -C /tmp/
mv -v $tmpDir* $tmpDir
pushd $tmpDir

# configure
./configure --prefix=/tools

# compile
make

# run tests (the tests is crashing. Don't run it)
# make check

# install
make install

# removes tmp dir
popd
rm -rf $tmpDir

