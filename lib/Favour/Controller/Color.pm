package Favour::Controller::Color;
use Favour::Schema::Color;
use Favour::Schema::ColorPreference;
use Moose;
use List::Util qw(shuffle);

use namespace::clean -except => 'meta';

has 'context' => (
    is       => 'ro',
    isa      => 'Favour::Server::Context',
    required => 1,
);

sub add_color_pair {
    my ($self, $good, $bad) = @_;

    # inflate
    $_ = Favour::Schema::Color->new( code => $_ ) for ($good, $bad);

    my $pref = Favour::Schema::ColorPreference->new(
        better => $good,
        worse  => $bad,
    );

    my $prefset = $self->context->current_user->color_preferences;
    $prefset->insert($pref);
    $self->context->kioku->store($prefset);

    return;
}

sub _color_return {
    return [ map { $_->as_hex } @_ ];
}

sub list_favorites {
    my $self = shift;
    _color_return( $self->context->current_user->color_preferences->favorites );
}

sub random_color {
    Favour::Schema::Color->new( code => int rand hex('ffffff') );
}

sub get_colors_to_compare {
    my $self = shift;

    my @favorites = $self->context->current_user->color_preferences->favorites;

    # as number of favorites increases, increase probability
    # of reusing colors (to eliminate a favorite)
    my $prob = @favorites / 15;
    if($prob > 1 || rand() < $prob && @favorites > 2 ){
        my ($a, $b) = @{[shuffle @favorites]}[0,1];
        return _color_return( $a, $b );
    }

    # chance to replace a favorite, if the competition is up to it
    if( rand 10 < 1 ){
        my $a = [shuffle @favorites]->[0];
        if( rand() < 0.5 ){
            return _color_return( $a, random_color() );
        }
        else {
            return _color_return( random_color(), $a );
        }
    }

    return _color_return( random_color(), random_color() );
}

1;
