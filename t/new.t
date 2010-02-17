#!/usr/bin/perl -w

use strict;
use Test::More tests => 8;

use_ok('WWW::DanDomain');

my $wd;

ok($wd = WWW::DanDomain->new());

isa_ok($wd, 'WWW::DanDomain::NoAuth');

ok($wd = WWW::DanDomain->new({cache => 1}));

my $mech = WWW::Mechanize->new();

ok($wd = WWW::DanDomain->new({mech => $mech}));

ok($wd = WWW::DanDomain->new({verbose => 1}));

ok($wd = WWW::DanDomain->new({ username => 'dummy', password => 'dummy' }));

isa_ok($wd, 'WWW::DanDomain::Auth');
