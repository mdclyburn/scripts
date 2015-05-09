#!/bin/bash

# Backup the computer into an archive.

# Make sure root privileges are available.
if test "$(id -u)" != "0"; then
	printf "Cannot run system backup without elevated privileges. Exiting.\n"
	exit 0
fi

dest_dir="/mnt/backup/duplicity/server"

if [ -z $dest_dir ]; then
	printf "Fatal: backup location is not set.\n"
	exit 1
fi

# Parameters
exclude_paths="'${dest_dir}','/dev/*','/media/*','/mnt/*','/proc/*','/run/*','/srv/btsync/*','/sys/*','/usr/portage/*','/usr/src/*','/var/tmp/*'"
volume_size="100"

DUPLICITY_CMD="duplicity --full-if-older-than 1W --no-encryption --volsize $volume_size --exclude={${exclude_paths}} / file://${dest_dir}"
DUPLICITY_CLEAN_CMD="duplicity remove-older-than 6M file://${dest_dir}"

eval $DUPLICITY_CMD

if [ $? != "0" ]
then
	printf "Backup utility reported error. Not performing cleanup.\n"
	exit 1
fi

printf "Cleaning...\n"
eval $DUPLICITY_CLEAN_CMD

if [ $? != "0" ]
then
	printf "Cleanup finished with error.\n"
	exit 1
else
	printf "Operation complete!\n"
	exit 0
fi
