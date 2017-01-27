#!/usr/bin/env perl
#
# Notify about unusually large snapshots.
#

$WARNING_SIZE = 3221225472; # 3 GB

print "Finding unusually large snapshots:\n\n";

$command_output = `zfs list -Hpt snapshot -o name,used` || die "Failed to list snapshots.";

for $line (split(/\n/, $command_output)) {
    ($name, $size) = $line =~ /^(.*)\s+(\d+)$/;
    if ($size >= $WARNING_SIZE) {
	$name =~ s/^\s+//;
	$name =~ s/\s+$//;
	$snapshot = `zfs list -Ho name,used $name`;
	($pretty_size) = $snapshot =~ /\s+(.+)$/;
	print "$pretty_size taken up by $name\n";
    }
}

exit 0
