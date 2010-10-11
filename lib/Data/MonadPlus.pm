package Data::MonadPlus;
# ABSTRACT: tag a type as being a Monad with a plus and zero
use Moose::Role;
use namespace::autoclean;

with 'Data::Monad', 'Data::MonadPlus::API';

1;
