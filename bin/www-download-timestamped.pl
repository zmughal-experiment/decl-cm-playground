#!/usr/bin/env perl

use strict;
use warnings;
use File::Basename qw(dirname basename);
use File::Path qw(make_path);
use File::Temp qw(tempdir);
use LWP::UserAgent;
use HTTP::Date;
use Getopt::Long;
use File::Copy;
use Cwd 'abs_path';
use IPC::Cmd qw(can_run);
use POSIX qw(strftime);
use File::Spec;
use File::stat;

# Check for required commands
my @required_commands = qw(wget);
for my $cmd (@required_commands) {
	can_run($cmd) or die "$0: Could not find $cmd\n";
}

# Parse command line arguments
my ($url, $full_path);
GetOptions(
	"url=s"  => \$url,
	"file=s" => \$full_path
) or die usage();

# Check for required arguments
die usage() unless $url && $full_path;

my $top_level = dirname($full_path);
my $filename = basename($full_path);

make_path($top_level);

my $tempdir = tempdir(DIR => $top_level, CLEANUP => 1);
my $tempdata = File::Spec->catfile($tempdir, $filename);

my $ua = LWP::UserAgent->new;
my $response = $ua->head($url);
die "Could not retrieve HEAD of $url" unless $response->is_success;
my $remote_last_modified = $response->header('Last-Modified');
my $remote_last_modified_timestamp = str2time($remote_last_modified);

my $real_local_file = abs_path($full_path);
my $local_last_modified_timestamp;
if (-f $real_local_file) {
	my $stat = stat($real_local_file);
	$local_last_modified_timestamp = $stat->mtime;
}

sub filename_for_timestamp {
	my ($top_level, $filename,  $timestamp) = @_;
	my $time_format = "%Y%m%dT%H%M%S";
	my $date_suffix = strftime($time_format, gmtime($timestamp));
	my $new_file = File::Spec->catfile($top_level, "${filename}.${date_suffix}");
}

if (! defined $local_last_modified_timestamp || $remote_last_modified_timestamp != $local_last_modified_timestamp) {
	print STDERR <<EOF;
$0: The file $full_path has been modified (old: @{[
		$local_last_modified_timestamp // 'none'
	]}, new: $remote_last_modified_timestamp).
EOF

	my $new_file;

	my $use_possible_file = 0;
	my $possible_filename = filename_for_timestamp($top_level, $filename, $remote_last_modified_timestamp);
	my $expected_size = $response->header('Content-Length');
	if( -r $possible_filename ) {
		print STDERR "Possible filename $possible_filename name matches timestamp $remote_last_modified_timestamp\n";
		if( $expected_size && $expected_size == -s $possible_filename ) {
			print STDERR "Possible filename $possible_filename size matches Content-Length at $expected_size\n";
			$use_possible_file = 1;
		}
	}

	if( $use_possible_file ) {
		print STDERR "File with up-to-date timestamp already exists: $possible_filename\n";
		$new_file = $possible_filename;
	} else {
		print STDERR "Downloading file";
		system("wget", "-N", "-P", $tempdir, $url) == 0
			or die "Failed to download file: $?\n";

		my $temp_stat = stat($tempdata);
		$new_file = filename_for_timestamp($top_level, $filename, $temp_stat->mtime);

		move($tempdata, $new_file) or die "Failed to move file: $!\n";
	}

	die "Could not set the $full_path to new file: @{[ $new_file // 'none' ]}" unless defined $new_file and -r $new_file;

	# Move replaces atomically.
	#
	# NOTE: this will still leave a temporary symlink file if the move
	# fails.
	print STDERR "Creating symlink $full_path to $new_file\n";
	my $temp_symlink = "${full_path}.tmp";
	symlink(basename($new_file), $temp_symlink)
		or die "Failed to create temporary symlink: $!\n";
	move($temp_symlink, $full_path)
		or die "Failed to update symlink: $!\n";
} else {
	print STDERR "$0: The file $full_path has not been modified.\n";
}

sub usage {
	return "Usage: $0 --url=<URL> --file=<full_path_to_file>\n";
}
