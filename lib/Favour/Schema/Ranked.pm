package Favour::Schema::Ranked;
use Moose::Role;
use KiokuDB::Util qw(set);

has [qw/better worse/] => (
    is       => 'ro',
    does     => 'KiokuDB::Set',
    required => 1,
    default  => sub { set() },
);

1;
