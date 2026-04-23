#!/usr/bin/env bash
#
# Ubuntu set up script...
#
# At the moment, we are forcing it to use Ubuntu 24.04 LTS version.
# 

# proot container username
PROOT_UNAME=taris

# PROOT distro name
PROOT_DIST='ubuntu-24.04'

# Setting up Timezone Data
DETECTED_TZ=$(curl -s http://ip-api.com/line?fields=timezone)
echo "Timezone detected: ${DETECTED_TZ}"

# Installing required tools first
pkg update && pkg upgrade -y
if [ ! -x "$(command -v proot-distro)" ]; then
	pkg install proot-distro -y
fi
pkg install nano vim git curl -y

# Adding Ubuntu 24.04 into the proot install list
if [ ! -f "$PREFIX/etc/proot-distro/${PROOT_DIST}" ]; then
cat << 'EOF' > $PREFIX/etc/proot-distro/ubuntu-24.04.sh
DISTRO_NAME="Ubuntu 24.04 (Noble)"
TARBALL_URL['aarch64']="https://cdimage.ubuntu.com/ubuntu-base/releases/24.04/release/ubuntu-base-24.04.4-base-arm64.tar.gz"
TARBALL_SHA256['aarch64']="04207713ece899c3740823d33690441ad3a7f0ded1101aca744e2b0f37ac7ff2"
TARBALL_STRIP_OPT=0
EOF
fi

if [ ! -d "$PREFIX/var/lib/proot-distro/installed-rootfs/${PROOT_DIST}" ]; then
	proot-distro install "${PROOT_DIST}"
fi

proot-distro login ${PROOT_DIST} -- bash -c "export DEBIAN_FRONTEND=noninteractive; export TZ=${DETECTED_TZ}; ln -snf /usr/share/zoneinfo/\$TZ /etc/localtime; apt update && apt upgrade -y && apt install -y sudo build-essential curl wget git adduser ca-certificates software-properties-common tzdata locales" && \
proot-distro login ${PROOT_DIST} -- adduser "${PROOT_UNAME}" && \
proot-distro login ${PROOT_DIST} -- usermod -aG sudo "${PROOT_UNAME}"

echo "New user ${PROOT_UNAME} in proot container ${PROOT_DIST} added!!"


