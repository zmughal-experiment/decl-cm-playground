package PackageFile::Platform::RPM::RpmQuery;
# ABSTRACT: Uses rpm queries to retrieve packages and files

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

sub platform_type {
	return 'rpm_dnf';
}

sub extract {
    my $package_dir = '/var/lib/rpm';

    warn "Starting Fedora extraction...\n";

    if (!-d $package_dir) {
        die "Error: $package_dir does not exist or is not a directory\n";
    }

    # Get list of all installed packages
    my @packages = `rpm -qa --dbpath $package_dir`;
    chomp @packages;

    for my $package (@packages) {
        #warn "Processing package: $package\n";
        my @files = `rpm -ql $package 2>&1`;
        if ($? != 0) {
            warn "Error running rpm command for $package: $!\n";
            next;
        }
        chomp @files;
        for my $file (@files) {
            print "$package:$file\n";
        }
    }

    warn "Fedora extraction completed.\n";
}

1;
