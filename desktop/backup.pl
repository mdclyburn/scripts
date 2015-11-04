#!/usr/bin/perl -w

# Full System Backup
#
# Backup an entire system by tarring all files on
# the system.
#
# Usage: backup.pl <destination> [ -e <exclude listing>]
#

$usage = "Usage: backup.pl <destination> [ -e <exclude listing> ]\n";

# Read arguments
die $usage if ! @ARGV;

for ($arg_no = 1; $arg_no <= $#ARGV; $arg_no++) {

	if ($ARGV[$arg_no] eq "-e") { # File exclude listing
		die $usage, "\n" if $arg_no == $#ARGV;
		$options{$ARGV[$arg_no]} = $ARGV[$arg_no + 1];
		$arg_no++;
	}
	else {
		die "Unrecognized flag: ", $ARGV[$arg_no], "\n";
	}
}

exit;
