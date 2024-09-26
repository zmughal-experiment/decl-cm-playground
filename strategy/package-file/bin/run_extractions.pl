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
    },
    rpm_dnf    => {
        image => 'fedora:latest',
        install_cmd => 'dnf install -y %s'
    },
);

my @distributions = (
    {
        name => 'debian',
        script => 'debian_extract.pl',
        packages => [qw(perl perl-modules)],
        platform => 'debian_apt',
    },
    {
        name => 'debian_dpkg-query',
        script => 'debian_dpkg-query_extract.pl',
        packages => [qw(perl perl-modules)],
        platform => 'debian_apt',
    },
    {
        name => 'debian_apt_file',
        script => 'debian_apt_file_extract.pl',
        packages => [qw(perl perl-modules apt-file)],
        platform => 'debian_apt',
    },
    {
        name => 'fedora',
        script => 'fedora_extract.pl',
        packages => [qw(perl-interpreter)],
        platform => 'rpm_dnf',
    },
    {
        name => 'fedora_dnf_repoquery',
        script => 'fedora_dnf_repoquery_extract.pl',
        packages => [qw(perl-interpreter)],
        platform => 'rpm_dnf',
    },
    {
        name => 'fedora_unzck',
        script => 'fedora_unzck_extract.pl',
        packages => [qw(perl-interpreter zchunk perl-File-Find)],
        platform => 'rpm_dnf',
    },
);

for my $dist (@distributions) {
    print "Extracting files for $dist->{name}...\n";

    # Generate Dockerfile content
    my $dockerfile = <<~EOF;
        FROM $platform_type{$dist->{platform}}{image}
        RUN @{[ sprintf $platform_type{$dist->{platform}}{install_cmd},
                    join " ", sort $dist->{packages}->@* ]}
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
    my $script_file = $top->child(qw(bin), $dist->{script});
    my $output_file = $top->absolute('work')->relative('.')->child( "$dist->{name}.list" );
    next if $output_file->exists;
    $output_file->touchpath;

    # Run the Docker container
    my @cmd = (
        'docker', 'run', '--rm',
        '-v', "$script_file:/extract.pl:ro",
        '-v', "$output_file:/output.txt",
        $image_name,
        'bash', '-c', 'perl /extract.pl > /output.txt'
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
