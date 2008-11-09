use strict;
use warnings;
use Test::More tests => 5;

use Favour::Schema::Color;
use Favour::Schema::ColorPreference;
use Favour::Schema::PreferenceGraph;

my ($red, $orange, $yellow, $green, $blue, $violet) = map { # emacs doesn't have indigo
    Favour::Schema::Color->new( code => "#$_" );
} qw/ff0000 ffa500 ffff00 00ff00 0000ff 9400d3/;

sub pair($$) {
    Favour::Schema::ColorPreference->new(
        better => $_[0], worse => $_[1],
    );
}

my $set = Favour::Schema::PreferenceGraph->new;
ok $set;

$set->insert( pair $green, $blue );
ok $set->_get_color($green)->worse->member($blue);
ok $set->_get_color($blue)->better->member($green);

$set->insert( pair $red, $orange );
$set->insert( pair $blue, $red );
$set->insert( pair $violet, $red );

sub cmp_colors($$;$) {
    my ($a, $b, $msg) = @_;
    is_deeply
      [ sort map { $_->as_hex } @$a ],
      [ sort map { $_->as_hex } @$b ],
      $msg;
}

cmp_colors [$set->favorites], [$green, $violet], 'got favorite colors';

$set->insert( pair $green, $violet );
cmp_colors [$set->favorites], [$green], 'green wins';

