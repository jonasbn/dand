package WWW::DanDomain;

# $Id$

use warnings;
use strict;
use Data::Dumper;
use WWW::Mechanize;
use Carp qw(croak);

our $VERSION = '0.01';

sub new {
	my ( $class, $param ) = @_;

	my $self = bless {
		base_url => 'http://www.billigespil.dk/admin',
		username => $param->{username},
		password => $param->{password},
		url      => $param->{url},
		mech     => $param->{mech} || WWW::Mechanize->new(),
		verbose  => $param->{verbose} || 0,
	}, $class;

	return $self;
}

sub retrieve {
	my ( $self, $stat ) = @_;

	$self->{mech}->get( $self->{base_url} )
		or croak "Unable to retrieve URL: $@";

	$self->{mech}->follow_link( url => $self->{base_url} );

	$self->{mech}->submit_form(
		form_number => 0,
		fields      => {
			UserName => $self->{username},
			Password => $self->{password},
		}
	);

	$self->{mech}->get( $self->{url} ) or croak "Unable to retrieve URL: $@";

	my $content = $self->{mech}->content();
	
	return $self->lineprocessor( \$content, $stat );
}

sub lineprocessor {
	my ($self, $content) = @_;
	
	return $content;
}

1;

__END__

=pod

=head1 NAME

WWW::DanDomain - class to assist in interacting with DanDomain web interface

=head1 VERSION

Version 0.01

=head1 SYNOPSIS

The module lets the user interact with DanDomains administrative interface, so
tasks of processing data exports etc. can be automated.

Perhaps a little code snippet.

	use WWW::DanDomain;

	my $foo = WWW::DanDomain->new();
	...

=head1 EXPORT

A list of functions that can be exported.  You can delete this section
if you don't export anything, such as for a purely object-oriented module.

=head1 METHODS

=head2 retrieve

=head2 new

=head2 lineprocessor

=head1 AUTHOR

jonasbn, C<< <jonasbn at cpan.org> >>

=head1 BUGS

Please report any bugs or feature requests to
C<bug-www-dandomain at rt.cpan.org>, or through the web interface at
L<http://rt.cpan.org/NoAuth/ReportBug.html?Queue=WWW-DanDomain>.
I will be notified, and then you'll automatically be notified of progress on
your bug as I make changes.

=head1 SUPPORT

You can find documentation for this module with the perldoc command.

	perldoc WWW::DanDomain

You can also look for information at:

=over 4

=item * AnnoCPAN: Annotated CPAN documentation

L<http://annocpan.org/dist/WWW-DanDomain>

=item * CPAN Ratings

L<http://cpanratings.perl.org/d/WWW-DanDomain>

=item * RT: CPAN's request tracker

L<http://rt.cpan.org/NoAuth/Bugs.html?Dist=WWW-DanDomain>

=item * Search CPAN

L<http://search.cpan.org/dist/WWW-DanDomain>

=back

=head1 ACKNOWLEDGEMENTS

=head1 COPYRIGHT & LICENSE

Copyright 2009 jonasbn, all rights reserved.

This program is free software; you can redistribute it and/or modify it
under the same terms as Perl itself.

=cut
