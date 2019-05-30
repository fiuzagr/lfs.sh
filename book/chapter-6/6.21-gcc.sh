#!/bin/bash

set -eu

echo "(chroot) 6.21" "Gcc"
echo "Approximate build time:" "92 SBU"
echo "Required disk space:" "3.9 GB"
echo

package=gcc-*.tar.xz
tmpDir=/tmp/gcc

# extract packages in a tmp dir
tar -xf /sources/$package -C /tmp/
mv -v $tmpDir* $tmpDir
pushd $tmpDir

# changes the default directory
case $(uname -m) in
  x86_64)
    sed -e '/m64=/s/lib64/lib/' \
        -i.orig gcc/config/i386/t-linux64
  ;;
esac

# removes the symlink created earlier
rm -f /usr/lib/gcc

# building in a dedicated directory
mkdir -v build
cd build

# configure
SED=sed                               \
../configure --prefix=/usr            \
             --enable-languages=c,c++ \
             --disable-multilib       \
             --disable-bootstrap      \
             --disable-libmpx         \
             --with-system-zlib

# compile
make

# increase the stack size prior to running the tests
ulimit -s 32768

# removes one test known to cause a problem
rm ../gcc/testsuite/g++.dg/pr83239.C

# test as a non-root user
chown -Rv nobody .
su nobody -s /bin/bash -c "PATH=$PATH make -k check"

# test summary
touch /tmp/gcc-tests.log
../contrib/test_summary | grep -A7 Summ 2>&1 | tee /tmp/gcc-tests.log
sleep 3

# install
make install

# create a symlink required by the FHS
ln -sv ../usr/bin/cpp /lib

# create a symlink to cc
ln -sv gcc /usr/bin/cc

# add a compatibility symlink to enable building programs with LTO
install -v -dm755 /usr/lib/bfd-plugins
ln -sfv ../../libexec/gcc/$(gcc -dumpmachine)/8.2.0/liblto_plugin.so \
        /usr/lib/bfd-plugins/

# perform sanity check
echo 'int main(){}' > dummy.c
cc dummy.c -v -Wl,--verbose &> dummy.log
readelf -l a.out | grep ': /lib' 2>&1 | tee -a /tmp/gcc-tests.log
sleep 3

# make sure that we're setup to use correct start files
echo "\n======================================\n" >> /tmp/gcc-tests.log
grep -o '/usr/lib.*/crt[1in].*succeeded' dummy.log 2>&1 | tee -a /tmp/gcc-tests.log
sleep 3
# expected:
# /usr/lib/gcc/x86_64-pc-linux-gnu/8.2.0/../../../../lib/crt1.o succeeded
# /usr/lib/gcc/x86_64-pc-linux-gnu/8.2.0/../../../../lib/crti.o succeeded
# /usr/lib/gcc/x86_64-pc-linux-gnu/8.2.0/../../../../lib/crtn.o succeeded

# verify that the compiler is searching for the correct header files
echo "\n======================================\n" >> /tmp/gcc-tests.log
grep -B4 '^ /usr/include' dummy.log 2>&1 | tee -a /tmp/gcc-tests.log
sleep 3
# expected:
# #include <...> search starts here:
#  /usr/lib/gcc/x86_64-pc-linux-gnu/8.2.0/include
#  /usr/local/include
#  /usr/lib/gcc/x86_64-pc-linux-gnu/8.2.0/include-fixed
#  /usr/include

# verify that the new linker is being used with the correct search paths
echo "\n======================================\n" >> /tmp/gcc-tests.log
grep 'SEARCH.*/usr/lib' dummy.log |sed 's|; |\n|g' 2>&1 | tee -a /tmp/gcc-tests.log
sleep 3
# expected:
# SEARCH_DIR("/usr/x86_64-pc-linux-gnu/lib64")
# SEARCH_DIR("/usr/local/lib64")
# SEARCH_DIR("/lib64")
# SEARCH_DIR("/usr/lib64")
# SEARCH_DIR("/usr/x86_64-pc-linux-gnu/lib")
# SEARCH_DIR("/usr/local/lib")
# SEARCH_DIR("/lib")
# SEARCH_DIR("/usr/lib");

# make sure that we're using the correct libc
echo "\n======================================\n" >> /tmp/gcc-tests.log
grep "/lib.*/libc.so.6 " dummy.log 2>&1 | tee -a /tmp/gcc-tests.log
sleep 3
# expected:
# attempt to open /lib/libc.so.6 succeeded

# make sure GCC is using the correct dynamic linker
echo "\n======================================\n" >> /tmp/gcc-tests.log
grep found dummy.log 2>&1 | tee -a /tmp/gcc-tests.log
sleep 3
# expected:
# found ld-linux-x86-64.so.2 at /lib/ld-linux-x86-64.so.2

# clean up the tests
rm -v dummy.c a.out dummy.log

# move a misplaced file
mkdir -pv /usr/share/gdb/auto-load/usr/lib
mv -v /usr/lib/*gdb.py /usr/share/gdb/auto-load/usr/lib

# removes tmp dir
popd
rm -rf $tmpDir

