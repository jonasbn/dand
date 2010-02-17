#!/usr/bin/perl -w

# $Id$

use strict;
use warnings;
use Test::More tests => 13;
use Carp;
use Test::MockObject::Extends;
use File::Slurp qw(slurp);
use WWW::DanDomain;
use Test::Exception;
use Env qw(TEST_VERBOSE);

my $mech = Test::MockObject::Extends->new('WWW::Mechanize');
my $wd;

$mech->mock(
    'content',
    sub {
        my ( $mb, %params ) = @_;

        my $content = slurp('t/testdata')
            || croak "Unable to read file - $!";

        return $content;
    }
);
$mech->set_true('get', 'follow_link', 'submit_form');

#Auth test
my $content;

$wd = WWW::DanDomain->new({
	username => 'topshop',
	password => 'topsecret',
	url      => 'http://www.billigespil.dk/admin/edbpriser-export.asp',
    verbose  => $TEST_VERBOSE,
    mech     => $mech,
});

can_ok($wd, qw(retrieve));

ok($content = $wd->retrieve());

isa_ok($content, 'SCALAR');

is($$content, 'test');

#NoAuth test
$content = '';

$wd = WWW::DanDomain->new({
	url      => 'http://www.billigespil.dk/admin/edbpriser-export.asp',
    verbose  => $TEST_VERBOSE,
    mech     => $mech,
});

can_ok($wd, qw(retrieve));

ok($content = $wd->retrieve());

isa_ok($content, 'SCALAR');

is($$content, 'test');

#Auth fails

$mech->set_series('get', undef, undef);

$wd = WWW::DanDomain->new({
	username => 'topshop',
	password => 'topsecret',
	url      => 'http://www.billigespil.dk/admin/edbpriser-export.asp',
    verbose  => $TEST_VERBOSE,
    mech     => $mech,
});

dies_ok { $content = $wd->retrieve(); };

$mech->set_series('get', 1, undef);

$wd = WWW::DanDomain->new({
	username => 'topshop',
	password => 'topsecret',
	url      => 'http://www.billigespil.dk/admin/edbpriser-export.asp',
    verbose  => $TEST_VERBOSE,
    mech     => $mech,
});

dies_ok { $content = $wd->retrieve(); };

#Auth fails
$mech->set_series('get', undef, undef);

$wd = WWW::DanDomain->new({
	username => 'topshop',
	password => 'topsecret',
	url      => 'http://www.billigespil.dk/admin/edbpriser-export.asp',
    verbose  => $TEST_VERBOSE,
    mech     => $mech,
});

dies_ok { $content = $wd->retrieve(); };

$mech->set_series('get', 1, undef);

$wd = WWW::DanDomain->new({
	username => 'topshop',
	password => 'topsecret',
	url      => 'http://www.billigespil.dk/admin/edbpriser-export.asp',
    verbose  => $TEST_VERBOSE,
    mech     => $mech,
});

dies_ok { $content = $wd->retrieve(); };

#NoAuth fails

$mech->set_series('get', undef);

$wd = WWW::DanDomain->new({
	url      => 'http://www.billigespil.dk/admin/edbpriser-export.asp',
    verbose  => $TEST_VERBOSE,
    mech     => $mech,
});

dies_ok { $content = $wd->retrieve(); };
