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
		mech     => $param->{mech} || WWW::Mechanize->new(
			agent => 'WWW::DanDomain 0.01'
		),
		verbose  => $param->{verbose} || 0,
	}, $class;

	return $self;
}

sub retrieve {
	my ( $self, $stat ) = @_;

	$self->{mech}->get( $self->{base_url} )
		or croak "Unable to retrieve URL: $@";

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

WWW::DanDomain - class to assist in interacting with DanDomain admin interface

=head1 VERSION

Version 0.01

=head1 SYNOPSIS

The module lets the user interact with DanDomains administrative interface, so
tasks of processing data exports etc. can be automated.

Perhaps a little code snippet.

	use WWW::DanDomain;

	#All mandatory parameters
	my $wd = WWW::DanDomain->new({
		username => 'topshop',
		password => 'topsecret',
		url      =>
	});


	#with verbosity enabled
	my $wd = WWW::DanDomain->new({
		username => 'topshop',
		password => 'topsecret',
		url      =>
		verbose  => 1,
	});


	#With custom WWW::Mechanize object
	use WWW::Mechanize;

	my $mech = WWW::Mechanize->new(agent => 'MEGAnice bot');

	my $wd = WWW::DanDomain->new({
		username => 'topshop',
		password => 'topsecret',
		url      => $mech,
	});
	
	
	#The intended use
	package My::WWW::DanDomain::Subclass;
	
	sub lineprocessor {
		my ( $self, $content ) = @_;
		
		#Note the lines terminations are Windows CRLF
		my @lines = split /\r\n/, $$content;
		
		...
		
		}
	}
	
	
	#Using your new class
	my $my = My::WWW::DanDomain::Subclass->new({
		username => 'topshop',
		password => 'topsecret',
		url      => 	
	});
	
	my $content = $my->retrieve();
	
	print $$content;
	
	
=head1 METHODS

=head2 new

Parameters:

=over

=item * username, the username to access DanDomain 

=item * password, the password to access DanDomain

=item * url, the URL to retrieve data from (L</retrieve>)

=item * mech, a L<WWW::Mechanize> object if you have a pre instantiated object.
The parameter is optional.

=item * verbose, a flag for indicating verbosity, default is 0 (disabled), the
parameter is optional

=back

=head2 retrieve

Parameters:

=over

=item * a hash reference, the reference can be populated with statistic
information based on the lineprocessing (L</lineprocessor>) initiated from
L</retrieve>.

=back

The method returns a scalar reference to a string containing the content
retrieved from the URL provided to the contructor (L</new>). If the
L<lineprocessor> method is overwritten you can manipulate the content prior
to being returned.

=head2 lineprocessor

This is a stub and it might go away in the future. It does takes the content
retrieved (see: L</retrieve>) from the URL parameter provided to the constructor
(see: L</new>).

Parameters:

=over

=item * a scalar reference to a string to be processed line by line

=back

The stud does however not do anything, but it returns the scalar reference
I<untouched>.

=head1 AUTHOR

=over

=item * jonasbn, C<< <jonasbn at cpan.org> >>

=back

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

=over

=item * Andy Lester (petdance) the author L<WWW::Mechanize>, this module makes
easy things easy and hard things possible.

=back

=head1 COPYRIGHT & LICENSE

Copyright 2009 jonasbn, all rights reserved.

This program is free software; you can redistribute it and/or modify it
under the same terms as Perl itself.

=cut
