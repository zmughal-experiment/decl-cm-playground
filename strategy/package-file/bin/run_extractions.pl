#!/usr/bin/env perl
use strict;
use warnings;
use Capture::Tiny qw(tee);
use Data::Dumper;
use Path::Tiny v0.022;

my @distributions = (
    {
        name => 'debian',
        image => 'debian:latest',
        script => 'debian_extract.pl',
        output => 'debian_files.txt',
        install_cmd => 'apt-get update && apt-get install -y perl perl-modules',
    },
    {
        name => 'debian_apt_file',
        image => 'debian:latest',
        script => 'debian_apt_file_extract.pl',
        output => 'debian_apt_file_files.txt',
        install_cmd => 'apt-get update && apt-get install -y perl perl-modules apt-file',
    },
    {
        name => 'fedora',
        image => 'fedora:latest',
        script => 'fedora_extract.pl',
        output => 'fedora_files.txt',
        install_cmd => 'dnf install -y perl-interpreter',
    },
);

foreach my $dist (@distributions) {
    print "Extracting files for $dist->{name}...\n";

    # Generate Dockerfile content
    my $dockerfile = <<~EOF;
        FROM $dist->{image}
        RUN $dist->{install_cmd}
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

    my $output_file = path(qw(work package-file), $dist->{output});
    $output_file->touchpath;

    # Run the Docker container
    my @cmd = (
        'docker', 'run', '--rm',
        '-v', "./strategy/package-file/bin/$dist->{script}:/extract.pl:ro",
        '-v', "@{[$output_file->absolute->stringify]}:/output.txt",
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
