use strict;
use warnings;
use Test::More;
use Test::Exception;

use Data::Function qw/lambda/;
use ok 'Data::Identity';

my $id;
lives_ok {
    $id = Data::Identity->pure(42);
} 'did not die';
ok $id, 'got something';
isa_ok $id, 'Data::Identity';
is $id->it, 42, 'got wrapped value';

my $result;
lives_ok {
    $result = Data::Identity->pure(42)->fmap(sub { $_[0] - 42 });
} '(fmap . pure) lives ok';

is $result->it, 0, 'got correct result';

lives_ok {
    $result = Data::Identity->pure($id);
} 'id can hold an id';

lives_ok {
    $result = $result->join;
} 'result can join';

isa_ok $result, 'Data::Identity';

is $result->it, 42, 'got thing back';

my $new = Data::Identity->pure(42);

throws_ok {
    $new->bind(sub { $_[0] - 42 });
} qr/must be a 'Data::Identity'/,
    'dies when bound function returns the wrong thing';

lives_ok {
    $result = $new->bind(sub { Data::Identity->pure($_[0] - 42) });
} 'bind works';

is $result->it, 0, 'bind works';

lives_ok {
    $result =
        Data::Identity->pure(lambda { $_[0] - $_[1] } 2)->ap(
            Data::Identity->pure(42),
        )->ap(
            Data::Identity->pure(1),
        );
} '"xpure (-) `ap` pure 42 `ap` pure 1" lives';

is $result->it, 41, 'and is == 41';

done_testing;
