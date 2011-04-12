package MooseX::SlurpyConstructor::Trait::ApplicationToClass;
BEGIN {
  $MooseX::SlurpyConstructor::Trait::ApplicationToClass::VERSION = '1.2';
}
use Moose::Role;

around apply => sub {
    my $orig  = shift;
    my $self  = shift;
    my ($role, $class) = @_;

    Moose::Util::MetaRole::apply_base_class_roles(
        for => $class,
        roles => ['MooseX::SlurpyConstructor::Role::Object'],
    );

    $class = Moose::Util::MetaRole::apply_metaroles(
        for             => $class,
        class_metaroles => {
            class => [ 'MooseX::SlurpyConstructor::Trait::Class' ],
        }
    );

    $self->$orig( $role, $class );
};

no Moose::Role;

1;



=pod

=head1 NAME

MooseX::SlurpyConstructor::Trait::ApplicationToClass

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

