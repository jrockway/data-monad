package Data::Identity;
# ABSTRACT: the identity monad
use Moose;
use namespace::autoclean;

with 'Data::Monad::Cat', 'Data::Functor::Applicative::FromMonad';

has 'it' => ( is => 'ro', isa => 'Any', required => 1 );

sub pure {
    my ($class, $it) = @_;
    $class = $class->meta->name if blessed $class;
    return $class->new( it => $it );
}

sub fmap {
    my ($self, $f) = @_;
    return $self->pure($f->($self->it));
}

sub join {
    my ($self) = @_;
    return $self->it;
}

1;

__END__

=head1 DESCRIPTION

This is an example monad / functor / applicative functor.  It does
nothing.
