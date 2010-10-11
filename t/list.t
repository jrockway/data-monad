use strict;
use warnings;
use Test::More;

use Data::Function qw(lambda);

use ok 'Data::List';

is_deeply(
    Data::List->new( list => [1..10] )->fmap(sub { $_[0] + 1 })->list,
    [2..11],
    '(+1) <$> [1..10] works',
);

is_deeply(
    Data::List->pure( lambda { $_[0] - $_[1] } 2 )->ap(
        Data::List->pure(1),
    )->ap(
        Data::List->new(list => [1..10]),
    )->list,
    [0,-1,-2,-3,-4,-5,-6,-7,-8,-9],
    'pure (-) <*> [1] <*> [1..10] works',
);

is_deeply(
    Data::List->new( list => [1..3] )->fmap( lambda { $_[0] + $_[1] } 2 )->ap(
        Data::List->new( list => [10..12] ),
    )->list,
    [11, 12, 13, 12, 13, 14, 13, 14, 15],
    '(+) <$> [1..3] <*> [10..12] works',
);

is_deeply(
    Data::List->new( list => [1..3] )->bind( sub {
        my $x = shift;
        Data::List->new( list => [4..6] )->bind( sub {
            my $y = shift;
            return Data::List->new( list => [$x * $y, $x + $y] );
        });
    })->list,
    [4,5,5,6,6,7,8,6,10,7,12,8,12,7,15,8,18,9],
    '[1..3] >>= \x -> [4..6] >>= \y -> [x * y, x + y] works',
);


done_testing;
