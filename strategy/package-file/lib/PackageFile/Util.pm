package PackageFile::Util;

use strict;
use warnings;

use Capture::Tiny qw(capture_stdout);

use Exporter 'import';
our @EXPORT_OK = qw();

sub line_count {
	my ($file) = @_;
	my ($stdout, $exit) = capture_stdout { system(qw(wc -l), $file) };
	die "Could not run wc" unless 0 == $exit;
	( $stdout =~ /^(\d+)/ )[0];
}

1;
