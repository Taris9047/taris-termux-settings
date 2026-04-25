#!/usr/bin/env bash
#
# Installing nerdfonts...
#

if [ -d "${PREFIX}/share/termux-nf/fonts" ]; then
	printf '>>>> Nerd Fonts found in the system\n'
	exit 0
fi

printf '>>>> Installing Nerd Fonts\n'
pkg update && pkg install -y curl ncurses-utils

if [ ! -x "$(command -v getnf)" ]; then
	curl -fsSL https://raw.githubusercontent.com/arnavgr/termux-nf/main/install.sh | bash -s -- --silent
fi

getnf -i FiraCode,JetBrainsMono,Mononoki 
