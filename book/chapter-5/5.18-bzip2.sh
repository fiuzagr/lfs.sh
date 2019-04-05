#!/bin/bash

set -eu

ia_log "5.18." "Bzip2"
ia_log "Approximate build time:" "<0.1 SBU"
ia_log "Required disk space:" "5.5 MB"
echo

package=bzip2-*.tar.gz
tmpDir=/tmp/bzip2

# extract packages in a tmp dir
tar -xf /sources/$package -C /tmp/
mv -v $tmpDir* $tmpDir
pushd $tmpDir

# compile
make

# install
make PREFIX=/tools install

# removes tmp dir
popd
rm -rf $tmpDir

