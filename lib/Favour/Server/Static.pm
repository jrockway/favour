package Favour::Server::Static;
use MooseX::Types::Path::Class qw(Dir);
use Moose;
use namespace::clean -except => 'meta';

has 'base' => (
    is       => 'ro',
    isa      => Dir,
    required => 1,
    coerce   => 1,
);

sub BUILD {
    my $self = shift;
    confess $self->base. ' does not exist!' unless -d $self->base;
}

sub resource {
    my ($self, $path) = @_;
    return Favour::Server::Static::Asset->new(
        file => join('/', $self->base, $path),
    );
}

package Favour::Server::Static::Asset;
use MooseX::Types::Path::Class qw(File);
use Moose;
use namespace::clean -except => 'meta';

has 'file' => (
    is       => 'ro',
    isa      => File,
    required => 1,
    coerce   => 1,
);

has 'extension' => (
    is         => 'ro',
    isa        => 'Str',
    lazy_build => 1,
);

has 'content_type' => (
    is         => 'ro',
    isa        => 'Str',
    lazy_build => 1,
);

sub BUILD {
    my $self = shift;
    confess $self->file. ' does not exist!' unless -f $self->file;
}

sub _build_extension {
    my $self = shift;
    my $filename = $self->file->basename;
    $filename =~ /[.]([^.]+)$/ and return $1;
    return '';
}

my %ext_map = (
    css  => 'text/css',
    js   => 'text/javascript',
    html => 'application/xhtml+xml',
    png  => 'image/png',
);

sub _build_content_type {
    my $self = shift;
    return $ext_map{$self->extension} || 'application/octet-stream';
}

sub serve {
    my ($self, $context, @args) = @_;
    my $data_fh = $self->file->openr;
    return $context->make_response(
        body         => $data_fh,
        content_type => $self->content_type,
    );
}

1;
