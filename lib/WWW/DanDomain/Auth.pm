package WWW::DanDomain::Auth;

# $Id$

use strict;
use warnings;
use Carp qw(croak);

use base qw(WWW::DanDomain::Super);

our $VERSION = '0.01';

sub new {
    my ($class, $param) = @_;
    
    my $self = $class->SUPER::new($param);
    
    $self->{base_url} = 'http://www.billigespil.dk/admin';
    $self->{username} = $param->{username};
    $self->{password} = $param->{password};
    
    return $self;
}

sub retrieve {
    my ( $self, $stat ) = @_;

    $self->{mech}->get( $self->{base_url} )
        or croak "Unable to retrieve base URL: $@";

    $self->{mech}->submit_form(
        form_number => 0,
        fields      => {
            UserName => $self->{username},
            Password => $self->{password},
        }
    );

    $self->{mech}->get( $self->{url} ) or croak "Unable to retrieve URL: $@";

    my $content = $self->{mech}->content();

    return $self->processor( \$content, $stat );
}

1;
