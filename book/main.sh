#!/bin/bash

set -eux

ia_log "Linux From Scratch" "Version 8.4"
echo

# check environment
bash "$LFS_BOOK_HOME/check-env.sh"

# execute as lfs user
su-exec lfs bash "$LFS_BOOK_HOME/chapter-3/main.sh"
su-exec lfs bash "$LFS_BOOK_HOME/chapter-5/main.sh"

# changing owner of the tools dir
chown -R root:root "$LFS/tools"

# execute as root user
bash "$LFS_BOOK_HOME/chapter-6/main.sh"
