package Favour::Schema::User;
use Moose;

has 'colors' => (
    is       => 'ro',
    isa      => 'Favour::Schema::ColorPairSet',
    required => 1,
    default => sub {
        Favour::Schema::ColorPairSet->new;
    },
);

1;
