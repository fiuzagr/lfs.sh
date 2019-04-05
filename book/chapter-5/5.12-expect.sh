#!/bin/bash

set -eu

ia_log "5.12." "Expect"
ia_log "Approximate build time:" "0.1 SBU"
ia_log "Required disk space:" "3.9 MB"
echo

# extract packages in a tmp dir
tar -xf /sources/expect*.tar.gz -C /tmp/
mv /tmp/expect* /tmp/expect
pushd /tmp/expect

# force the use of /bin/stty
cp -v configure{,.orig}
sed 's:/usr/local/bin:/bin:' configure.orig > configure

# configure
./configure             \
  --prefix=/tools       \
  --with-tcl=/tools/lib \
  --with-tclinclude=/tools/include

# compile
make

# run tests
make test

# install
make SCRIPTS="" install

# removes tmp dir
popd
rm -rf /tmp/expect

