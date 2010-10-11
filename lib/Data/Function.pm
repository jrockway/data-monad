package Data::Function;
# ABSTRACT: helpful functions for working with functions
use strict;
use warnings;

use Sub::Exporter -setup => {
    exports => [qw/curry lambda flip id const/],
};

sub curry($$) {
    my ($code, $val) = @_;
    return sub {
        $code->($val, @_);
    }
}

sub lambda(&$;@);
sub lambda(&$;@) {
    my ($code, $cnt) = @_;
    return $code->() if $cnt < 1;
    return sub {
        my @args = @_;
        return lambda {
            $code->(@args, @_);
        } ($cnt-@args);
    }

}


sub id() {
    return lambda { my $arg = shift; $arg } 1;
}

sub flip($) {
    my $f = shift;
    return lambda {
        my ($x, $y) = @_;
        $f->($y, $x);
    } 2;
}

sub const($) {
    my $const = shift;
    return lambda { $const } 1;
}

1;

__END__

=head1 SYNOPSIS

    use Data::Function qw/lambda flip id const/;

    my $f = lambda { $_[0] - $_[1] } 2; # CODE(0x3974383) --> x - y
    my $g = $f->(42);                   # CODE(0x1234567) --> 42 - y
    $g->(1);                            # 41

    my $fprime = flip $f;       # CODE(0x8374388) --> y - x
    my $gprime = $fprime->(42); # CODE(0x1a423a2) --> y - 42
    $gprime->(43);              # 1

    my $forty_two = const 42;   # CODE(0x2938473) --> sub { my $x = shift; 42 }
    $forty_two->(1234548754);   # 42

    my $id = id;                # CODE(0x4985744)
    $id->(123);                 # 123


=head1 DESCRIPTION

This module provides a few utility functions for making functions more
Haskell-like.

=head1 EXPORTS

You must request each function that you want to use.

=head2 lambda BLOCK SCALAR

Creates an anonymous function from BLOCK.  After being applied
with SCALAR arguments, it will call the BLOCK with all the args.

=head2 flip CODEREF

Converts a 2 arg lambda into a 2 arg lambda that takes its arguments
in the opposite order.

=head2 id

Returns the identity function.

=head2 const VALUE

Returns a function of one argument that always returns VALUE.
