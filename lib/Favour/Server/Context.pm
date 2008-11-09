package Favour::Server::Context;
use Favour::Server::Request;
use Favour::Server::Response;
use Moose;

has 'app' => (
    is       => 'ro',
    isa      => 'Favour',
    required => 1,
);

has 'request' => (
    is       => 'ro',
    isa      => 'Favour::Server::Request',
    required => 1,
);

sub make_response {
    my $self = shift;
    return Favour::Server::Response->new( @_ );
}

1;
