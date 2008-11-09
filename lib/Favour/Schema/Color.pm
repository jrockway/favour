package Favour::Schema::Color;
use Moose;
use Moose::Util::TypeConstraints;
use Scalar::Util ();
use 5.010;

use overload (
    '=='     => \&eq,
    'eq'     => \&eq,
    '""'     => \&as_hex,
    fallback => 'yes',
);

subtype ColorCode => as 'Int' => where {
    $_ >= 0 &&
    $_ <= hex('ffffff')
};

coerce ColorCode => from 'Str' => via {
    given(uc $_){
        when(/^#((?:[A-Z0-9]+){6})$/){
            return hex($1);
        }
        when(/^#([A-Z0-9])([A-Z0-9])([A-Z0-9])/){
            return hex("${1}0${2}0${3}0");
        }
        when(Scalar::Util::looks_like_number($_)){ # OH HAI MOOSE. IS NOT STR.
            return $_;
        }
        default {
            confess "invalid color code $_";
        }
    }
};

has 'code' => (
    is       => 'ro',
    isa      => 'ColorCode',
    coerce   => 1,
    required => 1,
);

sub eq {
    my ($a, $b) = @_;
    return $a->code == $b->code;
}

sub as_hex {
    my $self = shift;
    return sprintf("%06x", $self->code);
}

__PACKAGE__->meta->make_immutable;
no Moose;

1;
