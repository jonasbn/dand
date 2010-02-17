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

__END__

=head1 NAME

WWW::DanDomain::NoAuth

=head1 METHODS

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