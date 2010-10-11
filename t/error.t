use strict;
use warnings;
use Test::More;
use Test::Exception;

use ok 'Data::Error';

ok(Data::Error->new( left => 42 )->is_error, 'left is error');
ok(Data::Error->new( result => 42)->is_right, 'result is right');

ok(Data::Error->zero->is_error, 'zero is error');
ok(Data::Error->pure(42)->is_success, 'pure is success');

my $left  = Data::Error->new( left  => 'something bad' );
my $right = Data::Error->new( right => 42 );

is $right->fmap(sub { $_[0] + 1 })->result, 43, 'fmap works on rights';
my $executed = 0;
is $left->fmap(sub { $executed = 1; $_[0] + 1 })->error, 'something bad',
    'fmap works on lefts';
ok !$executed, 'fmap(left) immediately returns';

is $left->join->error, $left->error, 'join left = left';
is(Data::Error->new( right => $right )->join->result, $right->result,
   'join right(right2) == right2');

ok $left->plus($left)->is_error, 'left + left == left';
is $left->plus($right)->result, $right->result, 'left + right = right';
is $right->plus($left)->result, $right->result, 'right + left = right';
ok $left->plus($left)->plus($left)->is_error,
    "two wrongs don't make a right, but three lefts do... n't either";

is(Data::Error->try(sub { die 'OH NOES' })->catch(Data::Error->pure(0))->result,
   0, 'try { fail } catch { Right 0 } == Right 0');

like(Data::Error->try(sub { die 'OH NOES' })->error, qr/OH NOES/);

is(Data::Error->try(sub { 42 })->result, 42);

my $result = Data::Error->try(sub { 0 })->bind( sub {
    my $x = shift;
    return Data::Error->try( sub { 42 / $x } );
});

ok $result->is_error;
like $result->error, qr/zero/, 'div by zero caught';

throws_ok {
    $left->throw;
} qr/something bad/, 'throw left = exception';

lives_ok {
    $right->throw;
} 'throw right = lives';


done_testing;
