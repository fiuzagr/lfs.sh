#!/bin/bash

set -eux

ia_log "Chapter 6." "Installing basic system software"
echo

bash "$LFS_BOOK_HOME/chapter-6/6.02-preparing-virtual-kernel-fs.sh"

# ensure that /book exists inside chrooted env
mkdir -pv $LFS/book
mount -v --bind /book $LFS/book

chroot "$LFS" /tools/bin/env -i                                \
  HOME=/root TERM="$TERM" PS1='(lfs chroot) \u:\w\$ '          \
  PATH=/bin:/usr/bin:/sbin:/usr/sbin:/tools/bin:/usr/local/bin \
  LFS="$LFS" LFS_TGT="$LFS_TGT" LFS_BOOK_HOME="$LFS_BOOK_HOME" \
  LC_ALL="$LC_ALL" MAKEFLAGS="$MAKEFLAGS"                      \
  /tools/bin/bash --login +h                                   \
  -c "bash $LFS_BOOK_HOME/chrooted.sh"

