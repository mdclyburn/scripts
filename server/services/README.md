Services
========

My server's custom systemd services.

full-backup
-----------

Create a compressed, tar backup of the computer.
This script also makes use of the `pixz` compression tool for indexed XZ.
Therefore, it will be needed or the script will warrant alteration before use.

Along with being smart enough to exclude the resulting archive from backup, the script also excludes:

* any home directories
* things under `/mnt`
* Gentoo's portage tree
* items in temporary directories (`/tmp`, `/var/tmp`)
* directories that just should not be backed up (`/dev`, `/run`, `/proc`...)

The script will need to know of the backup destination.
Simply do this by passing a destination as the one and only parameter.
The backup is named by the kernel (with version) and the date of creation.

zfs-report
----------

Generate a report about the status of ZFS and post it in the web directory.

zfs-scrub
---------

Run a scrub of the ZFS pool.

