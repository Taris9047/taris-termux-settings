#!/usr/bin/env bash
#
# Install script for vscode server for Termux - Proot
#

# Use the first argument as the distro, defaulting to ubuntu-24.04
#
DISTRO="${1:-ubuntu-24.04}"
PROOT_USER="${2:-taris}"

# Checking of proot-distro exists
if [ ! -x "$(command -v proot-distro)" ]; then
  printf '>>> Installing proot-distro\n'
  pkg update -y && pkg install proot-distro -y
fi

# Check and install the specified distro in proot
ROOTFS_DIR="${PREFIX}/var/lib/proot-distro/installed-rootfs/${DISTRO}"
if [ ! -d "${ROOTFS_DIR}" ]; then
  printf '>>> Installing ${DISTRO}... \n'
  if [ "${DISTRO}" = "ubuntu-24.04" ]; then
cat << 'EOF' > ${PREFIX}/etc/proot-distro/ubuntu-24.04.sh
DISTRO_NAME="Ubuntu 24.04 (Noble)"
TARBALL_URL['aarch64']="https://cdimage.ubuntu.com/ubuntu-base/releases/24.04/release/ubuntu-base-24.04.4-base-arm64.tar.gz"
TARBALL_SHA256['aarch64']="04207713ece899c3740823d33690441ad3a7f0ded1101aca744e2b0f37ac7ff2"
TARBALL_STRIP_OPT=0
EOF
  fi
  proot-distro install "${DISTRO}" || { printf '>>> Failed to install %s. Is it a valid proot-distro?\n' "${DISTRO}"; exit 1; } 
fi

# Now installing and configuring the vscode-server inside the distro.
#
proot-distro login --user "${PROOT_USER}" "${DISTRO}" -- bash -c "
  # Detect package manager and install prereq.
  if command -v apt-get &> /dev/null; then
    DEBIAN_FRONTEND=noninteractive apt-get update
    DEBIAN_FRONTEND=noninteractive apt-get install -y wget nano sudo
  elif command -v pacman &> /dev/null; then
    pacman 0Syu --noconfirm curl wget nano sudo
  elif command -v apk &> /dev/null; then
    apk update 
    apk add curl wget nano sudo bash
  elif command -v dnf &> /dev/null; then
    dnf install -y curl wget nano sudo
  fi

  # Download and install code-server
  #
  curl -fsSL https://code-server.dev/install.sh | sh

  # Ensuring the user exists
  #
  if ! id -u ${PROOT_USER} >/dev/null 2>&1; then
    printf '>>> Creating user %s\n' "${PROOT_USER}"
    useradd -m -s /bin/bash ${PROOT_USER}
    echo '${PROOT_USER} ALL=(ALL) NOPASSWD:ALL' >> /etc/sudoers
  fi
"

# Configuring user specific vscode-server 
#
printf '>>> Configuring code-server for user: %s\n' "${PROOT_USER}"
proot-distro login "${DISTRO}" --user "${PROOT_USER}" -- bash -c "
  mkdir -p ~/.config/code-server
  cat <<EOF > ~/.config/code-server/config.yaml
vind-addr: 127.0.0.1:8080
auth: none
cert: false
EOF
"

# Final messages..
#
printf '>>> Setup Complete!\n'
printf '>>> To start your VS Code server as %s, run:\n' "${PROOT_USER}"
printf 'proot-distro -login %s --user %s -- code-server' "${DISTRO}" "${PROOT_USER}"
printf 'Then visit: http://127.0.0.1:8080\n'


