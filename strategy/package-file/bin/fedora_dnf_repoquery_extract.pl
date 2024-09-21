#!/usr/bin/env perl
use strict;
use warnings;
use IPC::Open3;

# Update dnf cache
warn "Updating dnf cache...\n";
my $pid = open3(my $in, '>&STDERR', '>&STDERR', 'dnf', 'makecache');
waitpid($pid, 0);
die "Failed to update dnf cache: $?" if $?;


my @dnf_opts = ('--cacheonly');

# Run dnf repoquery command to get package names
warn "Getting package list...\n";
open(my $package_list, '-|', 'dnf', @dnf_opts, 'repoquery', '--qf', '%{name}') or die "Cannot run dnf repoquery for package list: $!";

my @packages = <$package_list>;
chomp @packages;
close($package_list);

my %seen_package_file_combinations;
my $total_lines = 0;
my $unique_combinations = 0;
my $update_interval = 10000;  # Show update every 10000 lines

foreach my $package (@packages) {
    warn "Processing package: $package\n";
    open(my $dnf_output, '-|', 'dnf', @dnf_opts, 'repoquery', '-l', $package) or die "Cannot run dnf repoquery for $package: $!";

    while (my $file = <$dnf_output>) {
        $total_lines++;
        chomp $file;

        my $combination = "$package:$file";
        unless ($seen_package_file_combinations{$combination}) {
            $seen_package_file_combinations{$combination} = 1;
            $unique_combinations++;
            print "$combination\n";
        }

        # Print progress every $update_interval lines
        if ($total_lines % $update_interval == 0) {
            warn sprintf("Progress: %d lines processed, %d unique package:file combinations\n",
                         $total_lines, $unique_combinations);
        }
    }

    close($dnf_output);
}

warn "Finished processing $total_lines input lines.\n";
warn "Output $unique_combinations unique package:file combinations.\n";
warn "Found " . scalar(@packages) . " packages.\n";
