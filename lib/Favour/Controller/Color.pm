package Favour::Controller::Color;
use Favour::Schema::Color;
use Favour::Schema::ColorPreference;
use Moose;

has 'context' => (
    is       => 'ro',
    isa      => 'Favour::Server::Context',
    required => 1,
);

sub add_color_pair {
    my ($self, $args) = @_;

    my $good = $args->{good};
    my $bad  = $args->{bad};

    # add leading '#' to hex colors, if it's not already there
    # then inflate
    $_ = Favour::Schema::Color->new( code => $_ ) for ($good, $bad);

    my $pref = Favour::Schema::ColorPreference->new(
        better => $good,
        worse  => $bad,
    );

    my $prefset = $self->context->current_user->color_preferences;
    $prefset->insert($pref);
    $self->context->kioku->store($prefset);
}

1;
