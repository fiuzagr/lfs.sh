#!/bin/bash

set -eu

ia_log "5.29." "Perl"
ia_log "Approximate build time:" "1.5 SBU"
ia_log "Required disk space:" "275 MB"
echo

package=perl-*.tar.xz
tmpDir=/tmp/perl

# extract packages in a tmp dir
tar -xf /sources/$package -C /tmp/
mv -v $tmpDir* $tmpDir
pushd $tmpDir

# configure
sh Configure -des -Dprefix=/tools -Dlibs=-lm -Uloclibpth -Ulocincpth

# compile
make

# install only a few of utilities and libraries
cp -v perl cpan/podlators/scripts/pod2man /tools/bin
mkdir -pv /tools/lib/perl5/5.28.1
cp -Rv lib/* /tools/lib/perl5/5.28.1

# removes tmp dir
popd
rm -rf $tmpDir

