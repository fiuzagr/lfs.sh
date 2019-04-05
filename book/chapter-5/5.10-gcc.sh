#!/bin/bash

set -eu

ia_log "5.10." "GCC - Pass 2"
ia_log "Approximate build time:" "14 SBU"
ia_log "Required disk space:" "3.4 GB"
echo

# extract packages in a tmp dir
tar -xf /sources/gcc-*.tar.xz -C /tmp/
mv /tmp/gcc-* /tmp/gcc
pushd /tmp/gcc
# MPFR
tar -xf /sources/mpfr-*.tar.xz
mv -v mpfr-* mpfr
# GMP
tar -xf /sources/gmp-*.tar.xz
mv -v gmp-* gmp
# MPC
tar -xf /sources/mpc-*.tar.gz
mv -v mpc-* mpc

# fix GCC hardcoded files
for file in gcc/config/{linux,i386/linux{,64}}.h
do
  cp -uv $file{,.orig}
  sed -e 's@/lib\(64\)\?\(32\)\?/ld@/tools&@g' \
      -e 's@/usr@/tools@g' $file.orig > $file
  echo '
#undef STANDARD_STARTFILE_PREFIX_1
#undef STANDARD_STARTFILE_PREFIX_2
#define STANDARD_STARTFILE_PREFIX_1 "/tools/lib/"
#define STANDARD_STARTFILE_PREFIX_2 ""' >> $file
  touch $file.orig
done

# set the default directory for 64-bit systems
case $(uname -m) in
  x86_64)
    sed -e '/m64=/s/lib64/lib/' \
        -i.orig gcc/config/i386/t-linux64
 ;;
esac

# is recommended building in a dedicated dir
mkdir -v build
cd build

# configure
CC=$LFS_TGT-gcc                                  \
CXX=$LFS_TGT-g++                                 \
AR=$LFS_TGT-ar                                   \
RANLIB=$LFS_TGT-ranlib                           \
../configure                                     \
  --prefix=/tools                                \
  --with-local-prefix=/tools                     \
  --with-native-system-header-dir=/tools/include \
  --enable-languages=c,c++                       \
  --disable-libstdcxx-pch                        \
  --disable-multilib                             \
  --disable-bootstrap                            \
  --disable-libgomp

# compile and install
make
make install

# creates a symlink
ln -sv gcc /tools/bin/cc

# removes tmp dir
popd
rm -rf /tmp/gcc

# performs a sanity check
echo 'int main(){}' > dummy.c
cc dummy.c
readelf -l a.out | grep ': /tools'
rm -v dummy.c a.out

