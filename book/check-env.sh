#!/bin/bash

set -eux

ia_log "Checking environment..."
echo

# check $LFS variable
if [ ! -d "$LFS" ]
then
  echo "The \$LFS variable is not a directory."
  echo "Prepare your environment to continue."
  echo "Current value: \$LFS=$LFS"
  exit 1
fi

# ensure the existence of $LFS/{tools,sources} directories
[ ! -d "$LFS/tools" ] && mkdir "$LFS/tools"
[ ! -d "$LFS/sources" ] && mkdir "$LFS/sources"

# copy book content to future root directory
mkdir "$LFS/book"
cp -rf "$LFS_BOOK_HOME/*" "$LFS/book"

# ensure LFS user has permissions
chown -R lfs:lfs $LFS

