use strict;
use warnings;
use Test::More;

use Data::Function qw/curry lambda id flip const/;

{
    my $add  = sub { $_[0] + $_[1] };
    my $add1 = curry $add, 1;
    is $add1->(2), 3, 'currying works';

    my $three = curry $add1, 2;
    is ref $three, 'CODE', 'is still a coderef';
    is $three->(), 3, 'currying twice works';
}

my $nullary = lambda { 42 } 0;
is $nullary, 42, '0-ary function is a value';

my $add42 = lambda { 42 + $_[0] } 1;
is ref $add42, 'CODE', '1-ary function is a coderef';

my $fortythree = $add42->(1);
is $fortythree, 43, 'applying 1 to add42 == 43';

my $f = lambda { $_[0] - $_[1] } 2;
is ref $f, 'CODE', 'f is code';
my $g = $f->(42);
is ref $g, 'CODE', 'g is code';
my $r = $g->(1);
is $r, 41, 'and now it is evaulated';

is $g->(42), 0, 'g was reused OK';
my $g2 = $f->(1);
is ref $g2, 'CODE', 'f reused into g2';
is $g2->(42), -41, 'g2 used ok';

is(flip($f)->(42)->(1), -41, 'flip works');

is ref (const 42), 'CODE', 'const returns a coderef';
is((const 42)->(123), 42, 'const works');

is ref id, 'CODE', 'id returns a coderef';
is(id->(42), 42, 'id works');

done_testing;
