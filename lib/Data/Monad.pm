package Data::Monad;
# ABSTRACT: tags a data structure as a monad
use Data::Monad::Util qw(make_type_checker);
use Moose::Util qw(does_role);
use Moose::Role;
use namespace::autoclean;

with 'Data::Monad::API', 'Data::Functor::Applicative';

around join => make_type_checker('join');
around bind => make_type_checker('bind');

1;

__END__

=head1 DESCRIPTION

Consume this role if your type can act as a monad.

=head1 METHODS

=head2 pure VALUE

Lift a value into the monad

=head2 fmap FUNCTION

Apply a function inside the monad

=head2 join

Remove one level of nesting

=head2 bind FUNCTION

Apply the value inside the monad to FUNCTION, returning a monad.

=head2 ap

Lifted function application
