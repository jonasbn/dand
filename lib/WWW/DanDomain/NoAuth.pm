package WWW::DanDomain::NoAuth;

# $Id$

use strict;
use warnings;
use Carp qw(croak);

use base qw(WWW::DanDomain::Super);

our $VERSION = '0.01';

sub retrieve {
    my ( $self, $stat ) = @_;

    $self->{mech}->get( $self->{url} ) or croak "Unable to retrieve URL: $@";

    my $content = $self->{mech}->content();

    return $self->processor( \$content, $stat );
}

1;
