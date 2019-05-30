#!/bin/bash

set -eu

echo "(chroot) 6.13" "Readline"
echo "Approximate build time:" "0.1 SBU"
echo "Required disk space:" "15 MB"
echo

package=readline-*.tar.gz
tmpDir=/tmp/readline

# extract packages in a tmp dir
tar -xf /sources/$package -C /tmp/
mv -v $tmpDir* $tmpDir
pushd $tmpDir

# avoid bug in ldconfig
sed -i '/MV.*old/d' Makefile.in
sed -i '/{OLDSUFF}/c:' support/shlib-install

# configure
./configure --prefix=/usr    \
  --disable-static           \
  --docdir=/usr/share/doc/readline-8.0

# compile
make SHLIB_LIBS="-L/tools/lib -lncursesw"

# install
make SHLIB_LIBS="-L/tools/lib -lncursesw" install

# move libs and fix up permissions and links
mv -v /usr/lib/lib{readline,history}.so.* /lib
chmod -v u+w /lib/lib{readline,history}.so.*
ln -sfv ../../lib/$(readlink /usr/lib/libreadline.so) /usr/lib/libreadline.so
ln -sfv ../../lib/$(readlink /usr/lib/libhistory.so ) /usr/lib/libhistory.so

# install docs
install -v -m644 doc/*.{ps,pdf,html,dvi} /usr/share/doc/readline-8.0

# removes tmp dir
popd
rm -rf $tmpDir

