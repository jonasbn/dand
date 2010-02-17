package WWW::DanDomain::Super;

# $Id$

use strict;
use warnings;

use WWW::Mechanize;
use WWW::Mechanize::Cached;

our $VERSION = '0.01';

sub new {
    my ( $class, $param ) = @_;

    my $self = bless {
        url      => $param->{url},
        verbose  => $param->{verbose} || 0,
        mech     => $param->{mech},
    }, $class;

    return $self;
}

sub processor {
    my ( $self, $content ) = @_;

    return $content;
}

1;

__END__

=head1 NAME

WWW::DanDomain::Super

=head1 METHODS

=head2 new

=head2 processor

This is a stub and it might go away in the future. It does takes the content
retrieved (see: L</retrieve>) from the URL parameter provided to the constructor
(see: L</new>).

Parameters:

=over

=item * a scalar reference to a string to be processed line by line

=back

The stub does however not do anything, but it returns the scalar reference
I<untouched>.

=head1 AUTHOR

Jonas B. Nielsen Cjonasbn) C<< <jonasbn@cpan.org> >>

=head1 LICENSE

=cut