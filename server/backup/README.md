Server Backup
=============

Scripts for backing up my server.

sysbackup.sh
------------
This is an adaptation of [my custom backup script](https://github.com/mdclyburn/backup-shell).
The result of this backup is a pixz-compressed archive.
The archive is created in the `/mnt/backup` directory.

In this archive one can find:
* a bootable system, given that GRUB is set up again.
* all configurations files (nginx, php, ssh...)

In this archive, you will not find
* _any_ configured home directories
* Plex Media Server files
* the Portage tree (just get it with `emerge-webrsync`)
* kernel sources
* the web directory
* MySQL databases
* anything under `/srv`

webbackup.sh
------------
Creates a pixz-compressed archive of the `/srv/web` directory.
That's all.
The archive is created in the `/mnt/backup` directory.
