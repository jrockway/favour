#!/usr/bin/env perl

use strict;
use warnings;
use feature ':5.10';

use FindBin qw($Bin);
use lib 'lib';

use List::Util qw(shuffle);
use Favour::Schema::Color;
use Favour::Schema::ColorPair;
use Favour::Schema::ColorPairSet;
use Favour::Backend::Kioku;

sub pair($$) {
    Favour::Schema::ColorPair->new(
        better => Favour::Schema::Color->new( code => $_[0] ),
        worse  => Favour::Schema::Color->new( code => $_[1] ),
    );
}

my $k = Favour::Backend::Kioku->new(storage => "$Bin/share/database");
my $s = $k->new_scope;

my $set = Favour::Schema::ColorPairSet->new;

$|++;
print "inserting.";
for(1..100000){
    print '.' if $_ % 1000 == 0;
    $set->insert( pair( int rand 0xfff, int rand 0xfff ) );
}
say ".done";

my $id = $k->store($set);
warn $id;

#say scalar $set->favorites;
