package PackageFile::Config;
# ABSTRACT: Configuration

use strict;
use warnings;
use Exporter 'import';
use Path::Tiny v0.022;
use YAML qw(LoadFile);
use Const::Fast;

use lib::projectroot qw(lib);

our @EXPORT_OK = qw($PLATFORM_TYPES $TOP);

const our $PLATFORM_TYPES => do {
	my $platform_types_file = path($lib::projectroot::ROOT)
		->child('data', 'platform_types.yaml');
	LoadFile( $platform_types_file );
};

const our $TOP => do {
	my $walk_up = path(__FILE__);
	my $found;
	while( ! $walk_up->is_rootdir ) {
		$walk_up = $walk_up->parent;
		$found = $walk_up, last if $walk_up->child('.projectroot')->exists;
	}
	die "Unable to find .projectroot" unless defined $found;

	$found;
};

1;
