package PackageFile::Speed;

use strict;
use warnings;
use Exporter 'import';

our @EXPORT_OK = qw(SLOW MEDIUM FAST);

use constant {
    SLOW => 'slow',
    MEDIUM => 'medium',
    FAST => 'fast',
};

1;
