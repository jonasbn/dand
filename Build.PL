# Build.PL for Spilpriser

# $Id: Build.PL 383 2009-01-08 12:39:01Z jonasbn $

use strict;
use Module::Build;

my $build = Module::Build->new(
    dist_author          => 'Jonas B. Nielsen, <jonasbn@logicLAB.dk>',
    module_name          => 'WWW::DanDomain',
    dist_version_from    => 'lib/WWW/DanDomain.pm',
    dist_abstract        => 'WWW::DanDomain',
    license              => 'perl',
    recursive_test_files => 1,
    create_readme        => 1,
	configure_requires   => {
		'Module::Build'  => '0',
	},
    build_requires       => {
        'Test::More'     => '0',
    },
    requires             => {
        'Data::Dumper'   => '0',    #Debugging
        'WWW::Mechanize' => '0',
        'Carp'           => '0',
    },
    meta_merge     => {
    	resources => {
      		homepage => 'http://www-dandomain.logicLAB.org',
      		bugtracker => 'http://rt.cpan.org/NoAuth/Bugs.html?Dist=WWW-DanDomain',
      		repository  => 'http://github.com/jonasbn/www-dandomain/tree/master',
    	}
  },

);

$build->create_build_script();

1;
