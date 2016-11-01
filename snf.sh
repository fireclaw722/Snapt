#!/usr/bin/env bash

## Variables ##

# Set first first arg[] as <command>
comm=$1

# Set Version Number
version="v0.3.2"

## Functions ##

# Help Header
helphead(){
	echo $version
	echo "Usage: snf <command>"
	echo ""
	echo "SNF is a script designed to run snapper and dnf in conjunction"
	echo "for installing/removing/updating packages using [snapper --command] to"
	echo "auto-create --pre and --post btrfs snapshots."
	echo ""
	echo "Available Commands:"
	echo " help"
	echo " version"
	echo " snapshot"
	echo " search"
	echo " install"
	echo " reinstall"
	echo " erase"
	echo " remove"
	echo " upgrade"
	echo " history"
	echo ""
}

# Help Message fn()
helpmsg() {
	echo "SNF Command info:"
	echo " help:"
	echo "  Shows this help message"
	echo ""
	echo " version:"
	echo "  Shows the version"
	echo ""
	echo " snapshot:"
	echo "  snapshot list"
	echo "   Lists [snapper list] snapshots by number"
	echo "  snapshot delete"
	echo "   Allows for deleting [snapper delete] snapshots"
	echo "  snapshot status"
	echo "   Shows changes between snapshots [snapper status]"
	echo ""
	echo " search:"
	echo "  Searches [dnf search] through repos to find packages"
	echo ""
	echo " install:"
	echo "  Installs [dnf install] new packages from repos"
	echo ""
	echo " reinstall:"
	echo "  Reinstalls [dnf reinstall] packages from repos"
	echo ""
	echo " erase:"
	echo "  Uninstalls [dnf erase] packages from repos"
	echo ""
	echo " remove:"
	echo "  Uninstalls [dnf remove] packages from repos"
	echo ""
	echo " upgrade:"
	echo "  Upgrade packages to their newest versions [dnf upgrade]"
	echo ""
	echo " history:"
	echo "  Manage and List DNF history [dnf history]"
	echo ""
}

## Script Start ##

# Force non-error fails to return as error
set -e

# DNF is required. If not installed, Abort
command -v dnf >/dev/null 2>&1 || { echo >&2 "'dnf' is required, please install it. Aborting."; exit 1; }
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
	echo snf $version

	exit
elif [ $comm = "snapshot" ]; then
	# Check for root privileges
	if [ "$EUID" -ne 0 ]; then
		echo "This command needs root privileges."
		echo "Please re-run using root privileges"

		exit 1
	fi

	shift

	if [ $1 = "list" ]; then
		shift
		snapper list $*
	elif [ $1 = "delete" ]; then
		shift
		snapper delete $*
	elif [ $1 = "status" ]; then
		shift
		snapper status $*
	fi

	exit
elif [[ $comm = "search" ]]; then
	shift
	dnf search $*

	exit
elif [ $comm = "install" ]; then
	# Check for root privileges
	if [ "$EUID" -ne 0 ]; then
		echo "This command needs root privileges."
		echo "Please re-run using root privileges"

		exit 1
	fi

	shift

	dnfcomm="dnf install $*"

	# Must have package names to install anything
	if [ "$#" -eq 0 ]; then
		echo "Requires package name to install"
		exit 1
	fi

	snapper -v create -d "SNF install" --command "$dnfcomm"

	exit
elif [ $comm = "reinstall" ]; then
	# Check for root privileges
	if [ "$EUID" -ne 0 ]; then
		echo "This command needs root privileges."
		echo "Please re-run using root privileges"

		exit 1
	fi

	shift

	dnfcomm="dnf reinstall $*"

	# Must have package names to install anything
	if [ "$#" -eq 0 ]; then
		echo "Requires package name to reinstall"
		exit 1
	fi

	snapper -v create -d "SNF reinstall" --command "$dnfcomm"

	exit
elif [ $comm = "erase" ]; then
	# Check for root privileges
	if [ "$EUID" -ne 0 ]; then
		echo "This command needs root privileges."
		echo "Please re-run using root privileges"

		exit 1
	fi

	shift

	dnfcomm="dnf erase $*"

	# Must have package names to remove anything
	if [ "$#" -eq 0 ]; then
		echo "Requires package name to erase"
		exit 1
	fi

	snapper -v create -d "SNF erase" --command "$dnfcomm"

	exit
elif [ $comm = "remove" ]; then
	# Check for root privileges
	if [ "$EUID" -ne 0 ]; then
		echo "This command needs root privileges."
		echo "Please re-run using root privileges"

		exit 1
	fi

	shift

	dnfcomm="dnf remove $*"

	# Must have package names to remove anything
	if [ "$#" -eq 0 ]; then
		echo "Requires package name to remove"
		exit 1
	fi

	snapper -v create -d "SNF remove" --command "$dnfcomm"

	exit
elif [ $comm = "upgrade" ]; then
	# Check for root privileges
	if [ "$EUID" -ne 0 ]; then
		echo "This command needs root privileges."
		echo "Please re-run using root privileges"

		exit 1
	fi
	shift

	dnfcomm="dnf upgrade $*"

	snapper -v create -d "SNF upgrade" --command "$dnfcomm"

	exit
elif [ $comm = "history" ]; then
	# Check for root privileges
	if [ "$EUID" -ne 0 ]; then
		echo "This command needs root privileges."
		echo "Please re-run using root privileges"

		exit 1
	fi
	shift

	# Don't create snapshot for listing history
	if [ $1 = "list" ]; then
		dnf history list
	else
		dnfcomm="dnf history $*"
		snapper -v create -d "SNF config" --command "$dnfcomm"
	fi

	exit
else
	echo "Error: Command <$comm> is not a functional command."
	echo ""
	helphead

	exit 1
fi
