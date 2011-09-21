#!/bin/bash
ln -vs "$(realpath ./lib/libbacon_ps1.sh)" /usr/local/lib/
ln -vs "$(realpath ./bin/bacon)" /usr/local/bin
ln -vs "$(realpath ./bin/bacons)" /usr/local/bin

cat >> ~/.bashrc << "EOF"

# bacon
CDPATH="$CDPATH:$HOME/.bacons"
source /usr/local/lib/libbacon_ps1.sh
if [ -z "$ps1path_wrapped" ]; then
  PS1=$(echo "$PS1" | sed -E 's/\\w/$(ps1path "\\w")/g')
  ps1path_wrapped="yes"
  fi

EOF
