#!/bin/bash

set -eu

ia_log "5.6." "Linux API Headers"
ia_log "Approximate build time:" "0.1 SBU"
ia_log "Required disk space:" "937 MB"
echo

# extract package in a tmp dir
tar -xf /sources/linux-*.tar.xz -C /tmp/
mv /tmp/linux-* /tmp/linux
pushd /tmp/linux

# mrproper
make mrproper

# headers_install
make INSTALL_HDR_PATH=dest headers_install
cp -rv dest/include/* /tools/include

# removes tmp dir
popd
rm -rf /tmp/linux

