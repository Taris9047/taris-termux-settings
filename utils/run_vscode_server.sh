#!/usr/bin/env bash
#
# Runs vscode server with proot distro
#

DISTRO="${1:-ubuntu-24.04}"
PROOT_USER="${2:-$USER}"

if [ ! -x "$(command -v proot-distro)" ]; then
  printf 'proot-distro seems to be missing!\n'
  exit 1
fi

printf ">>> Checking for vscode-server updates...\n"
proot-distro login "${DISTRO}" -- bash -c "curl -fsSL https://code-server.dev/install.sh | sh"

printf '>>> Running vscode-server\n'
proot-distro login ${DISTRO} --user "${PROOT_USER}" -- code-server
