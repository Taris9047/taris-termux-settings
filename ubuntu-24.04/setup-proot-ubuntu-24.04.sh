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
)

#
# Termux (one that wrapping this linux) paths
#
TERM_PREFIX='/data/data/com.termux/files/usr/'
TERM_HOME='/data/data/com.termux/files/home/'
SETTINGS_DIR="${TERM_HOME}/.settings"

#
# Curtesy update
#
printf '>>>> In Proot: Running Curtesy Updates\n'
sudo apt update && sudo updgrade -y

#
# Installing the packages from the package list
#
printf '>>>> In Proot: Installing some packages..\n'
sudo apt install -y "${inst_pkg_list[@]}"

