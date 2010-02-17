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

    if ( $self->{verbose} ) {
        print STDERR "${$content}.\n";
    }

    return $content;
}

1;

__END__

=head1 NAME

WWW::DanDomain::Super

=head1 METHODS

=head2 processor

=head2 new

=head1 AUTHOR

Jonas B. Nielsen Cjonasbn) C<< <jonasbn@cpan.org> >>

=head1 LICENSE

=cut