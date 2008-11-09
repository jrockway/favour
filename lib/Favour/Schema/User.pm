package Favour::Schema::User;
use Moose;

has 'colors' => (
    is       => 'ro',
    isa      => 'Favour::Schema::PreferenceGraph',
    required => 1,
    default => sub {
        Favour::Schema::PreferenceGraph->new;
    },
);

__PACKAGE__->meta->make_immutable;
no Moose;

1;
