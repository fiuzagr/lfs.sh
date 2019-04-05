#!/bin/bash

set -eu

ia_log "5.19." "Coreutils"
ia_log "Approximate build time:" "0.8 SBU"
ia_log "Required disk space:" "148 MB"
echo

package=coreutils-*.tar.xz
tmpDir=/tmp/coreutils

# extract packages in a tmp dir
tar -xf /sources/$package -C /tmp/
mv -v $tmpDir* $tmpDir
pushd $tmpDir

# configure
./configure --prefix=/tools --enable-install-program=hostname

# compile
make

# run tests
# the `tail` tests is failing with docker container volume
# see: https://dnsglk.github.io/lfs/2018/06/28/lfs-coreutils-test-issue.html
# make RUN_EXPENSIVE_TESTS=yes check

# install
make install

# removes tmp dir
popd
rm -rf $tmpDir

