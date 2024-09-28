package PackageFile::Scope;

use strict;
use warnings;
use Exporter 'import';

our @EXPORT_OK = qw(INSTALLED REPOSITORY);

use constant {
	INSTALLED => 'installed',
	REPOSITORY => 'repository',
};

1;
