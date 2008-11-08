use strict;
use warnings;
use Favour::Schema::Color;
use Test::TableDriven (
    hex_to_hex => {
        '#000'    => '000000',
        '#000000' => '000000',
        '#abcdef' => 'abcdef',
        '1'       => '000001',
        '#fff'    => 'f0f0f0',
    },
    eq => [
        [['#000', 0] => 1],
    ],
);

sub hex_to_hex {
    my ($in) = @_;
    return Favour::Schema::Color->new(code => $in)->as_hex;
}

sub eq {
    my ($in) = @_;
    my ($a, $b) = @$in;
    $_ = Favour::Schema::Color->new( code => $_ ) for ($a, $b);
    return $a == $b;
}

runtests;
