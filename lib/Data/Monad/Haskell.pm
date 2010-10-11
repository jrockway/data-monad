package Data::Monad::Haskell;
# ABSTRACT: create a Data::Monad monad from return and bind
use Moose::Role;
use Data::Function qw(id);
use namespace::autoclean;

with 'Data::Monad';

requires 'pure';
requires 'bind';

sub fmap {
    my ($self, $f) = @_;
    $self->bind(sub {
        my $k = shift;
        return $self->pure($f->($k));
    });
}

sub join {
    my ($self) = @_;
    $self->bind(id);
}

1;

__END__

=head1 DESCRIPTION

Build C<fmap> and C<join> from C<pure> (C<return>) and C<bind>.  This
is how Haskell programmers typically define a monad.
