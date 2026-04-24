#!/usr/bin/env bash
#
# Ubuntu set up script...
#
# At the moment, we are forcing it to use Ubuntu 24.04 LTS version.
# 

# Check script dir
SCRIPT_DIR=$( cd -- "$( dirname -- "${BASH_SOURCE[0]}" )" &> /dev/null && pwd )

# proot container username
PROOT_UNAME=taris

# PROOT distro name
PROOT_DIST='ubuntu-24.04'

# Setting up Timezone Data
DETECTED_TZ=$(curl -s http://ip-api.com/line?fields=timezone)
echo "Timezone detected: ${DETECTED_TZ}"

# Installing required tools first
bash "${SCRIPT_DIR}/../termux/setup-termux.sh"

# Adding Ubuntu 24.04 into the proot install list
if [ ! -f "$PREFIX/etc/proot-distro/${PROOT_DIST}" ]; then
cat << 'EOF' > $PREFIX/etc/proot-distro/ubuntu-24.04.sh
DISTRO_NAME="Ubuntu 24.04 (Noble)"
TARBALL_URL['aarch64']="https://cdimage.ubuntu.com/ubuntu-base/releases/24.04/release/ubuntu-base-24.04.4-base-arm64.tar.gz"
TARBALL_SHA256['aarch64']="04207713ece899c3740823d33690441ad3a7f0ded1101aca744e2b0f37ac7ff2"
TARBALL_STRIP_OPT=0
EOF
fi

PROOT_ROOT="${PREFIX}/var/lib/proot-distro/installed-rootfs/${PROOT_DIST}"
if [ ! -d "${PROOT_ROOT}" ]; then
	proot-distro install "${PROOT_DIST}"
fi

# Installing some packages
proot-distro login ${PROOT_DIST} -- bash -c "export DEBIAN_FRONTEND=noninteractive; export TZ=${DETECTED_TZ}; ln -snf /usr/share/zoneinfo/\$TZ /etc/localtime; apt update && apt upgrade -y && apt install -y sudo build-essential curl wget git adduser ca-certificates software-properties-common tzdata locales"

if ! proot-distro login ${PROOT_DIST} -- bash -c "id ${PROOT_UNAME}"; then
	proot-distro login ${PROOT_DIST} -- bash -c "adduser ${PROOT_UNAME}"
	proot-distro login ${PROOT_DIST} -- bash -c "usermod -aG sudo ${PROOT_UNAME}"
	proot-distro login ${PROOT_DIST} -- bash -c "echo \"${PROOT_UNAME} ALL=(ALL) NOPASSWD:ALL\" > /etc/sudoers.d/${PROOT_UNAME}"
	proot-distro login ${PROOT_DIST} -- bash -c "chmod 0440 /etc/sudoers.d/${PROOT_UNAME}"
	echo "New user ${PROOT_UNAME} in proot container ${PROOT_DIST} added!!"
fi

# Installing Starship for the user
if ! proot-distro login ${PROOT_DIST} -- command -v "/usr/local/bin/starship" &> /dev/null; then
	proot-distro login ${PROOT_DIST} -- bash -c 'curl -sS https://starship.rs/install.sh | sh'
	echo 'eval "$(starship init bash)"' >> ${PROOT_ROOT}/home/${PROOT_UNAME}/.bashrc
fi

# Putting in Termux specific environment varirables into PROOT user's directory
#


# Now run the proot setup script as proot
#
printf '>>> Running setup script as proot user\n'
proot-distro login ${PROOT_DIST} -- bash -c "bash -c \"${SCRIPT_DIR}/setup-proot-${PROOT_DIST}.sh\""

echo "Making symlink to start the proot Linux"
ln -sfv  "${SCRIPT_DIR}/start-${PROOT_DIST}.sh" "${SCRIPT_DIR}/../start.sh"

