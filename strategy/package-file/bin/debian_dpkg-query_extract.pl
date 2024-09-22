#!/usr/bin/env perl
use strict;
use warnings;

my @packages = split /\n/, `dpkg-query -f '\${Package}\n' -W`;
my $total_packages = scalar @packages;
my $processed = 0;

foreach my $package (@packages) {
    $processed++;
    my @files = split /\n/, `dpkg -L $package`;
    foreach my $file (@files) {
        next if $file =~ /^package diverts others to:\ /;
        print "$package:$file\n";
    }
    warn sprintf("Progress: %d/%d packages processed\n", $processed, $total_packages) if $processed % 100 == 0;
}

warn "Finished processing $total_packages packages.\n";
