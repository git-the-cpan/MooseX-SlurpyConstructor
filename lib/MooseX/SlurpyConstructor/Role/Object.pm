package MooseX::SlurpyConstructor::Role::Object;

use Moose::Role;

around BUILDARGS => sub {
    my ( $orig, $class, @incoming ) = @_;

    my $args;
    if ( scalar @incoming == 1 and ref $incoming[ 0 ] eq 'HASH' ) {
        $args = shift @incoming;
    } else {
        $args = { @incoming };
    }

    my @init_args =
      grep { defined }
      map { $_->init_arg }
      $class->meta->get_all_attributes;

    my %slurpy_args = %$args;

    delete @slurpy_args{ @init_args };

    my %init_args = map { $_ => $args->{ $_ } } @init_args;

    my @slurpy_attrs =
      map { $_->name }
      grep { $_->slurpy }
      $class->meta->get_all_attributes;

    my $slurpy_attr = shift @slurpy_attrs;
    if ( not defined $slurpy_attr ) {
        die "No parameters marked 'slurpy', do you need this module?";
    }

    if ( defined $init_args{ $slurpy_attr } ) {
        die "Can't assign to '$slurpy_attr', as it's marked slurpy";
    }

    return $class->$orig({
        %init_args,
        $slurpy_attr    => \%slurpy_args,
    });
};

no Moose::Role;

1;
