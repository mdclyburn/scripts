#!/bin/bash

zpool status > /srv/web/system_reports/zfs.txt
/bin/arc_summary.py >> /srv/web/system_reports/zfs.txt

exit 0
