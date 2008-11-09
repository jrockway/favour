package Favour::Schema::User::Authenticated;
use Moose;
use URI;

extends 'Favour::Schema::User';

has 'openid' => (
    is       => 'ro',
    isa      => 'URI',
    required => 1,
);


has 'friends' => (
    is       => 'ro',
    does     => 'KiokuDB::Set',
    required => 1,
    default  => sub { set() },
);

1;
