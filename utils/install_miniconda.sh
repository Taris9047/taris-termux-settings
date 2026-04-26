#!/usr/bin/env bash
#
# Miniconda installation script for proot linux
#

DISTRO="${1:-ubuntu-24.04}"
PROOT_USER="${2:-taris}"
INSTALLER="Miniconda3-latest-Linux-aarch64.sh"
URL="https://repo.anaconda.com/miniconda/${INSTALLER}"

echo ">>> Starting Miniconda installation for ${PROOT_USER} inside ${PROOT_USER}"

echo '>>> Making sure proot distro has wget'
proot-distro login "${DISTRO}" --user "${PROOT_USER}" -- bash -c "apt update && apt install -y wget"

proot-distro login "${DISTRO}" --user "${PROOT_USER}" -- bash -c "
  # Download the installer 
  echo '>>>> Downloading Miniconda...'
  wget -q \"${URL}\" -O \"\${HOME}/${INSTALLER}\"

  # Run installer silently
  echo '>>>> Installing Miniconda'
  bash \"\${HOME}/${INSTALLER}\" -b -p \${HOME}/.miniconda3

  # Cleaning up the installer
  rm -rfv \"\${HOME}/${INSTALLER}\"

  # Initialize conda for bash
  echo '>>>> Initializing conda...'
  \${HOME}/.miniconda3/bin/conda init bash

"

# Now set up miniconda 
echo ">>> Setting up Miniconda3"
proot-distro login "${DISTRO}" --user "${PROOT_USER}" -- bash -ci "
  conda install -n base conda-libmamba-solver -y
  conda config --set solver libmamba
  conda update --all -y
  conda config --set plugins.auto_accept_tos yes
"

echo ">>> Setting up Jupyter-Lab for Miniconda3"
proot-distro login "${DISTRO}" --user "${PROOT_USER}" -- bash -ci "
  conda create -n jlab numpy scipy matplotlib jupyterlab pandas h5py -y
"

