#!/bin/bash

set -eu

ia_log "5.7." "Glibc"
ia_log "Approximate build time:" "5.1 SBU"
ia_log "Required disk space:" "885 MB"
echo

# extract package in a tmp dir
tar -xf /sources/glibc-*.tar.xz -C /tmp/
mv /tmp/glibc-* /tmp/glibc
pushd /tmp/glibc

# is recommended building in a dedicated dir
mkdir -v build
cd build

# configure
../configure                         \
  --prefix=/tools                    \
  --host=$LFS_TGT                    \
  --build=$(../scripts/config.guess) \
  --enable-kernel=3.2                \
  --with-headers=/tools/include

# compile and install
make
make install

# removes tmp dir
popd
rm -rf /tmp/glibc

# performs a sanity check
echo 'int main(){}' > dummy.c
$LFS_TGT-gcc dummy.c
readelf -l a.out | grep ': /tools'
rm -v dummy.c a.out

