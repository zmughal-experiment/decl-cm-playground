package PackageFile::ExtractorModule;
# ABSTRACT: Represents a runnable extractor module

use Mu;
use Types::Common qw(ClassName);
use Path::Tiny v0.022;

use PackageFile::Config qw($PLATFORM_TYPES $TOP);

ro module => ( isa => ClassName, required => 1 );

lazy name => sub {
	my ($self) = @_;
	my $module = $self->module;
	my $name = sprintf "%s__%s",
		$module->platform_type,
		($module =~ /::Platform::(.*)$/)[0] =~ s/::/_/gr;
	$name;
};

lazy platform_meta => sub {
	my ($self) = @_;
	$PLATFORM_TYPES->{$self->module->platform_type};
};

1;
