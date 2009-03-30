# Build.PL for Spilpriser

# $Id: Build.PL 383 2009-01-08 12:39:01Z jonasbn $

use strict;
use Module::Build;

my $build = Module::Build->new(
    dist_author          => 'Jonas B. Nielsen, <jonasbn@logicLAB.dk>',
    module_name          => 'WWW::DanDomain',
    dist_version_from    => 'lib/WWW/DanDomain.pm',
    dist_abstract        => 'WWW::DanDomain',
    license              => 'restrictive',
    recursive_test_files => 1,
    create_readme        => 1,
    requires             => {
        'Data::Dumper'   => '0',    #Debugging
        'Test::More'     => '0',
        'WWW::Mechanize' => '0',
        'Carp'           => '0',
    },
);

$build->create_build_script();

1;
