#!/usr/bin/perl -w

# reencode.pl
#
# Encode all FLAC files in the current directory to MP3 with
# the specified bitrate.
#
# reencode.pl <bit rate (Kbps)>
#

use Term::ANSIColor;

# check for sane values
die "Usage: reencode.pl <bit rate (Kbps)>\n" if (! @ARGV);

$bit_rate = $ARGV[0];
die "Use a sane bit rate!\n" if ($bit_rate < 64);

@files = <*.flac>;

die "There are no FLAC files here...\n" if (scalar @files == 0);

print "Will encode ", scalar @files, " files to ${bit_rate}Kbps MP3 files. OK? [Y/n] ";
$answer = <STDIN>;
chomp $answer;

if ($answer eq "" || $answer eq "Y" || $answer eq "y") {

	# remove extension
	for ($i = 0; $i <= $#files; $i++) {
		$files[$i] =~ s/.flac$//;
	}

	# split up tasks
	$id = 0;
	while ($id < get_core_count()) {
#		push(@jobs_completed, 0);
		$pid = fork();

		if ($pid != 0) { # parent
			# assign the child a number and keep track of it
			push(@children, $pid);
			$id++;
		}
		else { # child
			last;
		}
	}

	if ($pid != 0) { # parent: should wait
		for ($i = 0; $i <= $#children; $i++) {
			waitpid($children[$i], 0);
			warn "Problems occured.\n" if ($? != 0);
		}
	}
	else { # child: do work
		if ($id > $#files) {
#			print "Not enough files; child #$id is bailing.\n";
			exit 0;
		}

		# convert files
		$status = 0;
		for ($i = $id; $i <= $#files; $i += get_core_count()) {

			# perform conversion
			$flac_file = $files[$i] . ".flac";
			$mp3_file = $files[$i] . ".mp3";
			system("ffmpeg -loglevel quiet -n -i \"$flac_file\" -ab $bit_rate \"$mp3_file\"");
			
			if ($? != 0) {
				print "$id: $flac_file -> $mp3_file ", colored("failed\n", "red\n");
				$status = 1;
			}
			else {
				print "$id: $flac_file -> $mp3_file ", colored("done\n", "green");
			}
		}

		exit $status;
	}
}
else {
	print "OK. Not doing anything then.\n";
	exit;
}

exit;

# count number of CPU cores on the system
sub get_core_count {
	if (`uname -a` =~ /Linux/) {
		($cc) = `cat /proc/cpuinfo` =~ /cpu cores\s+: (\d+)/;
	}
	else { # assume we can use sysctl
		$cc = `sysctl -n hw.ncpu`;
	}

	chomp $cc;

	return $cc;
}
