#!/bin/bash

# Backup the computer into an archive.

# Check for pixz.
if [ "$(which pixz)" = "pixz not found" ]
then
	printf "You need pixz.\n"
	exit 0
fi

# Make sure root privileges are available.
if test "$(id -u)" != "0"; then
	printf "Cannot run system backup without elevated privileges. Exiting.\n"
	exit 0
fi

name=""
dest_dir="/mnt/backup"
current_date="$(date +'%Y%m%d_%H%M%S')"

# Make sure variables are set.
if [ -z $name ]; then
	printf "'name' variable unset. Defaulting to name '$(uname -r)'.\n"
	name="$(uname -r)"
fi

if [ -z $dest_dir ]; then
	printf "Fatal: backup location is not set.\n"
	exit 1
fi

args="-aAhv --progress"
backup_dir="${dest_dir}/${name}-${current_date}"
core_ex="'${dest_dir}/*','/dev/*','/mnt/*','/proc/*','/run/*','/sys/*'"
home_ex="'/home/*'"
distro_ex="'/var/cache/pacman/*','/usr/portage/*','/var/tmp/portage/*'"
other_ex="'/media/*','/srv/*','/opt/*','/var/lib/mysql/*','/var/lib/plexmediaserver/*','/usr/src/*'"

rsync_command="rsync $args --exclude={${core_ex},${home_ex},${distro_ex},${other_ex}} / $backup_dir"
archive_command="tar -cvf ${backup_dir}.tar *"
compress_command="pixz ${backup_dir}.tar ${backup_dir}.tar.pxz"

printf "Creating backup %s...\n" "${name}-${current_date}"

printf "Backing up...\n"
eval $rsync_command

printf "Archiving to ${backup_dir}.tar...\n"
cd ${backup_dir}
eval $archive_command
cd ${dest_dir}

printf "Compressing archive...\n"
eval $compress_command

printf "Removing %s...\n" "${backup_dir}"
rm -rf ${backup_dir}

printf "Removing %s...\n" "${backup_dir}.tar"
rm ${backup_dir}.tar

printf "Backup complete!\n"

exit 0
