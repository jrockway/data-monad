package Data::Functor::Applicative::API;
# ABSTRACT: API for an applicative functor
use Moose::Role;
use namespace::autoclean;

with 'Data::Pointed::API', 'Data::Functor::API';

requires 'ap';

1;
