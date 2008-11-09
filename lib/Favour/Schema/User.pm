package Favour::Schema::User;
use Favour::Schema::PreferenceGraph;
use Moose;

has 'color_preferences' => (
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
