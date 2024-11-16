#!/usr/bin/env perl

use strict;
use warnings;
use feature qw(say state);
use Syntax::Construct qw(<<~);
use Feature::Compat::Try;
use DBI;
use DBD::SQLite 1.47_01 ();
use File::Temp qw(tempfile);
use YAML qw(LoadFile);
use Capture::Tiny qw(capture_stdout);
use Module::Loader;
use Module::Runtime qw(use_module);
use Path::Tiny v0.022;
use Term::ProgressBar;

use lib::projectroot qw(lib);

use PackageFile::Scope qw(REPOSITORY);
use PackageFile::Speed qw(SLOW);
use PackageFile::ExtractorModule;
use PackageFile::Util;

die "SQLite too old" if DBD::SQLite::Constants::SQLITE_VERSION_NUMBER() < 3007011;

my $dbh = DBI->connect("dbi:SQLite:dbname=package_clusters.db", "", "",
    {
        RaiseError => 1,
        AutoCommit => 1,

        # used for DB deploy in create_database
        sqlite_allow_multiple_statements => 1,
    });

sub create_database {
    my $sql = path($lib::projectroot::ROOT)
        ->child(qw( sql ddl schema.sql ))->slurp_utf8;
    $dbh->do($sql) or die "Could not load DDL: @{[ $dbh->errstr ]}";
}

sub get_distribution_id {
    my ($name) = @_;
    local $dbh->{AutoCommit} = 1;
    local $dbh->{RaiseError} = 1;
    my $insert_dist_sth = $dbh->prepare(<<~'SQL');
    INSERT INTO distributions (name) VALUES (?) ON CONFLICT DO NOTHING;
    SQL
    my $select_dist_sth = $dbh->prepare(<<~'SQL');
    SELECT id FROM distributions WHERE name = ? LIMIT 1;
    SQL

    $insert_dist_sth->execute($name);

    $select_dist_sth->execute($name);
    my ($id) = $select_dist_sth->fetchrow_array();
    return $id;
}

sub import_data {
    my ($module) = @_;

    local $dbh->{AutoCommit} = 0;
    local $dbh->{RaiseError} = 1;

    my $extractor = PackageFile::ExtractorModule->new(
        module => $module,
    );

    my $name = $extractor->name;
    my $name_id = get_distribution_id($name);

    say "Importing data for $name using $module...";

    my $input_file = $extractor->output_file;

    return unless $input_file->exists && $input_file->size;

    my $sth = $dbh->prepare(<<~SQL);
    INSERT INTO package_files
    (distribution_id, package, file)
    VALUES (@{[ $dbh->quote($name_id) ]}, ?, ?);
    SQL

    my $fh = $input_file->openr_raw;

    my $total_lines = PackageFile::Util::line_count($input_file);

    my $progress = Term::ProgressBar->new({
        name  => "Importing $name",
        count => $total_lines,
        ETA   => 'linear',
    });

    my $line_count = 0;
    my $next_update = 0;

    try {
        while (my $line = <$fh>) {
            chomp $line;
            my ($package, $file) = split /:/, $line, 2;
            $sth->execute($package, $file);

            $line_count++;

            if($line_count >= $next_update) {
                $next_update = $progress->update($line_count);
            }
        }

        $dbh->commit;
        $progress->update($total_lines);

        say "Imported $line_count lines for $name";
    } catch($e) {
        $dbh->rollback;
        die $e;
    }
}

# Main execution
create_database();

my $loader = Module::Loader->new;
my @extractors = $loader->find_modules('PackageFile::Platform');

for my $module (sort @extractors) {
    use_module($module);
    next if $module->speed eq SLOW;
    next unless $module->scope eq REPOSITORY;

    import_data($module);
}

$dbh->disconnect;
