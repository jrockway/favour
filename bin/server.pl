#!/usr/bin/env perl

use strict;
use warnings;
use feature ':5.10';

use FindBin qw($Bin);

use lib "$Bin/../lib";
use Favour;

my $base = "$Bin/..";

Favour->new( app_root => Path::Class::dir($Bin)->parent )->start;
