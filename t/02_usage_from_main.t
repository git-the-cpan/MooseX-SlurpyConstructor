#!/usr/bin/perl

use strict;
use warnings;

use Test::More tests => 2;

my $warning;

{
    local $SIG{ __WARN__ } = sub { $warning = shift() };

    eval "use MooseX::SlurpyConstructor";

    ok( defined $warning,
        "warning returned when trying to export into main"
    );
    like( $warning,
        qr/MooseX::SlurpyConstructor does not export .*'main'/,
        "expected warning when trying to use from 'main' package"
    );
}

1;
