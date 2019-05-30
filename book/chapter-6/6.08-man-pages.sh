#!/bin/bash

set -eu

echo "(chroot) 6.8" "Man pages"
echo "Approximate build time:" "0.1 SBU"
echo "Required disk space:" "28 MB"
echo

package=man-pages-*.tar.xz
tmpDir=/tmp/man-pages

# extract packages in a tmp dir
tar -xf /sources/$package -C /tmp/
mv -v $tmpDir* $tmpDir
pushd $tmpDir

# install
make install

# removes tmp dir
popd
rm -rf $tmpDir

