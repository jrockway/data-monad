package Data::Pointed;
# ABSTRACT: tags a data structure as a pointed
use Moose::Role;
use Data::Monad::Util qw(make_type_checker);
use namespace::autoclean;

with 'Data::Pointed::API';

around 'pure' => make_type_checker('pure');

1;

__END__

=head1 DESCRIPTION

A type that can have a value lifted into it.  This is slightly
different than a functor, since there is no operation to apply
a function to the value.

Typically, you'll consume both Pointed and Functor and implement
C<join> or C<ap> to become a Monad or Applicative Functor.
