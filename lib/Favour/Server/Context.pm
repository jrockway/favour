package Favour::Server::Context;
use Favour::Server::Request;
use Favour::Server::Response;
use Favour::Schema::User;
use Moose;

has 'app' => (
    is       => 'ro',
    isa      => 'Favour',
    required => 1,
    handles  => ['kioku'],
);

has 'request' => (
    is       => 'ro',
    isa      => 'Favour::Server::Request',
    required => 1,
);

has 'stash' => (
    is       => 'ro',
    isa      => 'HashRef',
    required => 1,
    default  => sub { +{} },
);

sub BUILD {
    my $self = shift;
    $self->stash->{kioku_scope} = $self->kioku->new_scope;
}

sub make_response {
    my $self = shift;
    return Favour::Server::Response->new( @_ );
}

my $user = Favour::Schema::User->new; # for testing only

sub current_user {
    return $user;
}

1;
