#!/bin/bash

set -eu

ia_log "5.14." "M4"
ia_log "Approximate build time:" "0.2 SBU"
ia_log "Required disk space:" "20 MB"
echo

package=m4-*.tar.xz
tmpDir=/tmp/m4

# extract packages in a tmp dir
tar -xf /sources/$package -C /tmp/
mv -v $tmpDir* $tmpDir
pushd $tmpDir

# make some fixes required by glibc
sed -i 's/IO_ftrylockfile/IO_EOF_SEEN/' lib/*.c
echo "#define _IO_IN_BACKUP 0x100" >> lib/stdio-impl.h

# configure
./configure --prefix=/tools

# compile
make

# run tests
make check

# install
make install

# removes tmp dir
popd
rm -rf $tmpDir

