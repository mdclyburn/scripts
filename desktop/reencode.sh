#!/bin/bash

# Encode all FLAC files in the current directory to MP3
#
# Arguments =====
# 1: bitrate in kBps
#

if [ -z $1 ]
then
	printf "reencode <bit rate (kBps)> [-a]\n"
	exit 1
else
	if [ -z $2 ]
	then
		printf "Will encode %i FLAC files to %ikBps MP3. OK? [y/N] " "$(ls *.flac | wc -l)" "$1"
		read response
		if [ "$response" != "y" ] && [ "$response" != "Y" ]
		then
			exit 0
		fi
	fi
fi

for flac_file in *
do
	mp3_file="$(echo $flac_file | sed 's/.flac/.mp3/')"
	printf "Re-encoding %s -> %s... " "$flac_file" "$mp3_file"
	ffmpeg -loglevel quiet -n -i "$flac_file" -ab ${1}K "$mp3_file"
	if [ "$?" != "0" ]
	then
		printf "Error...\n"
	else
		printf "Done!\n"
	fi
done

printf "Finished encoding %i files.\n" "$(ls *.flac | wc -l)"

exit 0
