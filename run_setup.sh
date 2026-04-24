#!/usr/bin/env bash
#
# Main set up control script...
#
# TODO: Implement some fancy menu stuffs here...
#
SCRIPT_DIR=$( cd -- "$( dirname -- "${BASH_SOURCE[0]}" )" &> /dev/null && pwd )

termux_setup() {
  . "${SCRIPT_DIR}/termux/setup-termux.sh" && \
  . "${SCRIPT_DIR}/termux/install_nerdfonts.sh"
}

linux_setup() {
  local DISTRO="${1}"
  . "${SCRIPT_DIR}/${DISTRO}/setup-${DISTRO}.sh"
}

# Initial github clone
SETTINGS_DIR="${HOME}/.settings"
SETTINGS_SYMLINK="${HOME}/Settings"
if [ ! -d "${SETTINGS_DIR}" ]; then
  git clone 'git@github.com:Taris9047/taris-termux-settings.git' "${SETTINGS_DIR}" && \
    ln -sfv "${SETTINGS_DIR}" "${SETTINGS_SYMLINK}"
fi

# Interactive menu
echo "Taris' Termux Setup"
PS3='Selection: '
options=("Termux Only" "Termux+ubuntu-24.04" "Remove ubuntu-24.04" "Quit")

select opt in "${options[@]}"; do
  case $opt in
    "Termux Only")
      termux_setup
      break
      ;;
    "Termux+ubuntu-24.04")
      linux_setup "ubuntu-24.04"
      break
      ;;
    "Remove ubuntu-24.04")
      proot-distro remove "ubuntu-24.04"
      break
      ;;
    "Quit")
      echo "Quitting..."
      exit 0
      ;;
    *)
      echo "${opt} is not a valid selection. Exiting..."
      exit 1
      ;;
  esac
done
