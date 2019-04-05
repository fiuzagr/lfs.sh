#!/bin/bash

set -eu

ia_log "5.35." "Stripping"
echo

# strip debug items
strip --strip-debug /tools/lib/*

# strip unneeded
/usr/bin/strip --strip-unneeded /tools/{,s}bin/*

# remove documentation
rm -rf /tools/{,share}/{info,man,doc}

# remove unneeded files
find /tools/{lib,libexec} -name \*.la -delete

