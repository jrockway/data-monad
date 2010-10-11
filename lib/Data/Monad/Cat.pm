package Data::Monad::Cat;
# ABSTRACT: make a Data::Monad from a pure/fmap/join triple
use Moose::Role;
use namespace::autoclean;

with 'Data::Monad';

requires 'pure';
requires 'fmap';
requires 'join';

sub bind {
    my ($k, $f) = @_;
    return $k->fmap($f)->join;
}

1;

__END__

=head1 DESCRIPTION

Consume this role to make C<bind> from C<pure>, C<fmap>, and C<join>.

(The "Cat" in the name means, "make a monad from its I<cat>egory
theory definition".)
