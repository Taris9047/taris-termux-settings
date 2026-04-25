#!/usr/bin/env bash
#
# This is a set up script supposed to be run in the proot
# Linux, in this case: Ubuntu 24.04
#

#
# Package list
#
inst_pkg_list=(
	"neofetch"
	"build-essential"
	"cmake"
	"curl"
	"wget"
	"m4"
	"flex"
	"bison"
	"vim"
	"nano"
	"lua5.4"
)

#
# Termux (one that wrapping this linux) paths
#
TERM_PREFIX='/data/data/com.termux/files/usr/'
TERM_HOME='/data/data/com.termux/files/home/'
SETTINGS_DIR="${TERM_HOME}/.settings"
DOTFILES_DIR="${SETTINGS_DIR}/dotfiles"

#
# Curtesy update
#
printf '>>>> In Proot: Running Curtesy Updates\n'
sudo apt update && sudo upgrade -y

#
# Installing the packages from the package list
#
printf '>>>> In Proot: Installing some packages..\n'
sudo apt install -y "${inst_pkg_list[@]}"

#
# Install nodejs via nvm
#
if [ ! -d "${HOME}/.nvm/.git" ]; then
	curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/master/install.sh | bash
	export NVM_DIR="${HOME}/.nvm"
	[ -s "${NVM_DIR}/nvm.sh" ] && \. "${NVM_DIR}/nvm.sh"
	nvm install --lts
fi

#
# Settign up vim
#
if [ -x "$(command -v vim)" ]; then
	if [ ! -d "${HOME}/.vim" ]; then
		mkdir -p "${HOME}/.vim"
		ln -sfv "${DOTFILES_DIR}/vim/colors" "${HOME}/.vim/colors"
		ln -sfv "${DOTFILES_DIR}/vim/terminal_colors" "${HOME}/.vim/terminal_colors"
	fi
	ln -sfv "${DOTFILES_DIR}/vimrc" "${HOME}/.vimrc"
fi

#
# Setting up starship
#
if [ -x "$(command -v starship)" ]; then
	if [ ! -d "${HOME}/.config" ]; then
		mkdir -p "${HOME}/.config"
	fi
	ln -sfv "${DOTFILES_DIR}/starship.toml" "${HOME}/.config/starship.toml"
fi



