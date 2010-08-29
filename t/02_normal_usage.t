#!/usr/bin/perl

package SingleUsage;

use Moose;
use MooseX::SlurpyConstructor;

has slurpy => (
    is          => 'ro',
    isa         => 'Maybe[HashRef[Str]]',
    slurpy      => 1,
);

has non_slurpy => (
    is          => 'ro',
    slurpy      => 0,
);

has other => (
    is          => 'ro',
);

has lazy_attr   => (
    is          => 'ro',
    lazy_build  => 1,
);

has predicated  => (
    is          => 'ro',
    predicate   => 'has_predicated',
);

sub _build_lazy_attr {
    "lazily_built";
}

1;

package main;

use strict;
use warnings;

use Test::More tests => 16;

# unused slurpy attribute
{
    my $no_slurpy = SingleUsage->new({
        non_slurpy  => 32,
        other       => 33,
    });
    ok( defined $no_slurpy,
        "instantiating class with no unknown attributes"
    );
    is_deeply( $no_slurpy->slurpy,
        {},
        "...slurpy attribute is empty hashref"
    );
}

# expected slurpy behaviour
{
    my $with_slurpy = SingleUsage->new({
        non_slurpy  => 1,
        other       => 2,
        unknown1    => 'a',
        unknown2    => 'b',
        unknown3    => 'c',
    });
    ok( defined $with_slurpy,
        "instantiating class with unknown attributes"
    );
    is_deeply( $with_slurpy->slurpy,
        {
            unknown1    => 'a',
            unknown2    => 'b',
            unknown3    => 'c',
        },
        "...expected value for slurpy attribute"
    );
}

# assigning to slurpy attribute
{
    my $assigning_slurpy;
    eval {
        $assigning_slurpy = SingleUsage->new({
            slurpy  => "a"
        });
    };
    like( $@,
        qr/Can't assign to 'slurpy', as it's slurpy init_arg/,
        "expected error message when trying to assign to a slurpy parameter"
    );
}

# type constraint on slurpy attributes
{
    eval {
        SingleUsage->new({
            unknown     => {},
        });
    };
    like( $@,
        qr/^Attribute \(slurpy\) does not pass the type constraint/,
        'slurpy attributes honour type constraints'
    );
}

# lazy attribute
{
    my $inst = SingleUsage->new( unknown => 12345 );

    ok( defined $inst, "class instantiation succeeded" );

    ok( ! $inst->has_lazy_attr,
        "non-instantiated lazy attribute shouldn't have predicate return true"
    );

    is( $inst->lazy_attr,
        "lazily_built",
        "lazy build does build lazily"
    );

    ok( $inst->has_lazy_attr,
        "after lazy_build, predicate on lazy attribute returns true"
    );
}

# undefined predicate
{
    my $inst = SingleUsage->new( unknown => 12345 );

    ok( defined $inst, "class instantiation succeeded" );

    ok( ! $inst->has_predicated,
        "non-instantiated predicate returns false"
    );

    ok( ! defined $inst->predicated,
        "...and attribute returns undef"
    );
}

# defined predicate
{
    my $inst = SingleUsage->new( unknown => 12345, predicated => 678 );

    ok( defined $inst, "class instantiation succeeded" );

    ok( $inst->has_predicated,
        "instantiated predicate returns true"
    );

    is( $inst->predicated,
        678,
        "...and attribute returns expected value"
    );
}
1;

