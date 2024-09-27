#!/usr/bin/env perl
use strict;
use warnings;
use feature qw(say);
use stable qw(postderef);

use Capture::Tiny qw(tee);
use Data::Dumper;
use Path::Tiny v0.022;

my %platform_type = (
    debian_apt => {
        image => 'debian:latest',
        install_cmd => 'apt-get update && apt-get install -y --no-install-recommends %s',
        perl_packages => [qw(perl perl-modules cpanminus)],
    },
    rpm_dnf    => {
        image => 'fedora:latest',
        install_cmd => 'dnf install -y %s',
        perl_packages => [qw(perl-interpreter perl-App-cpanminus)],
    },
);

my @distributions = (
    {
        name => 'debian',
        module => 'PackageFile::Platform::APT::DpkgInfo',
        platform => 'debian_apt',
    },
    {
        name => 'debian_dpkg-query',
        module => 'PackageFile::Platform::APT::DpkgQuery',
        platform => 'debian_apt',
    },
    {
        name => 'debian_apt_file',
        module => 'PackageFile::Platform::APT::AptFile',
        packages => [qw(apt-file)],
        platform => 'debian_apt',
    },
    {
        name => 'fedora',
        module => 'PackageFile::Platform::RPM::RpmQuery',
        platform => 'rpm_dnf',
    },
    {
        name => 'fedora_dnf_repoquery',
        module => 'PackageFile::Platform::RPM::DnfRepoquery',
        platform => 'rpm_dnf',
    },
    {
        name => 'fedora_unzck',
        module => 'PackageFile::Platform::RPM::Unzck',
        packages => [qw(zchunk perl-File-Find)],
        platform => 'rpm_dnf',
    },
);

for my $dist (@distributions) {
    print "Extracting files for $dist->{name}...\n";
    my %platform_meta = $platform_type{$dist->{platform}}->%*;

    # Generate Dockerfile content
    my $dockerfile = <<~EOF;
        FROM $platform_meta{image}
        RUN @{[ sprintf $platform_meta{install_cmd},
                    join " ",
                        sort(($platform_meta{perl_packages} // [])->@*,
                             ($dist->{packages} // [])->@*, )
                    ]}
    EOF

    # Build the Docker image
    my $image_name = "decl-cm-playground/package-file/extractor-$dist->{name}";
    open(my $docker_build, '|-', 'docker', 'build', '-t', $image_name, '-')
        or die "Could not open pipe to docker build: $!";
    print $docker_build $dockerfile;
    close($docker_build);

    if ($? != 0) {
        print "Failed to build Docker image for $dist->{name}.\n";
        next;
    }

    my $top = path(qw(strategy package-file));
    my $module = $dist->{module};
    my $lib_dir = $top->child(qw(lib))->absolute;
    my $output_file = $top
        ->absolute('work')->relative('.')
        ->child( "$dist->{name}.list" )->absolute;
    next if $output_file->exists;
    $output_file->touchpath;

    # Run the Docker container
    my @cmd = (
        'docker', 'run', '--rm',
        '-v', "$lib_dir:/work/lib:ro",
        '-v', "$output_file:/output.txt",
        '-e', "MODULE=$module",
        $image_name,
        'bash', '-c',
            q{perl -I/work/lib -M$MODULE -MEnv=MODULE -e '$MODULE->extract'  > /output.txt}
    );

    print "Docker command for $dist->{name}:\n";
    print Dumper(\@cmd);

    my $exit = system(@cmd);

    if ($exit == 0) {
        print "Extraction complete for $dist->{name}. Output saved to $output_file\n";
    } else {
        print "Failed to run Docker command for $dist->{name}.\n";
    }

    my ($head_stdout, $head_stderr, $head_exit) = tee {
        system('head', '-n', '5', $output_file);
    };
    print "Failed to read first few lines of $output_file.\n" unless $head_exit == 0;

    my ($wc_stdout, $wc_stderr, $wc_exit) = tee {
        system('wc', '-l', $output_file);
    };
    print "Failed to read line count of $output_file.\n" unless $wc_exit == 0;
    print "Line count: $wc_stdout\n";
}

print "All extractions completed.\n";
