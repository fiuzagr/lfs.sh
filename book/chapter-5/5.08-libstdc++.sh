#!/bin/bash

set -eu

ia_log "5.8." "Libstdc++"
ia_log "Approximate build time:" "0.5 SBU"
ia_log "Required disk space:" "803 MB"
echo

# extract package in a tmp dir
tar -xf /sources/gcc-*.tar.xz -C /tmp/
mv /tmp/gcc-* /tmp/gcc
pushd /tmp/gcc

# is recommended building in a dedicated dir
mkdir -v build
cd build

# configure
../libstdc++-v3/configure         \
  --host=$LFS_TGT                 \
  --prefix=/tools                 \
  --disable-multilib              \
  --disable-nls                   \
  --disable-libstdcxx-threads     \
  --disable-libstdcxx-pch         \
  --with-gxx-include-dir=/tools/$LFS_TGT/include/c++/8.2.0

# compile and install
make
make install

# removes tmp dir
popd
rm -rf /tmp/gcc

