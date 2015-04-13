#!/bin/bash

# Backup the computer into an archive.

# Make sure root privileges are available.
if test "$(id -u)" != "0"; then
	printf "Cannot run system backup without elevated privileges. Exiting.\n"
	exit 0
fi

dest_dir="/mnt/backup"

if [ -z $dest_dir ]; then
	printf "Fatal: backup location is not set.\n"
	exit 1
fi

# Exclude the following paths.
exclude_paths="'${dest_dir}','/dev/*','/home/*','/media/*','/mnt/*','/proc/*','/run/*','/srv/btsync/*','/sys/*','/usr/portage/*','/usr/src/*','/var/tmp/*'"

DUPLICITY_CMD="duplicity --full-if-older-than 2W --no-encryption -v 8 --exclude={${exclude_paths}} / file://${dest_dir}"

eval $DUPLICITY_CMD

if [ $? != "0" ]
then
	printf "Backup utility reported error.\n"
	exit 1
else
	printf "Backup complete!\n"
	exit 0
fi

