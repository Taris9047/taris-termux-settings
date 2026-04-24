#!/usr/bin/env bash
#
# A start up script for proot Ubuntu 24.04
#

# user ID in the proot linux
USER=taris

# proot linux disbribution
DISTRO='ubuntu-24.04'

# Rootfs Directory
ROOTFS_DIR="${PREFIX}/var/lib/proot-distro/installed-rootfs/${DISTRO}"

# Checking the command 'proot-distro'
if [ ! -x "$(command -v proot-distro)" ]; then
	echo "proot-distro is not installed on this Termux. Please install it with..."
	echo "pkg update && pkg install proot-distro -y"
fi

if [ ! -d "${ROOTFS_DIR}" ]; then
	echo "Distro ${DISTRO} is not installed!!"
	echo "Run the setup script to install and make an account in it."
	exit 1
fi

# Home prefix for proot distro
PROOTHOME="${PREFIX}/var/lib/proot-distro/installed-rootfs/${DISTRO}/home/${USER}/"

# Check if proot .ssh exists
if [ ! -d "${PROOTHOME}/.ssh" ]; then
	cp -r ~/.ssh "${PROOTHOME}/"
	proot-distro login "${DISTRO}" -- sh -c "
		chown -R ${USER}:${USER} /home/${USER}/.ssh
		chmod 700 /home/${USER}/.ssh
		find /homoe/${USER}/.ssh -type -f -exec chmod 600 {} +
		find /home/${USER}/.ssh -type -f -name '*.pub' -exec chmod {} +
		"
fi

# Now login to proot distro...
proot-distro login "${DISTRO}" --user "${USER}"



