#!/bin/bash

set -eu

echo "(chroot) 6.10" "Adjusting the toolchain"
echo

# backup and replace the /tools linker
mv -v /tools/bin/{ld,ld-old}
mv -v /tools/$(uname -m)-pc-linux-gnu/bin/{ld,ld-old}
mv -v /tools/bin/{ld-new,ld}
ln -sv /tools/bin/ld /tools/$(uname -m)-pc-linux-gnu/bin/ld

# amend the GCC specs file
gcc -dumpspecs | sed -e 's@/tools@@g'                 \
  -e '/\*startfile_prefix_spec:/{n;s@.*@/usr/lib/ @}' \
  -e '/\*cpp:/{n;s@$@ -isystem /usr/include@}' >      \
  `dirname $(gcc --print-libgcc-file-name)`/specs

# performs sanity checks
echo 'int main(){}' > dummy.c
cc dummy.c -v -Wl,--verbose &> dummy.log
readelf -l a.out | grep ': /lib'
# expected:
# [Requesting program interpreter: /lib64/ld-linux-x86-64.so.2]

# make sure that we're setup to use the correct start files
grep -o '/usr/lib.*/crt[1in].*succeeded' dummy.log
sleep 3
# expected:
# /usr/lib/../lib/crt1.o succeeded
# /usr/lib/../lib/crti.o succeeded
# /usr/lib/../lib/crtn.o succeeded

# verify that the compiler is searching for the correct header files
grep -B1 '^ /usr/include' dummy.log
sleep 3
# expected:
# include <...> search starts here:
# /usr/include

# verify that the new linker is being used with the correct search pats
grep 'SEARCH.*/usr/lib' dummy.log |sed 's|; |\n|g'
sleep 3
# expected:
# SEARCH_DIR("/usr/lib")
# SEARCH_DIR("/lib")

# make sure that we're using the corret libc
grep "/lib.*/libc.so.6 " dummy.log
sleep 3
# expected:
# attempt to open /lib/libc.so.6 succeeded

# make sure GCC is using the correct dynamic linker
grep found dummy.log
sleep 3
# expected:
# found ld-linux-x86-64.so.2 at /lib/ld-linux-x86-64.so.2

# clean up the test files
rm -v dummy.c a.out dummy.log

