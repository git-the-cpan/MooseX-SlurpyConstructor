package MooseX::SlurpyConstructor::Trait::Method::Constructor;
BEGIN {
  $MooseX::SlurpyConstructor::Trait::Method::Constructor::VERSION = '1.2';
}

# applied as class_metaroles => { constructor => [ __PACKAGE__ ] }, for Moose 1.2x

use Moose::Role;

use namespace::autoclean;

use B ();

around '_generate_BUILDALL' => sub {
    my $orig = shift;
    my $self = shift;

    my $source = $self->$orig();
    $source .= ";\n" if $source;

    my @attrs = (
        '__INSTANCE__ => 1,',
        map  { B::perlstring($_) . ' => 1,' }
        grep { defined }
        map  { $_->init_arg } @{ $self->_attributes }
    );

    my $slurpy_attr = $self->associated_metaclass->slurpy_attr;

    $source .= join('',
        'my %attrs = (' . ( join ' ', @attrs ) . ');',
        'my @extra = sort grep { !$attrs{$_} } keys %{ $params };',
        'if (@extra){',

        !$slurpy_attr
            ? 'Moose->throw_error("Found extra construction arguments, but there is no \'slurpy\' attribute present!");'
            : (
                'my %slurpy_values;',
                '@slurpy_values{@extra} = @{$params}{@extra};',

                '$instance->meta->slurpy_attr->set_value( $instance, \%slurpy_values );',
            ),
        '}',
    );

    return $source;
};

1;

# ABSTRACT: A role to make immutable constructors slurpy



=pod

=head1 NAME

MooseX::SlurpyConstructor::Trait::Method::Constructor - A role to make immutable constructors slurpy

=head1 VERSION

version 1.2

=head1 DESCRIPTION

This role simply wraps C<_generate_BUILDALL()> (from
C<Moose::Meta::Method::Constructor>) so that immutable classes have a
slurpy constructor.

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

