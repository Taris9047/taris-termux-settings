#!/usr/bin/env bash
#
# Runs vscode server with proot distro
#

DISTRO="${1:-ubuntu-24.04}"
PROOT_USER="${2:-taris}"

if [ ! -x "$(command -v proot-distro)" ]; then
  printf 'proot-distro seems to be missing!\n'
  exit 1
fi

printf '>>> Running vscode-server\n'
proot-distro login ${DISTRO} --user "${PROOT_USER}" -- code-server
