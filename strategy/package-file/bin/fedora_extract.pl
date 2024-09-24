#!/usr/bin/env perl
use strict;
use warnings;

my $package_dir = '/var/lib/rpm';

warn "Starting Fedora extraction...\n";

if (!-d $package_dir) {
    die "Error: $package_dir does not exist or is not a directory\n";
}

# Get list of all installed packages
my @packages = `rpm -qa --dbpath $package_dir`;
chomp @packages;

foreach my $package (@packages) {
    #warn "Processing package: $package\n";
    my @files = `rpm -ql $package 2>&1`;
    if ($? != 0) {
        warn "Error running rpm command for $package: $!\n";
        next;
    }
    chomp @files;
    foreach my $file (@files) {
        print "$package:$file\n";
    }
}

warn "Fedora extraction completed.\n";