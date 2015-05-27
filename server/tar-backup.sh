#!/bin/bash

# Create a tar backup of the entire system.

if test -z $1
then
	printf "Usage: ./tar-backup <destination>\n"
	exit 1
fi

# ensure we have superuser privileges.
if test $(id -u) != "0"
then
	printf "Need superuser privileges.\n"
	exit 1
fi

# set name
backup_name="$(uname -r)_$(date +'%Y%M%d-%H%M%S')"
printf "Backing up system. (${backup_name})\n"

tar -c --exclude={'${1}/${backup_name}.tar','dev/*','home/*','media/*','mnt/*','proc/*','run/*','srv/btsync/*','srv/syncthing/*','sys/*','tmp/*','/usr/portage/*','/var/tmp/*'} -Ipixz -f ${1}/${backup_name}.tar.pxz -C / .

exit 0

