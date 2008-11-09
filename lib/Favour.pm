package Favour;

use MooseX::Types::Path::Class qw(Dir);
use Moose;
use Favour::Backend::Kioku;
use Favour::Server;
use Favour::Server::Context;


use namespace::clean -except => 'meta';

has 'app_root' => (
    is       => 'ro',
    isa      => Dir,
    required => 1,
    coerce   => 1,
);

has 'config' => (
    is      => 'ro',
    isa     => 'HashRef',
    default => sub {
        +{
            kioku_root => 'share/database',
        };
    },
);

has 'kioku' => (
    is         => 'ro',
    isa        => 'Favour::Backend::Kioku',
    lazy_build => 1,
);

has 'server' => (
    is         => 'ro',
    isa        => 'Favour::Server',
    lazy_build => 1,
);

sub _build_kioku {
    my $self = shift;
    my $path = $self->config->{kioku_root} || confess 'need kioku_root in config';
    return Favour::Backend::Kioku->new(
        storage => $self->app_root->subdir($path),
    );
}

sub _build_server {
    my $self = shift;
    return Favour::Server->new(
        app         => $self,
        static_base => $self->app_root->subdir('share/static'),
    );
}

sub start {
    my $self = shift;
    return $self->server->start;
}

1;
