package Data::List;
# ABSTRACT: The Haskell-style List monad
use Moose;
use namespace::autoclean;

with 'Data::Monad::Cat', 'Data::Functor::Applicative::FromMonad';

has 'list' => (
    is       => 'ro',
    isa      => 'ArrayRef',
    required => 1,
);

sub pure {
    my ($class, $value) = @_;
    $class = $class->meta->name if blessed $class;
    return $class->new( list => [$value] );
}

sub fmap {
    my ($self, $f) = @_;
    return $self->meta->name->new(
        list => [ map { $f->($_) } @{$self->list} ],
    );
}

sub join {
    my ($self) = @_;
    return $self->meta->name->new(
        list => [ map { @{$_->list} } @{$self->list} ],
    );
}

1;

__END__

=head1 DESCRIPTION

The List monad represents a computation strategy where each
computation may return zero or more results.

=head1 SEE ALSO

L<Data::Functor>

L<Data::Functor::Applicative>

L<Data::Monad>
