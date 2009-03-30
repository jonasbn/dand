#!/usr/bin/perl -w

use strict;
use Test::More tests => 3;

use_ok('WWW::DanDomain');

ok(my $wd = WWW::DanDomain->new());

isa_ok($wd, 'WWW::DanDomain');

