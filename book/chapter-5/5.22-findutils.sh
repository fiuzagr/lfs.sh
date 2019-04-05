#!/bin/bash

set -eu

ia_log "5.22." "Findutils"
ia_log "Approximate build time:" "0.3 SBU"
ia_log "Required disk space:" "36 MB"
echo

package=findutils-*.tar.gz
tmpDir=/tmp/findutils

# extract packages in a tmp dir
tar -xf /sources/$package -C /tmp/
mv -v $tmpDir* $tmpDir
pushd $tmpDir

# make some fixes required by glibc
sed -i 's/IO_ftrylockfile/IO_EOF_SEEN/' gl/lib/*.c
sed -i '/unistd/a #include <sys/sysmacros.h>' gl/lib/mountlist.c
echo "#define _IO_IN_BACKUP 0x100" >> gl/lib/stdio-impl.h

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

