#!/bin/bash

set -eu

ia_log "5.40." "Python"
ia_log "Approximate build time:" "1.5 SBU"
ia_log "Required disk space:" "371 MB"
echo

package=Python-*.tar.xz
tmpDir=/tmp/Python

# extract packages in a tmp dir
tar -xf /sources/$package -C /tmp/
mv -v $tmpDir* $tmpDir
pushd $tmpDir

# prevents use of hard-coded paths
sed -i '/def add_multiarch_paths/a \        return' setup.py

# configure
./configure --prefix=/tools --without-ensurepip

# compile
make

# install
make install

# removes tmp dir
popd
rm -rf $tmpDir

