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

__END__

=head1 NAME

WWW::DanDomain::Auth

=head1 METHODS

=head2 new

=head2 retrieve

Parameters:

=over

=item * a hash reference, the reference can be populated with statistic
information based on the lineprocessing (L</processor>) initiated from
L</retrieve>.

=back

The method returns a scalar reference to a string containing the content
retrieved from the URL provided to the contructor (L</new>). If the
L</processor> method is overwritten you can manipulate the content prior
to being returned.

=head1 AUTHOR

Jonas B. Nielsen Cjonasbn) C<< <jonasbn@cpan.org> >>

=head1 LICENSE

=cut