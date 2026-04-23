#!/usr/bin/env bash
#
# Installing nerdfonts...
#
pkg update && pkg install -y curl ncurses-utils

if [ ! -x "$(command -v getnf)" ]; then
	curl -fsSL https://raw.githubusercontent.com/arnavgr/termux-nf/main/install.sh | bash -s -- --silent
fi

getnf -i FiraCode,JetBrainsMono,Mononoki 
