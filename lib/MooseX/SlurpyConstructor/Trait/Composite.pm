package MooseX::SlurpyConstructor::Trait::Composite;
BEGIN {
  $MooseX::SlurpyConstructor::Trait::Composite::VERSION = '1.2';
}
use Moose::Role;

around apply_params => sub {
    my $orig = shift;
    my $self = shift;

    $self->$orig(@_);

    $self = Moose::Util::MetaRole::apply_metaroles(
        for            => $self,
        role_metaroles => {
            application_to_class =>
                ['MooseX::SlurpyConstructor::Trait::ApplicationToClass'],
            application_to_role =>
                ['MooseX::SlurpyConstructor::Trait::ApplicationToRole'],
        },
    );

    return $self;
};

no Moose::Role;

1;



=pod

=head1 NAME

MooseX::SlurpyConstructor::Trait::Composite

=head1 VERSION

version 1.2

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

