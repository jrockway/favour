use strict;
use warnings;
use Favour::Schema::Color;
use Test::TableDriven (
    hex_to_hex => {
        '#000'    => '000000',
        '#000000' => '000000',
        '#abcdef' => 'abcdef',
        '#123'    => '112233',
        '1'       => '000001',
        '#fff'    => 'ffffff',
    },
    rgb_to_hex => {
        'rgb(255, 0, 0)' => 'ff0000',
        'rgb(0, 255, 0)' => '00ff00',
        'rgb(0, 0, 255)' => '0000ff',
        'rgb(1, 0, 0)'   => '010000',
        'rgb(0, 1, 0)'   => '000100',
        'rgb(0, 0, 1)'   => '000001',
        'rgb(3, 2, 1)'   => '030201',
    },
    eq => [
        [['#000', 0] => 1],
    ],
);

sub hex_to_hex {
    my ($in) = @_;
    return Favour::Schema::Color->new(code => $in)->as_hex;
}

sub rgb_to_hex {
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
