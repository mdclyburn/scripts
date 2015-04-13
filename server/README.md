Server Stuff
=============

Scripts for my server.

backup.sh
------------
Utilizes duplicity to create a backup of the system.
In the resulting backup, one may find files such as:

* a bootable system, given that GRUB is reconfigured
* the web directory
* Plex Media Server data
* MySQL databases

It will _not_ contain:
* any media (music, movies, TV)
* anything under `/mnt`
* the Portage tree (easily re-obtained with `emerge-webrsync`)
* users' home directories
* kernel sources (re-emerge them with `emerge -a sys-kernel/gentoo-sources`)

