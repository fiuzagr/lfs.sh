#!/bin/bash

set -eu

ia_log "5.27." "Make"
ia_log "Approximate build time:" "0.1 SBU"
ia_log "Required disk space:" "13 MB"
echo

package=make-*.tar.bz2
tmpDir=/tmp/make

# extract packages in a tmp dir
tar -xf /sources/$package -C /tmp/
mv -v $tmpDir* $tmpDir
pushd $tmpDir

# workaround an error caused by glibc
sed -i '211,217 d; 219,229 d; 232 d' glob/glob.c

# configure
./configure --prefix=/tools --without-guile

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

