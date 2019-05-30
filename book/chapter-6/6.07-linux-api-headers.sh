#!/bin/bash

set -eu

echo "(chroot) 6.7" "Linux API headers"
echo "Approximate build time:" "0.1 SBU"
echo "Required disk space:" "941 MB"
echo

package=linux-*.tar.xz
tmpDir=/tmp/linux

# extract packages in a tmp dir
tar -xf /sources/$package -C /tmp/
mv -v $tmpDir* $tmpDir
pushd $tmpDir

# mrproper
make mrproper

# install headers
make INSTALL_HDR_PATH=dest headers_install
find dest/include \( -name .install -o -name ..install.cmd \) -delete
cp -rv dest/include/* /usr/include

# removes tmp dir
popd
rm -rf $tmpDir

