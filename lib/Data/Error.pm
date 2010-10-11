package Data::Error;
# ABSTRACT: Haskell-style Error Monad
use Moose;
use MooseX::Aliases;

with 'MooseX::Traits',
    'Data::MonadPlus', 'Data::Monad::Cat', 'Data::Functor::Applicative::FromMonad';

use Try::Tiny ();
use namespace::autoclean -also => [qw/assert_my_type/];

sub assert_my_type($) {
    my $thingie = shift;
    confess "'$thingie' is not a Data::Error type"
        unless blessed $thingie && $thingie->isa('Data::Error');
}

has 'result' => (
    is        => 'ro',
    isa       => 'Any',
    predicate => 'has_result',
    alias     => 'right', # for the Haskell programmers
);

alias 'is_success' => 'has_result';
alias 'is_right' => 'has_result';

has 'error' => (
    is        => 'ro',
    isa       => 'Any',
    predicate => 'has_error',
    alias     => 'left', # clearly the Error monad is a right-wing conspiracy
);

alias 'is_error' => 'has_error';
alias 'is_left'  => 'has_error';

sub BUILD {
    my $self = shift;
    confess
        q{you must construct a Data::Error object with either a `result' }.
        q{or an `error`!}
            if !$self->has_result && !$self->has_error;
}

# Error is a monadplus

sub pure {
    my ($class, $value) = @_;
    $class = ref $class ? $class->meta->name : $class;
    return $class->new( result => $value );
}

sub zero {
    my ($class, $value) = @_;
    $class = ref $class ? $class->meta->name : $class;
    return $class->new( error => $value );
}

sub fmap {
    my ($self, $f) = @_;
    return $self if $self->has_error;
    return $self->pure($f->($self->result));
}

sub join {
    my ($self) = @_;
    return $self if $self->has_error;
    return $self->result;
}

sub plus {
    my ($self, $x) = @_;
    return $self if $self->has_result;
    return $x;
}

# now the functions that make Error interesting

sub assert_success {
    my $self = shift;
    die $self->error if $self->has_error;
    return $self->result;
}

alias 'throw' => 'assert_success';

sub try {
    my ($self, $code) = @_;
    return
        Try::Tiny::try {
            my $result = $code->();
            return $self->pure($result);
        } Try::Tiny::catch {
            return $self->zero($_);
        };
}

sub catch {
    my ($self, $on_error) = @_;
    assert_my_type $on_error;

    return $self if $self->has_result;
    return $on_error;
}

1;

__END__

=head1 SYNOPSIS

Represent failure:

    my $failure = Data::Error->new( error  => 'I HAZ LET GO' );

And success:

    my $success = Data::Error->new( result => 42 );

Determine which you had:

    $failure->has_error;  # true
    $failure->is_error;   # true
    $failure->is_left;    # true
    $failure->has_result; # false
    $failure->is_success; # false
    $failure->is_right;   # false

    $success->has_error;  # false
    $success->is_error;   # false
    $success->is_left;    # false
    $success->has_result; # true
    $success->is_success; # true
    $success->is_right;   # true

Chain computations:

    my $result = Data::Error->try(sub { ... })->catch(
        Data::Error->new( result => 'ALL BETTER NOW' ),
    );
    $result->is_success; # true; ... if ... didn't die, ALL BETTER NOW otherwise.

    Data::Error->try( sub { 42 / $divisor } )->bind(
        my $result_if_success = shift;
        Data::Error->pure( int $result_if_sucess );
    );

    # failure if divisor is 0, int (42/divisor) otherwise

=head1 DESCRIPTION

Error represents the results of computations that can succeed or fail.
Normally you'd use exceptions for this, but sometimes you want to pass
the result around, like in an event-driven program.  This data
structure lets you do that.

To make the Haskell programmers happy, it's a monad and applicative
functor, and it you can use right/left instead of result/error.

=head1 SEE ALSO

L<Data::MonadPlus>

L<Data::Monad>

L<Data::Functor>

L<Data::Functor::Applicative>
