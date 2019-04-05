#!/bin/bash

set -eux

[ ! type "ia_log" ] && { ia_log() { echo "$@" }; export -f ia_log }

rootPath=$(cd -P -- "$(dirname -- "${0}")" && printf '%s\n' "$(pwd -P)")

export LFS_BOOK_HOME="$root_path/book"

bash "$LFS_BOOK_HOME/main.sh"
