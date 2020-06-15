#!/usr/bin/env bash


# Abort on any error
set -e -u

# Simpler git usage, relative file paths
CWD=$(dirname "$0")
cd "$CWD"

# Load helpful functions
source libs/common.sh
source libs/docker.sh

# Check dependencies
assert_dependency "jq"
assert_dependency "curl"

# Debian stretch
IMG_CHANNEL="stretch"
update_image "library/debian" "Debian" "false" "$IMG_CHANNEL-\d+-slim"

# Packages
PKG_URL="https://packages.debian.org/$IMG_CHANNEL/amd64"
update_pkg "binutils" "Binary Utilities" "false" "$PKG_URL" "(\d+\.)+\d+-\d+"
update_pkg "libcap2" "LibCap 2" "false" "$PKG_URL" "\d+:(\d+\.)+\d+-\d+"
update_pkg "curl" "cURL" "false" "$PKG_URL" "(\d+\.)+\d+-\d+\+deb\d+u\d+"
update_pkg "gnupg" "GNUPG" "false" "$PKG_URL" "(\d+\.)+\d+-\d+~deb\d+u\d+"
update_pkg "openjdk-8-jre-headless" "Headless JRE" "false" "$PKG_URL" "8u\d+-b\d+-\d+~deb\d+u\d+"
update_pkg "jsvc" "JSVC" "false" "$PKG_URL" "(\d+\.)+\d+-\d+"
update_pkg "logrotate" "Logrotate" "false" "$PKG_URL" "(\d+\.)+\d+-\d+\.\d+"


if ! updates_available; then
	echo "No updates available."
	exit 0
fi

# Perform modifications
if [ "${1-}" = "--noconfirm" ] || confirm_action "Save changes?"; then
	save_changes

	if [ "${1-}" = "--noconfirm" ] || confirm_action "Commit changes?"; then
		commit_changes
	fi
fi