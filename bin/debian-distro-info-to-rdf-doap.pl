#!/usr/bin/env perl

use strict;
use warnings;
use LWP::Simple;
use Text::CSV;
use Attean;
use Attean::RDF;
use URI::Namespace;

my $url = "https://salsa.debian.org/debian/distro-info-data/-/raw/main/debian.csv";
my $content = get($url);
die "Couldn't get $url" unless defined $content;

my $csv = Text::CSV->new({ binary => 1, auto_diag => 1 });
open my $fh, '<', \$content or die "Failed to open memory file: $!";
$csv->header($fh);

my $model = Attean->temporary_model;

my $ex = URI::Namespace->new('http://example.com/debian#');
my $rdf = URI::Namespace->new('http://www.w3.org/1999/02/22-rdf-syntax-ns#');
my $rdfs = URI::Namespace->new('http://www.w3.org/2000/01/rdf-schema#');
my $xsd = URI::Namespace->new('http://www.w3.org/2001/XMLSchema#');
my $doap = URI::Namespace->new('http://usefulinc.com/ns/doap#');

use URI::NamespaceMap;
my $ns = URI::NamespaceMap->new;

$ns->add_mapping('' => $ex);
$ns->add_mapping(rdf => $rdf);
$ns->add_mapping(rdfs => $rdfs);
$ns->add_mapping(xsd => $xsd);
$ns->add_mapping(doap => $doap);

my $g = iri('http://example.com/graph');
my $debian_project = iri($ex->as_string . 'Debian');

# Add Debian as a DOAP project
$model->add_quad(quad($debian_project, iri($rdf->type->as_string), iri($doap->Project->as_string), $g));
$model->add_quad(quad($debian_project, iri($rdfs->label->as_string), literal('Debian GNU/Linux'), $g));
$model->add_quad(quad($debian_project, iri($doap->name->as_string), literal('Debian GNU/Linux'), $g));
$model->add_quad(quad($debian_project, iri($doap->hompeage->as_string), iri("https://www.debian.org/"), $g));
$model->add_quad(quad($debian_project, iri($doap->iri('support-forum')->as_string), iri("https://www.debian.org/support"), $g));
$model->add_quad(quad($debian_project, iri($doap->iri('bug-database')->as_string), iri("https://bugs.debian.org/"), $g));

while (my $row = $csv->getline_hr($fh)) {
    my $release = iri($ex->as_string . $row->{series});

    $model->add_quad($_) for (
        quad($release, iri($rdf->type->as_string), iri($doap->Version->as_string), $g),

        quad($release, iri($rdfs->label->as_string), literal($row->{series}), $g),
        quad($release, iri($ex->series->as_string), literal($row->{series}), $g),
        quad($release, iri($doap->name->as_string), literal($row->{series}), $g),

        ($row->{version}
            ? quad($release, iri($doap->revision->as_string), literal($row->{version}), $g)
            : () ),

        quad($release, iri($ex->codename->as_string), literal($row->{codename}), $g),

        quad($debian_project, iri($doap->release->as_string), $release, $g),

        ($row->{created}
            ? quad($release, iri($doap->created->as_string), dtliteral($row->{created}, $xsd->date), $g)
            : ()),
        ($row->{release}
            ? quad($release, iri($ex->releaseDate->as_string), dtliteral($row->{release}, $xsd->date), $g)
            : ()),
        ($row->{eol}
            ? quad($release, iri($ex->endOfLife->as_string), dtliteral($row->{eol}, $xsd->date), $g)
            : ()),
        ($row->{'eol-lts'}
            ? quad($release, iri($ex->endOfLifeLTS->as_string), dtliteral($row->{'eol-lts'}, $xsd->date), $g)
            : ()),
        ($row->{'eol-elts'}
            ? quad($release, iri($ex->endOfLifeELTS->as_string), dtliteral($row->{'eol-elts'}, $xsd->date), $g)
            : ()),
    );
}

my $serializer = Attean->get_serializer('turtle')->new(namespaces => $ns);
my $turtle = $serializer->serialize_iter_to_bytes($model->get_quads);

print $turtle;
