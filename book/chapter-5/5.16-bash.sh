#!/bin/bash

set -eu

ia_log "5.16." "Bash"
ia_log "Approximate build time:" "0.4 SBU"
ia_log "Required disk space:" "67 MB"
echo

package=bash-*.tar.gz
tmpDir=/tmp/bash

# extract packages in a tmp dir
tar -xf /sources/$package -C /tmp/
mv -v $tmpDir* $tmpDir
pushd $tmpDir

# configure
./configure --prefix=/tools --without-bash-malloc

# compile
make

# run tests
make tests

# install
make install

# creates a symlink
ln -sv bash /tools/bin/sh

# removes tmp dir
popd
rm -rf $tmpDir

