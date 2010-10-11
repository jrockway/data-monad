package Data::Monad::API;
# ABSTRACT: API role for a monad
use Moose::Role;
use namespace::autoclean;

with 'Data::Functor::Applicative::API';

requires 'join';
requires 'bind';

1;
