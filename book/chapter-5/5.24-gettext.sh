#!/bin/bash

set -eu

ia_log "5.24." "Gettext"
ia_log "Approximate build time:" "0.9 SBU"
ia_log "Required disk space:" "173 MB"
echo

package=gettext-*.tar.xz
tmpDir=/tmp/gettext

# extract packages in a tmp dir
tar -xf /sources/$package -C /tmp/
mv -v $tmpDir* $tmpDir
pushd $tmpDir

# configure
cd gettext-tools
EMACS="no" ./configure --prefix=/tools --disable-shared

# compile
make -C gnulib-lib
make -C intl pluralx.c
make -C src msgfmt
make -C src msgmerge
make -C src xgettext

# install some programs
cp -v src/{msgfmt,msgmerge,xgettext} /tools/bin

# removes tmp dir
popd
rm -rf $tmpDir

