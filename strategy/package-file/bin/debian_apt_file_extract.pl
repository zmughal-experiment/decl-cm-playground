#!/usr/bin/env perl
use strict;
use warnings;
use IPC::Open3;

# Update apt-file database
warn "Updating apt-file database...\n";
my $pid = open3(my $in, '>&STDERR', '>&STDERR', 'apt-file', 'update');
waitpid($pid, 0);
die "Failed to update apt-file: $?" if $?;

# Run apt-file list command
warn "Running apt-file list command...\n";
open(my $apt_file_output, '-|', 'apt-file', 'list', '--stream-results', '-x', '^') or die "Cannot run apt-file: $!";

my %seen_packages;
my $total_packages = 0;
my $total_lines = 0;
my $update_interval = 10000;  # Show update every 10000 lines

while (<$apt_file_output>) {
    $total_lines++;

    s/:\ /:/;  # Remove the space after the colon
    my ($package, $file) = split /:/, $_, 2;

    unless ($seen_packages{$package}) {
        $seen_packages{$package} = 1;
        $total_packages++;
    }

    # Print progress every $update_interval lines
    if ($total_lines % $update_interval == 0) {
        warn sprintf("Progress: %d lines processed, %d unique packages found\n", $total_lines, $total_packages);
    }

    print;
}

close($apt_file_output);

warn "Finished processing $total_lines lines, found $total_packages unique packages.\n";
