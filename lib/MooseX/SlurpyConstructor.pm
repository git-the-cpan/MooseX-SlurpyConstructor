package MooseX::SlurpyConstructor;
BEGIN {
  $MooseX::SlurpyConstructor::VERSION = '1.2';
}

use strict;
use warnings;

use Moose 0.94 ();
use Moose::Exporter;
use Moose::Util::MetaRole;
use MooseX::SlurpyConstructor::Role::Object;
use MooseX::SlurpyConstructor::Trait::Class;
use MooseX::SlurpyConstructor::Trait::Attribute;

{
    my %meta_stuff = (
        base_class_roles => ['MooseX::SlurpyConstructor::Role::Object'],
        class_metaroles => {
            class       => ['MooseX::SlurpyConstructor::Trait::Class'],
            attribute   => ['MooseX::SlurpyConstructor::Trait::Attribute'],
        },
    );

    if ( Moose->VERSION < 1.9900 ) {
        require MooseX::SlurpyConstructor::Trait::Method::Constructor;
        push @{$meta_stuff{class_metaroles}{constructor}}, 'MooseX::SlurpyConstructor::Trait::Method::Constructor';
    }
    else {
        push @{$meta_stuff{class_metaroles}{class}},
            'MooseX::SlurpyConstructor::Trait::Class';
        push @{$meta_stuff{role_metaroles}{role}},
            'MooseX::SlurpyConstructor::Trait::Role';
        push @{$meta_stuff{role_metaroles}{application_to_class}},
            'MooseX::SlurpyConstructor::Trait::ApplicationToClass';
        push @{$meta_stuff{role_metaroles}{application_to_role}},
            'MooseX::SlurpyConstructor::Trait::ApplicationToRole';
        push @{$meta_stuff{role_metaroles}{applied_attribute}},
            'MooseX::SlurpyConstructor::Trait::Attribute';
    }

    Moose::Exporter->setup_import_methods(
        %meta_stuff,
    );
}

1;

# ABSTRACT: Make your object constructor collect all unknown attributes



=pod

=head1 NAME

MooseX::SlurpyConstructor - Make your object constructor collect all unknown attributes

=head1 VERSION

version 1.2

=head1 SYNOPSIS

    package My::Class;

    use Moose;
    use MooseX::SlurpyConstructor;

    has fixed => (
        is      => 'ro',
    );

    has slurpy => (
        is      => 'ro',
        slurpy  => 1,
    );

    package main;

    ASDF->new({
        fixed => 100, unknown1 => "a", unknown2 => [ 1..3 ]
    })->dump;

    # returns:
    #   $VAR1 = bless( {
    #       'slurpy' => {
    #           'unknown2' => [
    #               1,
    #               2,
    #               3
    #           ],
    #           'unknown1' => 'a'
    #       },
    #       'fixed' => 100
    #   }, 'ASDF' );

=head1 DESCRIPTION

Including this module within Moose-based classes, and declaring an
attribute as 'slurpy' will allow capturing of all unknown constructor
arguments in the given attribute.

As of Moose 1.9900, this module can also be used in a role, in which case the
constructor of the consuming class will become slurpy.

=head1 OPTIONAL RESTRICTIONS

No additional options are added to your 'slurpy' attribute, so if you want to
make it read-only, or restrict its type constraint to a HashRef of specific
types, you should state that yourself. Typical usage may include any or all of
the options below:

    has slurpy => (
        is => 'ro',
        isa => 'HashRef',
        init_arg => undef,
        lazy => 1,
        default => sub { {} },
        traits => ['Hash'],
        handles => {
            slurpy_values => 'elements',
        },
    );

For more information on these options, see L<Moose::Manual::Attributes> and
L<Moose::Meta::Attribute::Native::Trait::Hash>.

=head1 SEE ALSO

=over 4

=item MooseX::StrictConstructor

The opposite of this module, making constructors die on unknown arguments.
If both of these are used together, StrictConstructor will always
take precedence.

This module can also be used in migrating code from vanilla Moose to
using L<MooseX::StrictConstructor>.  That was one of my original motivations
for writing it; to allow staged migration.

=back

=head1 BUGS

Please report any bugs or feature requests to
C<bug-moosex-slurpyconstructor@rt.cpan.org>, or through the web
interface at L<http://rt.cpan.org>.  The module maintainers will be notified,
and then you'll automatically be notified of progress on your bug as changes
are made.

You can also use the normal Moose support channels - see L<Moose#GETTING_HELP>.

=head1 HISTORY

This module was originally written by Mark Morgan C<< <makk384@gmail.com> >>,
with some bugfix patches by Christian Walde.

It was completely rewritten for Moose 2.0 by Karen Etheridge C<<
<ether@cpan.org> >>, drawing heavily on MooseX::StrictConstructor.

=head1 ACKNOWLEDGEMENTS

Thanks to the folks from moose mailing list and IRC channels for
helping me find my way around some of the Moose bits I didn't
know of before writing this module.

=head1 AUTHORS

=over 4

=item *

Mark Morgan <makk384@gmail.com>

=item *

Karen Etheridge <ether@cpan.org>

=back

=head1 COPYRIGHT AND LICENSE

This software is copyright (c) 2011 by Karen Etheridge.

This is free software; you can redistribute it and/or modify it under
the same terms as the Perl 5 programming language system itself.

=cut


__END__

