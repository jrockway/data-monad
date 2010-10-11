package Data::Functor::Applicative;
# ABSTRACT: tags a data structure as an applicative functor
use Data::Monad::Util qw(make_type_checker);
use Moose::Role;
use namespace::autoclean;

with 'Data::Functor::Applicative::API', 'Data::Functor', 'Data::Pointed';

around ap => make_type_checker('ap');

1;

__END__

=head1 DESCRIPTION

This is a role that you can consume if your data structure is an
applicative functor.  An applicative functor is a pointed functor with
the addition of an C<ap> function; function application lifted to your
functor.
