package Data::Functor;
# ABSTRACT: tags a data structure as a functor
use Moose::Role;
use Data::Monad::Util qw(make_type_checker);
use namespace::autoclean;

with 'Data::Functor::API';

around fmap => make_type_checker('fmap');

1;

__END__

=head1 DESCRIPTION

Consume this role to allow your data structure to work as a functor.
A functor is a container type that allows function application to be
lifted into the container with a function called C<fmap>.

A list is a functor, with C<map> as its C<fmap> operation.

=head1 METHODS

=head2 fmap FUNCTION

Apply the value inside the functor to FUNCTION, returning a new value
inside the functor.
