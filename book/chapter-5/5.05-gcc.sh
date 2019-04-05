#!/bin/bash

set -eu

ia_log "5.5." "GCC - Pass 1"
ia_log "Approximate build time:" "11 SBU"
ia_log "Required disk space:" "2.9 GB"
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
../configure                                     \
  --target=$LFS_TGT                              \
  --prefix=/tools                                \
  --with-glibc-version=2.11                      \
  --with-sysroot=$LFS                            \
  --with-newlib                                  \
  --without-headers                              \
  --with-local-prefix=/tools                     \
  --with-native-system-header-dir=/tools/include \
  --disable-nls                                  \
  --disable-shared                               \
  --disable-multilib                             \
  --disable-decimal-float                        \
  --disable-threads                              \
  --disable-libatomic                            \
  --disable-libgomp                              \
  --disable-libmpx                               \
  --disable-libquadmath                          \
  --disable-libssp                               \
  --disable-libvtv                               \
  --disable-libstdcxx                            \
  --enable-languages=c,c++

# compile and install
make
make install

# removes tmp dir
popd
rm -rf /tmp/gcc

