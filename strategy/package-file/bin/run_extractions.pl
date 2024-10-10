#!/usr/bin/env perl
use strict;
use warnings;
use feature qw(say);
use stable qw(postderef);

use Capture::Tiny qw(tee capture_stdout);
use Data::Dumper;
use Path::Tiny v0.022;
use Module::Runtime qw(use_module);
use Module::Loader;

use lib::projectroot qw(lib);

use PackageFile::Scope qw(REPOSITORY);
use PackageFile::Speed qw(SLOW);

use PackageFile::Util;
use PackageFile::Config qw($PLATFORM_TYPES $TOP);
use PackageFile::ExtractorModule;

my $loader = Module::Loader->new;
my @extractors = $loader->find_modules('PackageFile::Platform');
for my $module (sort @extractors) {
    use_module($module);
    next if $module->speed eq SLOW;
    next unless $module->scope eq REPOSITORY;

    my $extractor = PackageFile::ExtractorModule->new(
        module => $module,
    );

    my $name = $extractor->name;

    print STDERR "Extracting files for $name...\n";
    my %platform_meta = $extractor->platform_meta->%*;

    my $top = path(qw(strategy package-file));
    my $lib_dir = $top->child(qw(lib))->absolute;
    my $output_file = $top
        ->absolute('work')->relative('.')
        ->child( "$name.list" )->absolute;
    if($output_file->exists && $output_file->size) {
        say join "\t",
            $module->scope,
            PackageFile::Util::line_count($output_file),
            $output_file->basename;
        next;
    }
    $output_file->touchpath;

    my @packages = sort(
        ( $platform_meta{perl_packages} // [] )->@*,
        ( $module->can(required_packages => )
        ? $module->required_packages->@*
        : ()
        ),
    );

    # Generate Dockerfile content
    my $dockerfile = <<~EOF;
        FROM $platform_meta{image}
        RUN @{[ sprintf $platform_meta{install_cmd},
                    join " ", @packages
                    ]}
    EOF

    # Build the Docker image
    my $image_name = lc "decl-cm-playground/package-file/extractor-$name";
    open(my $docker_build, '|-', 'docker', 'build', '-t', $image_name, '-')
        or die "Could not open pipe to docker build: $!";
    print $docker_build $dockerfile;
    close($docker_build);

    if ($? != 0) {
        print "Failed to build Docker image for $name.\n";
        next;
    }

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

    print STDERR "Docker command for $name:\n";
    print STDERR Dumper(\@cmd);

    my $exit = system(@cmd);

    my $failure = 0;
    if ($exit == 0) {
        print STDERR "Extraction complete for $name. Output saved to $output_file\n";
    } else {
        print STDERR "Failed to run Docker command for $name.\n";
        $failure = 1;
    }

    unless($output_file->size) {
        warn "Output $output_file was empty";
        $failure = 1;
    }

    if($failure) {
        $output_file->remove;
        next;
    }

    my ($head_stdout, $head_stderr, $head_exit) = tee {
        system('head', '-n', '5', $output_file);
    };
    print STDERR "Failed to read first few lines of $output_file.\n" unless $head_exit == 0;

    my ($wc_stdout, $wc_stderr, $wc_exit) = tee {
        system('wc', '-l', $output_file);
    };
    print STDERR "Failed to read line count of $output_file.\n" unless $wc_exit == 0;
    print STDERR "Line count: $wc_stdout\n";
}

print STDERR "All extractions completed.\n";
