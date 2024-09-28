package PackageFile::Platform::APT::DpkgInfo;
# ABSTRACT: Uses dpkg info files to retrieve packages and files

use strict;
use warnings;
use File::Find;

use PackageFile::Scope qw(INSTALLED);

sub scope {
	return INSTALLED;
}

sub extract {
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
}

1;
