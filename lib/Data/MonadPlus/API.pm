package Data::MonadPlus::API;
# ABSTRACT: API for MonadPlus
use Moose::Role;
use namespace::autoclean;

with 'Data::Monad::API';

requires 'zero';
requires 'plus';

1;
