#!/usr/bin/perl -w

# $Id$

use strict;
use warnings;
use Test::More tests => 4;
use Carp;
use Test::MockObject::Extends;
use File::Slurp qw(slurp);
use WWW::DanDomain;

my $mech = Test::MockObject::Extends->new('WWW::Mechanize');

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

my $content;

my $wd = WWW::DanDomain->new({
	username => 'topshop',
	password => 'topsecret',
	url      => 'http://www.billigespil.dk/admin/edbpriser-export.asp',
    verbose  => 1,
    mech     => $mech,
});

can_ok($wd, qw(retrieve));

ok($content = $wd->retrieve());

isa_ok($content, 'SCALAR');

is($$content, 'test');
