#!/bin/bash

set -eu

ia_log "5.4." "Binutils - Pass 1"
ia_log "Approximate build time:" "1 SBU"
ia_log "Required disk space:" "580 MB"
echo

time {
  # extract package in a tmp dir
  tar -xf /sources/binutils-*.tar.xz -C /tmp/
  mv /tmp/binutils-* /tmp/binutils
  pushd /tmp/binutils

  # is recommended building in a dedicated dir
  mkdir -v build
  cd build

  # configure
  ../configure                 \
    --prefix=/tools            \
    --with-sysroot=$LFS        \
    --with-lib-path=/tools/lib \
    --target=$LFS_TGT          \
    --disable-nls              \
    --disable-werror

  # compile
  make

  # creates a symlink for 64-bit systems
  case $(uname -m) in
    x86_64) mkdir -v /tools/lib && ln -sv lib /tools/lib64 ;;
  esac

  # install
  make install

  # removes tmp dir
  popd
  rm -rf /tmp/binutils
}

