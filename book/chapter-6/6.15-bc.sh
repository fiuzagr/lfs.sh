#!/bin/bash

set -eu

echo "(chroot) 6.15" "Bc"
echo "Approximate build time:" "0.1 SBU"
echo "Required disk space:" "4.1 MB"
echo

package=bc-*.tar.gz
tmpDir=/tmp/bc

# extract packages in a tmp dir
tar -xf /sources/$package -C /tmp/
mv -v $tmpDir* $tmpDir
pushd $tmpDir

# change an internal script to use sed instead of ed
cat > bc/fix-libmath_h << "EOF"
#! /bin/bash
sed -e '1   s/^/{"/' \
    -e     's/$/",/' \
    -e '2,$ s/^/"/'  \
    -e   '$ d'       \
    -i libmath.h

sed -e '$ s/$/0}/' \
    -i libmath.h
EOF

# create temporary symlinks
ln -sv /tools/lib/libncursesw.so.6 /usr/lib/libncursesw.so.6
ln -sfv libncursesw.so.6 /usr/lib/libncurses.so

# fix configure issue
sed -i -e '/flex/s/as_fn_error/: ;; # &/' configure

# configure
./configure --prefix=/usr           \
            --with-readline         \
            --mandir=/usr/share/man \
            --infodir=/usr/share/info

# compile
make

# run tests
echo "quit" | ./bc/bc -l Test/checklib.b

# install
make install

# removes tmp dir
popd
rm -rf $tmpDir

