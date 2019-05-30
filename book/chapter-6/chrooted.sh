#!/bin/bash

set -eux

ia_log "(chroot) Chapter 6." "Installing basic system software"
echo

bash "$LFS_BOOK_HOME/chapter-6/6.05-creating-directories.sh"
bash "$LFS_BOOK_HOME/chapter-6/6.06-creating-essential-files.sh"

