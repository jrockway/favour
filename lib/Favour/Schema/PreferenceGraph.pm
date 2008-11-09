package Favour::Schema::PreferenceGraph;
use Moose;
use MooseX::AttributeHelpers;
use Favour::Schema::ColorPreference;
use Favour::Schema::Ranked;
use Set::Object;


has 'colors' => (
    metaclass => 'Collection::Hash',
    is        => 'rw',
    isa       => 'HashRef[Favour::Schema::Color]',
    required  => 1,
    default   => sub { {} },
    provides  => {
        exists => '_color_exists',
        get    => '_get_color',
        set    => '_set_color',
        values => '_seen_colors',
    },
);

before '_get_color' => sub {
    my ($self, $color) = @_;
    confess "$color must be an object" unless blessed $color;

    if(!$self->_color_exists($color->as_hex)){
        Favour::Schema::Ranked->meta->apply($color);
        $self->_set_color($color->as_hex, $color);
    }
};

sub insert {
    my ($self, $pair) = @_;

    my $better = $self->_get_color($pair->better);
    my $worse  = $self->_get_color($pair->worse);

    # forget we've ever rated this pair before
    $better->worse->delete($worse);
    $better->better->delete($worse);
    $worse->worse->delete($better);
    $worse->better->delete($better);

    # update rankings
    $better->worse->insert($worse);
    $worse->better->insert($better);
}

sub _favorites {
    my ($color, $seen) = @_;

    return if $seen->member($color);
    $seen->insert($color);

    if($color->better->is_null){
        return $color;
    }
    else {
        my @result;
        for my $next_color ($color->better->members){
            push @result, _favorites($next_color, $seen);
        }
        return @result;
    }
}

sub favorites {
    my ($self) = @_;

    my $seen = Set::Object->new;
    my @result;
    for my $color ($self->_seen_colors){
        push @result, _favorites($color, $seen);
    }
    return @result;
}

__PACKAGE__->meta->make_immutable;
no Moose;

1;
