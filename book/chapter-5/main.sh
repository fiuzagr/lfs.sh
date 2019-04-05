#!/bin/bash

set -eux

ia_log "Chapter 5." "Constructing a Temporary System"
echo

bash "$LFS_BOOK_HOME/chapter-5/5.04-binutils.sh"
bash "$LFS_BOOK_HOME/chapter-5/5.05-gcc.sh"
bash "$LFS_BOOK_HOME/chapter-5/5.06-linux-api-headers.sh"
bash "$LFS_BOOK_HOME/chapter-5/5.07-glibc.sh"
bash "$LFS_BOOK_HOME/chapter-5/5.08-libstdc++.sh"
bash "$LFS_BOOK_HOME/chapter-5/5.09-binutils.sh"
bash "$LFS_BOOK_HOME/chapter-5/5.10-gcc.sh"
bash "$LFS_BOOK_HOME/chapter-5/5.11-tcl.sh"
bash "$LFS_BOOK_HOME/chapter-5/5.12-expect.sh"
bash "$LFS_BOOK_HOME/chapter-5/5.13-dejagnu.sh"
bash "$LFS_BOOK_HOME/chapter-5/5.14-m4.sh"
bash "$LFS_BOOK_HOME/chapter-5/5.15-ncurses.sh"
bash "$LFS_BOOK_HOME/chapter-5/5.16-bash.sh"
bash "$LFS_BOOK_HOME/chapter-5/5.17-bison.sh"
bash "$LFS_BOOK_HOME/chapter-5/5.18-bzip2.sh"
bash "$LFS_BOOK_HOME/chapter-5/5.19-coreutils.sh"
bash "$LFS_BOOK_HOME/chapter-5/5.20-diffutils.sh"
bash "$LFS_BOOK_HOME/chapter-5/5.21-file.sh"
bash "$LFS_BOOK_HOME/chapter-5/5.22-findutils.sh"
bash "$LFS_BOOK_HOME/chapter-5/5.23-gawk.sh"
bash "$LFS_BOOK_HOME/chapter-5/5.24-gettext.sh"
bash "$LFS_BOOK_HOME/chapter-5/5.25-grep.sh"
bash "$LFS_BOOK_HOME/chapter-5/5.26-gzip.sh"
bash "$LFS_BOOK_HOME/chapter-5/5.27-make.sh"
bash "$LFS_BOOK_HOME/chapter-5/5.28-patch.sh"
bash "$LFS_BOOK_HOME/chapter-5/5.29-perl.sh"
bash "$LFS_BOOK_HOME/chapter-5/5.30-python.sh"
bash "$LFS_BOOK_HOME/chapter-5/5.31-sed.sh"
bash "$LFS_BOOK_HOME/chapter-5/5.32-tar.sh"
bash "$LFS_BOOK_HOME/chapter-5/5.33-texinfo.sh"
bash "$LFS_BOOK_HOME/chapter-5/5.34-xz.sh"

bash "$LFS_BOOK_HOME/chapter-5/5.35-stripping.sh"

