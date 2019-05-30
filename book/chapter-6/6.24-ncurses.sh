#!/bin/bash

set -eu

echo "(chroot) 6.24" "Ncurses"
echo "Approximate build time:" "0.3 SBU"
echo "Required disk space:" "42 MB"
echo

package=ncurses-*.tar.gz
tmpDir=/tmp/ncurses

# extract packages in a tmp dir
tar -xf /sources/$package -C /tmp/
mv -v $tmpDir* $tmpDir
pushd $tmpDir

# don't install a static library
sed -i '/LIBTOOL_INSTALL/d' c++/Makefile.in

# configure
./configure --prefix=/usr           \
            --mandir=/usr/share/man \
            --with-shared           \
            --without-debug         \
            --without-normal        \
            --enable-pc-files       \
            --enable-widec

# compile
make

# install
make install

# move share libraries to /lib
mv -v /usr/lib/libncursesw.so.6* /lib

# recreate file
ln -sfv ../../lib/$(readlink /usr/lib/libncursesw.so) /usr/lib/libncursesw.so

# recreate files and symlinks
for lib in ncurses form panel menu ; do
    rm -vf                    /usr/lib/lib${lib}.so
    echo "INPUT(-l${lib}w)" > /usr/lib/lib${lib}.so
    ln -sfv ${lib}w.pc        /usr/lib/pkgconfig/${lib}.pc
done

# old applications still buildable
rm -vf                     /usr/lib/libcursesw.so
echo "INPUT(-lncursesw)" > /usr/lib/libcursesw.so
ln -sfv libncurses.so      /usr/lib/libcurses.so

# install docs
mkdir -v       /usr/share/doc/ncurses-6.1
cp -v -R doc/* /usr/share/doc/ncurses-6.1

# removes tmp dir
popd
rm -rf $tmpDir

