#!/bin/sh
#
# Clean the scratch directory of old files.

set -e
set -u

SCRATCH_DIR=/scratch
RETENTION_PERIOD=7200

printf "\nCleaning up %s:\n" "$SCRATCH_DIR"

# Delete files older than RETENTION_PERIOD
# We're using ctime to determine the age of the files.
find $SCRATCH_DIR -cmin +$RETENTION_PERIOD -type f \( -not -path './About Scratch.txt' \) -delete -print

# Directories eligible for deletion are empty, otherwise,
# they are kept around until all of their files are gone.
find $SCRATCH_DIR -type d \( -not -regex '/scratch' \) -print | while read directory
do
	file_listing=$( ls "$directory" )
	if [ -z "$file_listing" ]
	then
		printf "Removing empty directory: %s\n" "$directory"
		rmdir "$directory"
	fi
done

printf "Removed scratch files.\n"
