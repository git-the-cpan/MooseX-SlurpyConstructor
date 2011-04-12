package MooseX::SlurpyConstructor::Trait::Role;
BEGIN {
  $MooseX::SlurpyConstructor::Trait::Role::VERSION = '1.2';
}

use Moose::Role;

sub composition_class_roles { 'MooseX::SlurpyConstructor::Trait::Composite' }

no Moose::Role;

1;



=pod

=head1 NAME

MooseX::SlurpyConstructor::Trait::Role

=head1 VERSION

version 1.2

=for Pod::Coverage composition_class_roles

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
