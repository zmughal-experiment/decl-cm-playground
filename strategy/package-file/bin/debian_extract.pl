#!/usr/bin/env perl
use strict;
use warnings;
use File::Find;

my $package_dir = '/var/lib/dpkg/info';

find(
    sub {
        return unless -f $_ && $_ =~ /\.list$/;
        my $package = $_;
        $package =~ s/\.list$//;
        open my $fh, '<', $_ or die "Cannot open file $_: $!";
        while (my $line = <$fh>) {
            chomp $line;
            print "$package:$line\n";
        }
        close $fh;
    },
    $package_dir
);
