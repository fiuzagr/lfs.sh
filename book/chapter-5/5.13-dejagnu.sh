#!/bin/bash

set -eu

ia_log "5.13." "DejaGNU"
ia_log "Approximate build time:" "0.1 SBU"
ia_log "Required disk space:" "3.3 MB"
echo

# extract packages in a tmp dir
tar -xf /sources/dejagnu-*.tar.gz -C /tmp/
mv /tmp/dejagnu* /tmp/dejagnu
pushd /tmp/dejagnu

# configure
./configure --prefix=/tools

# compile and install
make install

# run tests
make check

# removes tmp dir
popd
rm -rf /tmp/dejagnu

