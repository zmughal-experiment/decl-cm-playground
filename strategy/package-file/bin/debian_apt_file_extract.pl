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
my %seen_package_file_combinations;
my $total_lines = 0;
my $unique_combinations = 0;
my $update_interval = 10000;  # Show update every 10000 lines

while (<$apt_file_output>) {
    $total_lines++;

    chomp;
    s/:\ /:/;  # Remove the space after the colon
    my ($package, $file) = split /:/, $_, 2;

    $seen_packages{$package} = 1;

    unless ($seen_package_file_combinations{$_}) {
        $seen_package_file_combinations{$_} = 1;
        $unique_combinations++;
        print "$_\n";
    }

    # Print progress every $update_interval lines
    if ($total_lines % $update_interval == 0) {
        warn sprintf("Progress: %d lines processed, %d unique package:file combinations, %d unique packages\n",
                     $total_lines, $unique_combinations, scalar(keys %seen_packages));
    }
}

close($apt_file_output);

my $total_packages = scalar(keys %seen_packages);

warn "Finished processing $total_lines input lines.\n";
warn "Found $total_packages unique packages.\n";
warn "Output $unique_combinations unique package:file combinations.\n";
