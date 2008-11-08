package Favour::Schema::ColorPair;
use Moose;
use Favour::Schema::Color;

has [qw/better worse/] => (
    is       => 'ro',
    isa      => 'Favour::Schema::Color',
    required => 1,
);

1;
