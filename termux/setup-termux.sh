#!/usr/bin/env bash
#
# Setup script to prepare Termux for proot linux
#

# Current directory
SCRIPT_DIR=$( cd -- "$( dirname -- "${BASH_SOURCE[0]}" )" &> /dev/null && pwd )
DOTF_DIR="${SCRIPT_DIR}/../dotfiles/"

# Basic programs
basic_programs=(
	"nano"
	"vim"
	"git"
	"curl"
	"which"
	"npm"
	"nodejs"
	"wget"
)
list_basic_programs="${basic_programs[*]}"

# Making sure .bashrc exists
if [ ! -f "${HOME}/.bashrc" ]; then
    # Sticking to old-school method since some Termux versions may not have touch!
	cp /dev/null "${HOME}/.bashrc"
fi

# Courtesy update
pkg update && pkg upgrade -y

# Enable Android storage access 
if [ ! -d "${HONME}/storage" ]; then
	termux-setup-storage
fi

# Install Proot
if [ ! -x "$(command -v proot-distro)" ]; then
	pkg install proot-distro -y
fi
pkg install "${list_basic_programs}" -y

# Installing starship
if [ ! -x "$(command -v starship)" ]; then
	pkg install starship -y
	if ! grep -q "starship init bash" "${HOME}/.bashrc"; then
		echo 'eval "$(starship init bash)"' >> ~/.bashrc
	fi
fi

#
# Adding some convenient ls aliases
#
if ! grep -q "alias ll=" "${HOME}/.bashrc"; then
	echo "alias ll='ls -alh'" >> ~/.bashrc
fi
if ! grep -q "alias ls=" "${HOME}/.bashrc"; then
	echo "alias ls='ls -lh'" >> ~/.bashrc
fi

#
# Installing configurations
#

# VIM
VIM_DIR="${HOME}/.vim"
# Removing existing .vim directory to ensure correct installation of Plugged
if [ -d "${VIM_DIR}" ]; then
	rm -rf "${VIM_DIR}"
fi
mkdir -p "${VIM_DIR}"
ln -sfv "${DOTF_DIR}/vim/colors" "${VIM_DIR}/colors"
ln -sfv "${DOTF_DIR}/vim/terminal_colors" "${VIM_DIR}/terminal_colors"
printf '>>> VIM Settings copied for termux!\n'

