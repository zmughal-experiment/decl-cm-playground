package PackageFile::Platform::RPM::Unzck;
# ABSTRACT: Uses unzck to extract package and file information from zchunk files

use strict;
use warnings;
use File::Find;

use PackageFile::Scope qw(REPOSITORY);

sub scope {
	return REPOSITORY;
}

sub extract {
    my $cache_dir = '/var/cache/dnf';
    my @filelists_files;

    find(
        sub {
            push @filelists_files, $File::Find::name if -f $_ && $_ =~ /filelists\.xml\.zck$/;
        },
        $cache_dir
    );

    my %seen_package_file_combinations;
    my $total_lines = 0;
    my $unique_combinations = 0;
    my $update_interval = 100000;

    for my $filelist (@filelists_files) {
        open(my $zck_output, '-|', "unzck -c $filelist") or die "Cannot run unzck: $!";

        my $current_package = '';
        while (my $line = <$zck_output>) {
            if ($line =~ /<package.*name="([^"]+)"/) {
                $current_package = $1;
            } elsif ($line =~ /<file>(.+?)<\/file>/) {
                my $file = $1;
                $total_lines++;

                my $combination = "$current_package:$file";
                unless ($seen_package_file_combinations{$combination}) {
                    $seen_package_file_combinations{$combination} = 1;
                    $unique_combinations++;
                    print "$combination\n";
                }

                if ($total_lines % $update_interval == 0) {
                    warn sprintf("Progress: %d lines processed, %d unique package:file combinations\n",
                                 $total_lines, $unique_combinations);
                }
            }
        }
        close($zck_output);
    }

    warn "Finished processing $total_lines input lines.\n";
    warn "Output $unique_combinations unique package:file combinations.\n";
    warn "Found " . scalar(keys %seen_package_file_combinations) . " packages.\n";
}

1;
