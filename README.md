# Snapper PKG
A portable set of BASH scripts to integrate package managers with the openSUSE developed snapper. They are currently only functioning as a wrapper.

They are also completely independent of each other. Each script should do the same thing, functionally. Some scripts may not be functionally up to par with others, because those package managers aren't used by the creator of these scripts, or because package managers work differently.

## Requirements
* bash
	* or similar shell (like zsh or fish)
* snapper
	* with a BTRFS install
* Package Managers
	* aptitude
	* DNF
	* YUM


## Snapt
Integrates the Debian/Ubuntu package manager, `aptitude`.
### Commands
* help
* version
* snapshot [`snapper`]
   * snapshot list [`snapper list`]
   * snapshot delete [`snapper delete`]
   * snapshot status [`snapper status`]
* repo
   * repo add [`add-apt-repository`]
* search [`aptitude search`]
* install [`aptitude install`]
* purge [`aptitude purge`]
* remove [`aptitude remove`]
* upgrade [`aptitude safe-upgrade`]
* reinstall [`aptitude reinstall`]

## Snapum
Integrates the RedHat-based package manager, `yum`.
### Commands
* help
* version
* snapshot [`snapper`]
   * snapshot list [`snapper list`]
   * snapshot delete [`snapper delete`]
   * snapshot status [`snapper status`]
* search [`yum search`]
* install [`yum install`]
* erase [`yum erase`]
* remove [`yum remove`]
* upgrade [`yum upgrade`]
* reinstall [`yum reinstall`]

## SNF
Integrates the RedHat-based package manager, `dnf`.
### Commands
* help
* version
* snapshot [`snapper`]
   * snapshot list [`snapper list`]
   * snapshot delete [`snapper delete`]
   * snapshot status [`snapper status`]
* search [`dnf search`]
* install [`dnf install`]
* reinstall [`dnf reinstall`]
* erase [`dnf erase`]
* remove [`dnf remove`]
* upgrade [`dnf upgrade`]
* history [`dnf history`]
* reinstall [`dnf reinstall`]

## Snapman
<strong>Not Yet Implemented</strong>

Integrates with the Arch package manager, `pacman`.
