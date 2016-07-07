#!/usr/bin/env bash

## Variables ##

# Set first first arg[] as <command>
comm=$1

# Set Version Number
version="v0.1.1"

## Functions ##

# Help Header
helphead(){
	echo $version
	echo "Usage: snapum <command>"
	echo ""
	echo "Snapum is a script designed to run snapper and yum in conjunction"
	echo "for installing/removing/updating packages using [snapper --command] to"
	echo "auto-create --pre and --post btrfs snapshots."
	echo ""
	echo "Available Commands:"
	echo " help"
	echo " version"
	echo " search"
	echo " install"
	echo " erase"
	echo " remove"
	echo " upgrade"
	echo ""
}

# Help Message fn()
helpmsg() {
	echo "Snapum Command info:"
	echo " help:"
	echo "  Shows this help message"
	echo ""
	echo " version:"
	echo "  Shows the version"
	echo ""
	echo " search:"
	echo "  Searches [yum search] through repos to find packages"
	echo ""
	echo " install:"
	echo "  Installs [yum install] new packages from repos"
	echo ""
	echo " erase:"
	echo "  Uninstalls [yum erase] new packages from repos"
	echo ""
	echo " remove:"
	echo "  Uninstalls [yum remove] new packages from repos"
	echo ""
	echo " upgrade:"
	echo "  Upgrade packages to their newest versions [yum upgrade]"
	echo ""
}

## Script Start ##

# Force non-error fails to return as error
set -e

# Aptitude is required. If not installed, Abort
command -v yum >/dev/null 2>&1 || { echo >&2 "'yum' is required, please install it. Aborting."; exit 1; }
# Snapper is required. If not installed, Abort
command -v snapper >/dev/null 2>&1 || { echo >&2 "'snapper' is required, please install it. Aborting."; exit 1; }

# No Arguments
if [ "$#" -eq 0 ]; then
	echo "Error: Requires Arguments"
	echo ""
	helphead
	exit
fi

# Individual Commands
if [ $comm = "help" ]; then
	helphead
	helpmsg

	exit
elif [ $comm = "version" ]; then
	echo snapum $version

	exit
elif [[ $comm = "search" ]]; then
	shift
	yum search $*

	exit
elif [ $comm = "install" ]; then
	# Check for root privileges
	if [ "$EUID" -ne 0 ]; then
		echo "This command needs root privileges."
		echo "Please re-run using root privileges"

		exit 1
	fi

	shift

	yumcomm="yum install $*"

	# Must have package names to install anything
	if [ "$#" -eq 0 ]; then
		echo "Requires package name to install"
		exit 1
	fi

	snapper -v create -d "snapum install" --command "$yumcomm"

	exit
elif [ $comm = "erase" ]; then
	# Check for root privileges
	if [ "$EUID" -ne 0 ]; then
		echo "This command needs root privileges."
		echo "Please re-run using root privileges"

		exit 1
	fi

	shift

	yumcomm="yum erase $*"

	# Must have package names to remove anything
	if [ "$#" -eq 0 ]; then
		echo "Requires package name to erase"
		exit 1
	fi

	snapper -v create -d "snapum erase" --command "$yumcomm"

	exit
elif [ $comm = "remove" ]; then
	# Check for root privileges
	if [ "$EUID" -ne 0 ]; then
		echo "This command needs root privileges."
		echo "Please re-run using root privileges"

		exit 1
	fi

	shift

	yumcomm="yum remove $*"
	aptitude update

	# Must have package names to remove anything
	if [ "$#" -eq 0 ]; then
		echo "Requires package name to remove"
		exit 1
	fi

	snapper -v create -d "snapum remove" --command "$yumcomm"

	exit
elif [ $comm = "upgrade" ]; then
	# Check for root privileges
	if [ "$EUID" -ne 0 ]; then
		echo "This command needs root privileges."
		echo "Please re-run using root privileges"

		exit 1
	fi
	shift

	yumcomm="yum upgrade $*"
	aptitude update

	snapper -v create -d "snapum upgrade" --command "$yumcomm"

	exit
else
	echo "Error: Command <$comm> is not a functional command."
	echo ""
	helphead

	exit 1
fi
