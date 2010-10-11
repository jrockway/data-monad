package Data::Monad::Util;
use strict;
use warnings;
use Sub::Exporter -setup => { exports => ['make_type_checker'] };

use Carp 'confess';
use Scalar::Util 'blessed';

sub make_type_checker {
    my ($name) = @_;
    return sub {
        my ($orig, $self, @args) = @_;
        my $result = $self->$orig(@args);
        my $type = blessed $result || '<not even an object>';
        $self = ref $self ? ref $self : $self;
        confess "The result of $name ('$result') must be a '$self', ".
            "but is actually a '$type'"
                unless blessed $result && $type->isa($self->meta->name);

        return $result;
    };
}

1;
