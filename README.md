# Snapper PKG
A portable set of BASH scripts to integrate package managers with the openSUSE developed snapper. They are currently only functioning as a wrapper.

They are also completely independent of each other. Each script does the same thing, functionally.

## Requirements
* bash
	* or similar shell (like zsh or fish)
* snapper
	* with a BTRFS install
* Package Managers
	* aptitude
	* DNF
	* YUM
	* pacman


## Snapt
Integrates the Debian/Ubuntu package manager, `aptitude`.
### Commands
* help
* version
* list [`snapper list`]
* search [`aptitude search`]
* install [`aptitude install`]
* purge [`aptitude purge`]
* remove [`aptitude remove`]
* upgrade [`aptitude safe-upgrade`]

## Snapum
Integrates the RedHat-based package manager, `yum`.
### Commands
* help
* version
* list [`snapper list`]
* search [`yum search`]
* install [`yum install`]
* erase [`yum erase`]
* remove [`yum remove`]
* upgrade [`yum upgrade`]

## SNF
Integrates the RedHat-based package manager, `dnf`.
### Commands
* help
* version
* list [`snapper list`]
* search [`dnf search`]
* install [`dnf install`]
* erase [`dnf erase`]
* remove [`dnf remove`]
* upgrade [`dnf upgrade`]
* history [`dnf history`]

## Snapman
<strong>Not Yet Implemented</strong>

Integrates with the Arch package manager, `pacman`.
