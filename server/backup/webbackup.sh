#!/bin/bash

target_dir="/srv/web"
current_date="$(date +'%Y%m%d_%H%M%S')"
backup_dir="/mnt/backup"
name="web_${current_date}"

printf "Archiving...\n"
tar -cvf ${backup_dir}/${name}.tar ${target_dir}/* >/dev/null

printf "Compressing...\n"
pixz ${backup_dir}/${name}.tar ${backup_dir}/${name}.tar.pxz

printf "Cleaning up...\n"
rm -r ${backup_dir}/${name}.tar

printf "Finished.\n"

exit 0
