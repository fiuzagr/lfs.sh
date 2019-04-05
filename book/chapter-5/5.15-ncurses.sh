#!/bin/bash

set -eu

ia_log "5.15." "Ncurses"
ia_log "Approximate build time:" "0.6 SBU"
ia_log "Required disk space:" "41 MB"
echo

package=ncurses-*.tar.gz
tmpDir=/tmp/ncurses

# extract packages in a tmp dir
tar -xf /sources/$package -C /tmp/
mv -v $tmpDir* $tmpDir
pushd $tmpDir

# ensure that gawk is found first
sed -i s/mawk// configure

# configure
./configure       \
  --prefix=/tools \
  --with-shared   \
  --without-debug \
  --without-ada   \
  --enable-widec  \
  --enable-overwrite

# compile and install
make
make install

# creates symlink
ln -sv libncursesw.so /tools/lib/libncurses.so

# removes tmp dir
popd
rm -rf $tmpDir

