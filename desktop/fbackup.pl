#!/usr/local/bin/perl -w

# fbackup.pl - Backup a directory into an archive.
#
# Usage: fbackup.pl <directory to backup> <destination directory> <name of archive>
#

if (!defined $ARGV[0] || !defined $ARGV[1] || !defined $ARGV[2]) {
	print "Usage: fbackup.pl <directory to backup> <destination directory> <name of archive>\n";
	die "Backup failed.";
}

($directory, $destination_dir, $name) = ($ARGV[0], $ARGV[1], $ARGV[2]);

# get name of final archive
$date = `date +"%Y%m%d_%H%M%S"`;
chomp $date;
$destination = $destination_dir . '/' . $name . '-' . $date . '.tar';
print "Backing up $directory to $destination...\n";

$output = `tar -cf $destination -C $directory . 2>&1`;
if ($? != 0) {
	print $output;
	die "Backup failed.\n";
}
else {
	print "Done!\n";
}
	
exit;
