use strict;
use warnings;
use Test::More;
use Test::Exception;

{ package Bad;
  use Moose;
  with 'Data::Monad';

  sub pure { 'oh noes' };
  sub fmap { 'oh noes' };
  sub ap   { 'oh noes' };
  sub join { 'oh noes' };
  sub bind { 'oh noes' };
}

throws_ok {
    Bad->pure(123);
} qr/the result of pure \('oh noes'\) must be a 'Bad', but is actually a '<not even an object>'/i, 'bad pure threw error';

throws_ok {
    Bad->new->fmap(sub {})
} qr/the result of fmap \('oh noes'\) must be a 'Bad', but is actually a '<not even an object>'/i, 'bad fmap threw error';

throws_ok {
    Bad->new->join
} qr/the result of join \('oh noes'\) must be a 'Bad', but is actually a '<not even an object>'/i, 'bad join threw error';

throws_ok {
    Bad->new->bind(sub {})
} qr/the result of bind \('oh noes'\) must be a 'Bad', but is actually a '<not even an object>'/i, 'bad bind threw error';

throws_ok {
    Bad->new->ap(Bad->new)
} qr/the result of ap \('oh noes'\) must be a 'Bad', but is actually a '<not even an object>'/i, 'bad ap threw error';

done_testing;
