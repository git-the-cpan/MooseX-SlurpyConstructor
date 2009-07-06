package MooseX::SlurpyConstructor::Role::Attribute;

use Moose::Role;

has slurpy => (
    is          => 'ro',
    isa         => 'Bool',
    default     => 0,
);

before attach_to_class => sub {
    my ( $self, $meta ) = @_;

    return if not $self->slurpy;

    my @slurpy =
      map { $_->name }
      grep { $_->slurpy }
      $meta->get_all_attributes;

    if ( scalar @slurpy ) {
        die "Can't add multiple slurpy attributes to a class";
    }
};

no Moose::Role;

1;
