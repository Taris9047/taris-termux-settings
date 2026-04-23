#!/usr/bin/env bash
#
# Setup script to prepare Termux for proot linux
#

# Courtesy update
pkg update && pkg upgrade -y

# Install Proot
if [ ! -x "$(command -v proot-distro)" ]; then
	pkg install proot-distro -y
fi
pkg install nano vim git curl which -y

# Installing starship
if [ ! -x "$(command -v starship)" ]; then
	pkg install starship -y
	echo 'eval "$(starship init bash)"' >> ~/.bashrc
fi
