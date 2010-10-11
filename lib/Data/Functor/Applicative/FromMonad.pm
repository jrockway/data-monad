package Data::Functor::Applicative::FromMonad;
# ABSTRACT: make a monad an applicative functor
use Moose::Role;
use namespace::autoclean;

with 'Data::Monad';

requires 'bind';
requires 'pure';

sub ap {
    my ($self, $other) = @_;
    return $self->bind(sub {
        my $f = shift;
        return $other->bind(sub {
            my $x = shift;
            return $self->pure($f->($x));
        });
    });
}

1;

__END__

=head1 DESCRIPTION

Consume this role to make a L<Data::Monad|Data::Monad> monad into an
applicative functor.  It uses C<pure> and C<bind> to create C<ap>.
