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

lazy output_file => sub {
	my ($self) = @_;
	path($lib::projectroot::ROOT)
		->relative($TOP)
		->absolute($TOP->child('work'))
		->child( "@{[ $self->name ]}.list" );
};

lazy packages => sub {
	my ($self) = @_;
	my @packages = sort(

		( $self->platform_meta->{perl_packages} // [] )->@*,

		( $self->module->can(required_packages => )
		? $self->module->required_packages->@*
		: ()
		),
    );
    \@packages;
};

1;
