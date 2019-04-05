#!/bin/bash

set -eu

ia_log "5.11." "Tcl"
ia_log "Approximate build time:" "0.9 SBU"
ia_log "Required disk space:" "66 MB"
echo

# extract packages in a tmp dir
tar -xf /sources/tcl*-src.tar.gz -C /tmp/
mv /tmp/tcl* /tmp/tcl
pushd /tmp/tcl

# configure
cd unix
./configure --prefix=/tools

# compile
make

# run tests
TZ=UTC make test

# install
make install

# make lib writable
chmod -v u+w /tools/lib/libtcl8.6.so

# install headers
make install-private-headers

# creates a symlink
ln -sv tclsh8.6 /tools/bin/tclsh

# removes tmp dir
popd
rm -rf /tmp/tcl

