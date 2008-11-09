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

__PACKAGE__->meta->make_immutable;
no Moose;

1;
