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

# Making sure .bashrc exists
if [ ! -f "${HOME}/.bashrc" ]; then
    # Sticking to old-school method since some Termux versions may not have touch!
	cp /dev/null "${HOME}/.bashrc"
fi

# Running repo selection
read -p "Would you like to run repo. change script? [y/n]" -n 1 -r
echo ""
if [[ $REPLY =~ ^[Yy]$ ]]; then
	termux-change-repo
fi

# Courtesy update
pkg update && pkg upgrade -y

# Enable Android storage access 
if [ ! -d "${HOME}/storage" ]; then
	termux-setup-storage
fi

# Install Proot
if [ ! -x "$(command -v proot-distro)" ]; then
	pkg install proot-distro -y
fi
pkg install -y "${basic_programs[@]}"

# Setting up git
if [ -x "$(command -v git)" ]; then
	ln -sfv "${DOTF_DIR}/gitignore" "${HOME}/.gitignore"
	ln -sfv "${DOTF_DIR}/gitconfig" "${HOME}/.gitconfig.conf"

	if [ ! -f "${HOME}/.gitconfig" ]; then
		cp /dev/null "${HOME}/.gitconfig"
	fi

	gitconf_path="$(echo ${HOME}/.gitconfig.conf)"
	if [ -f "${HOME}/.gitconfig" ]; then
		if ! grep -q "path = $(echo ${gitconf_path})" "${HOME}/.gitconfig"; then
			printf "[include]\n\tpath = $(echo ${gitconf_path})\n" >> "${HOME}/.gitconfig"
		fi
	fi
	printf '>>> Make sure prepare your gitconfig.local\n'
fi

# Installing starship
if [ ! -x "$(command -v starship)" ]; then
	pkg install starship -y
	if ! grep -q "starship init bash" "${HOME}/.bashrc"; then
		echo 'eval "$(starship init bash)"' >> ~/.bashrc
	fi
fi
# Setting up starship's config file...
if [ ! -d "${HOME}/.config" ]; then
	mkdir -p "${HOME}/.config"
fi
ln -sfv "${SCRIPT_DIR}/../dotfiles/starship.toml" "${HOME}/.config/starship.toml"

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
	if [ ! -d "${VIM_DIR}/plugged" ]; then
		rm -rf "${VIM_DIR}"
	fi
fi
mkdir -p "${VIM_DIR}"
ln -sfv "${DOTF_DIR}/vim/colors" "${VIM_DIR}/colors"
ln -sfv "${DOTF_DIR}/vim/terminal_colors" "${VIM_DIR}/terminal_colors"
printf '>>> VIM Settings copied for termux!\n'

