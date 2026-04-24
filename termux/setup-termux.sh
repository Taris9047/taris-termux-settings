#!/usr/bin/env bash
#
# Setup script to prepare Termux for proot linux
#

# Current directory
SCRIPT_DIR=$( cd -- "$( dirname -- "${BASH_SOURCE[0]}" )" &> /dev/null && pwd )
DOTF_DIR="${SCRIPT_DIR}/../dotfiles/"

# Making sure .bashrc exists
if [ ! -f "${HOME}/.bashrc" ]; then
	cp /dev/null "${HOME}/.bashrc"
fi

# Courtesy update
pkg update && pkg upgrade -y

# Enable Android storage access 
termux-setup-storage

# Install Proot
if [ ! -x "$(command -v proot-distro)" ]; then
	pkg install proot-distro -y
fi
pkg install nano  vim git curl which npm nodejs -y

# Installing starship
if [ ! -x "$(command -v starship)" ]; then
	pkg install starship -y
	echo 'eval "$(starship init bash)"' >> ~/.bashrc
fi

#
# Adding some convenient ls aliases
#
echo "alias ll='ls -alh'" >> ~/.bashrc
echo "alias ls='ls -lh'" >> ~/.bashrc

#
# Installing configurations
#

# VIM
VIM_DIR="${HOME}/.vim"
if [ -d "${VIM_DIR}" ]; then
	rm -rf "${VIM_DIR}"
fi
mkdir -p "${VIM_DIR}"
ln -sfv "${DOTF_DIR}/vim/colors" "${VIM_DIR}/colors"
ln -sfv "${DOTF_DIR}/vim/terminal_colors" "${VIM_DIR}/terminal_colors"
printf '>>> VIM Settings copied for termux!\n'

