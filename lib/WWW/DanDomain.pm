package WWW::DanDomain;

# $Id$

use warnings;
use strict;
use WWW::Mechanize;
use WWW::Mechanize::Cached;
use Carp qw(croak);
use Class::Rebless;

use WWW::DanDomain::Auth;
use WWW::DanDomain::NoAuth;

our $VERSION = '1.00';

sub new {
    my ( $class, $param ) = @_;

    my $mech;
    my $agent = __PACKAGE__ . "-$VERSION";
    if ( $param->{mech} ) {
        $mech = $param->{mech};
    } elsif ( $param->{cache} ) {
        $mech = WWW::Mechanize::Cached->new( agent => $agent );
    } else {
        $mech = WWW::Mechanize->new( agent => $agent );
    }
    $param->{mech} = $mech;
    
    my $self;
    
    if ($param->{username} || $param->{password}) {
        if ((not $param->{username}) or (not $param->{password})) {
            croak 'Both username and password is required for authentication';
        }        
        $self = WWW::DanDomain::Auth->new($param);
        
    } else {
        $self = WWW::DanDomain::NoAuth->new($param);
    }

    if ($class !~ m/^WWW::DanDomain((?=::(NoAuth|Auth))|$)/) {
        Class::Rebless->rebless($self, $class);
    }

    return $self;
}

1;

__END__

=pod

=head1 NAME

WWW::DanDomain - factory for interacting with DanDomain admin interface

=head1 VERSION

This documentation describes version 1.00

=head1 SYNOPSIS

The module lets the user interact with DanDomains administrative web interface.
This can be used for automating tasks of processing data exports etc.

    use WWW::DanDomain;

    #All mandatory parameters
    my $wd = WWW::DanDomain->new({
        username => 'topshop',
        password => 'topsecret',
        url      => 'http://www.billigespil.dk/admin/edbpriser-export.asp',
    });


    #with verbosity enabled
    my $wd = WWW::DanDomain->new({
        username => 'topshop',
        password => 'topsecret',
        url      => 'http://www.billigespil.dk/admin/edbpriser-export.asp',
        verbose  => 1,
    });

    #With caching
    my $wd = WWW::DanDomain->new({
        username => 'topshop',
        password => 'topsecret',
        url      => 'http://www.billigespil.dk/admin/edbpriser-export.asp',
        cache    => 1,
    });


    #With custom WWW::Mechanize object
    use WWW::Mechanize;

    my $mech = WWW::Mechanize->new(agent => 'MEGAnice bot');

    my $wd = WWW::DanDomain->new({
        username => 'topshop',
        password => 'topsecret',
        url      => 'http://www.billigespil.dk/admin/edbpriser-export.asp',
        mech     => $mech,
    });
    
    
    #The intended use
    package My::WWW::DanDomain::Subclass;
    
    sub processor {
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
        url      => 'http://www.billigespil.dk/admin/edbpriser-export.asp',
    });
    
    my $content = $my->retrieve();
    
    print $$content;

=head1 DESCRIPTION

This class is a factory for creating objects, which can interact with DanDomain's
administrive web interface. It is basically just simple wrappers around
L<WWW::Mechanize> it assists the user in getting going with automating tasks
related to the DanDomain administrative web interface.

Such as:

=over

=item * manipulating data exports (removing, adjusting, calculating, adding
columns)

=item * filling in missing data (combining data)

=item * converting formats (from CSV to XML / JSON / CSV and what not)

=back

=head1 METHODS

=head2 new

This is the constructor/factory.

The constructor takes a hash reference as input. The hash reference should
contain parameters satisfying the required parameters for the object you want
the factory to create.

For both products of the factory:

=over

=item L<WWW::DanDomain::Auth>

=item L<WWW::DanDomain:.NoAuth>

=back

The following parameters are available:

=over

=item * url, the mandatory URL to retrieve data from (L</retrieve>)

=item * mech, a L<WWW::Mechanize> object if you have a pre instantiated object
or some other object implementing the the same API as L<WWW::Mechanize>.

The parameter is optional. 

See also cache parameter below for an example.

=item * verbose, a flag for indicating verbosity, default is 0 (disabled), the
parameter is optional

=item * cache, usage of a cache meaning that we internally use
L<WWW::Mechanize::Cached> instead of L<WWW::Mechanize>.

The parameter is optional

=back

For L<WWW::DanDomain::NoAuth> the following additional parameters are required:

=over

=item * username, the mandatory username to access DanDomain 

=item * password, the mandatory password to access DanDomain

=back

If these parameters are present, a L<WWW::DanDomain::Auth> object is returned.
Both have to be present, if only one of them is present the construction of the
object dies.

If none of the above parameters are present a L<WWW::DanDomain::NoAuth> object
is returned.

This is the barebones logic of the factory, encapsulation of the actual
construction.

=head1 DIAGNOSTICS

=over

=item * Both username and password is required for authentication

If you want the factory to provide a L<WWW::DanDomain::Auth> object you have to
provide both B<username> and B<password>.

=item * Unable to retrieve base URL: $@

The base URL provided to retrieve gives an error.

Please see: L<http://search.cpan.org/perldoc?HTTP%3A%3AResponse> or
L<http://search.cpan.org/~gaas/libwww-perl/lib/HTTP/Status.pm>

Test the URL in your browser to investigate.

=item * Unable to retrieve URL: $@

The base URL provided to retrieve gives an error.

Please see: L<http://search.cpan.org/perldoc?HTTP%3A%3AResponse> or
L<http://search.cpan.org/~gaas/libwww-perl/lib/HTTP/Status.pm>

Test the URL in your browser to investigate.

=back

=head1 CONFIGURATION AND ENVIRONMENT

The module requires Internet access to make sense and an account with DanDomain
with username and password is required.

=head1 DEPENDENCIES

=over

=item * L<WWW::Mechanize>

=item * L<Carp>

=back

=head1 TEST AND QUALITY

The tests are based on L<Test::MockObject::Extends> and example data are
mocked dummy data. Please see the L</TODO> section.

The test suite uses the following environment variables as flags:

=over

=item TEST_AUTHOR, to test prerequisites, using L<Test::Prereq>

=item TEST_CRITIC, to do a static analysis of the code, using L<Perl::Critic>,
see also QUALITY AND CODING STANDARD

=back

=head2 TEST COVERAGE

The following data are based on an analysis created using L<Devel::Cover> and
the distributions own test suite, instantiated the following way.

    % ./Build testcover --verbose

---------------------------- ------ ------ ------ ------ ------ ------ ------
File                           stmt   bran   cond    sub    pod   time  total
---------------------------- ------ ------ ------ ------ ------ ------ ------
blib/lib/WWW/DanDomain.pm      97.4   87.5   50.0  100.0  100.0   32.0   92.1
...lib/WWW/DanDomain/Auth.pm  100.0  100.0    n/a  100.0  100.0   41.1  100.0
...b/WWW/DanDomain/NoAuth.pm  100.0  100.0    n/a  100.0  100.0   17.5  100.0
...ib/WWW/DanDomain/Super.pm  100.0    n/a  100.0  100.0  100.0    9.4  100.0
Total                          99.0   92.9   62.5  100.0  100.0  100.0   96.7
---------------------------- ------ ------ ------ ------ ------ ------ ------

The data are based on version: 1.00

=head1 QUALITY AND CODING STANDARD

The code passes L<Perl::Critic> tests a severity: 1 (brutal)

The following policies have been disabled:

=over

=item L<Perl::Critic::Policy::InputOutput::RequireBracedFileHandleWithPrint>

=back

L<Perl::Critic> resource file, can be located in the t/ directory of the
distribution F<t/perlcriticrc>

L<Perl::Tidy> resource file, can be obtained from the original author

=head1 BUGS AND LIMITATIONS

No known bugs at this time.

From version 1.00 and onwards the objects returned from the constructor  (L<WWW::DanDomain/new>) are not of the class: L<WWW::DanDomain>, they are either
of the classes:

=over

=item * L<WWW::DanDomain::Auth>

=item * L<WWW::DanDomain::NoAuth>

=back

Depending on the parameters provided, please see L</new> for details. Apart from
the type returned methods and parameters are kept intact.

It was considered to do a rebless (See: L<Class::Rebless/rebless>) so the original
type was kept intact, but with the factory then also acting as SUPER class sounding
like a bad idea and it was skipped again.

=head1 BUG REPORTING

Please report any bugs or feature requests via:

=over

=item * email: C<bug-www-dandomain at rt.cpan.org>

=item * HTTP: L<http://rt.cpan.org/NoAuth/ReportBug.html?Queue=WWW-DanDomain>

=back

=head1 DEVELOPMENT

=over

=item * Subversion repository: L<http://logicLAB.jira.com/svn/DAND>

=back

=head1 TODO

=over

=item * Most of the work is done in the classes inheriting from this class,
there could however be work to do in the maintenance area, making this class
more informative when/if failing

=item * I would like to add some integration test scripts so I can see that the
package works with real data apart from the mock.

=back

=head1 SEE ALSO

=over

=item * L<http://www.dandomain.dk>

=item * L<http://search.cpan.org/~gaas/libwww-perl/lib/HTTP/Status.pm>

=item * L<http://search.cpan.org/perldoc?HTTP%3A%3AResponse>

=item * L<http://www.logicLAB.org>

=back

=head1 SUPPORT

You can find documentation for this module with the perldoc command.

    perldoc WWW::DanDomain

You can also look for information at:

=over 4

=item * Official Wiki

L<http://logiclab.jira.com/wiki/display/DAND/Home+-+WWW-DanDomain>

=item * AnnoCPAN: Annotated CPAN documentation

L<http://annocpan.org/dist/WWW-DanDomain>

=item * CPAN Ratings

L<http://cpanratings.perl.org/d/WWW-DanDomain>

=item * RT: CPAN's request tracker

L<http://rt.cpan.org/NoAuth/Bugs.html?Dist=WWW-DanDomain>

=item * Search CPAN

L<http://search.cpan.org/dist/WWW-DanDomain>

=back

=head1 AUTHOR

=over

=item * jonasbn, C<< <jonasbn at cpan.org> >>

=back

=head1 MOTIVATION

This module grew out of a small script using L<WWW::Mechanize> to fetch some
data from a website and changing it to satisfy the client utilizing the data.

More a more scripts where based on the original script giving a lot of redundant
code. Finally I refactored the lot to use some common code base.

After some time I refactored to an object oriented structure making it even
easier to maintain and adding more clients. This made the actual connectivity
into a package (this package) letting it loose as open source.

The system in which L<WWW::DanDomain> plays a small, but important part is
constantly evolving and new features keep defining, so the OOP aspect showed
to be a good strategy, major changes have however meant that it has been
necessary to make some major leaps, introducing factors, which could prove
to break backwards compatibility - but the most important aspect is to solve
the task at hand.

=head1 ACKNOWLEDGEMENTS

=over

=item * Andy Lester (petdance) the author of L<WWW::Mechanize> and
L<WWW::Mechanize:Cached>, this module makes easy things easy and hard things
possible

=item * Steen Schnack, understanding the power and flexibility of computer
programming and custom solutions and who gave me the assignment in the first
place

=back

=head1 LICENSE AND COPYRIGHT

Copyright 2009-2010 jonasbn, all rights reserved.

This program is free software; you can redistribute it and/or modify it
under the same terms as Perl itself.

=cut
