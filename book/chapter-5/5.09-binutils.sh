#!/bin/bash

set -eu

ia_log "5.9." "Binutils - Pass 2"
ia_log "Approximate build time:" "1.1 SBU"
ia_log "Required disk space:" "598 MB"
echo

# extract package in a tmp dir
tar -xf /sources/binutils-*.tar.xz -C /tmp/
mv /tmp/binutils-* /tmp/binutils
pushd /tmp/binutils

# is recommended building in a dedicated dir
mkdir -v build
cd build

# configure
CC=$LFS_TGT-gcc              \
AR=$LFS_TGT-ar               \
RANLIB=$LFS_TGT-ranlib       \
../configure                 \
  --prefix=/tools            \
  --disable-nls              \
  --disable-werror           \
  --with-lib-path=/tools/lib \
  --with-sysroot

# compile and install
make
make install

# prepare the linker
make -C ld clean
make -C ld LIB_PATH=/usr/lib:/lib
cp -v ld/ld-new /tools/bin

# removes tmp dir
popd
rm -rf /tmp/binutils

