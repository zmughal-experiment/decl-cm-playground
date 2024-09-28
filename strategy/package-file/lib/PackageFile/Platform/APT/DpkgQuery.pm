package PackageFile::Platform::APT::DpkgQuery;
# ABSTRACT: Uses dpkg-query to retrieve packages and files

use strict;
use warnings;

use PackageFile::Scope qw(INSTALLED);
use PackageFile::Speed qw(FAST);

sub scope {
	return INSTALLED;
}

sub speed {
	return FAST;
}

sub extract {
    my @packages = split /\n/, `dpkg-query -f '\${Package}\n' -W`;
    my $total_packages = scalar @packages;
    my $processed = 0;

    for my $package (@packages) {
        $processed++;
        my @files = split /\n/, `dpkg -L $package`;
        for my $file (@files) {
            next if $file =~ /^package diverts others to:\ /;
            print "$package:$file\n";
        }
        warn sprintf("Progress: %d/%d packages processed\n", $processed, $total_packages) if $processed % 100 == 0;
    }

    warn "Finished processing $total_packages packages.\n";
}

1;
