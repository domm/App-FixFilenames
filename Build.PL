use strict;
use warnings;
use Module::Build;
use 5.010;

my $builder = Module::Build->new(
    module_name       => 'App-FixFilenames',
    license           => 'perl',
    dist_author       => 'Thomas Klausner',
    dist_version_from => 'lib/App/FixFilenames.pm',
    build_requires    => {
        'Test::More'       => 0,
    },
    requires => {
        'perl'             => '5.010',
        'App::Cmd'         => '0.202',
    },
    script_files=>[qw(bin/fixfilenames.pl)],
    add_to_cleanup     => ['App-FixFilenames-*'],
    create_makefile_pl => 'passthrough',
    recursive_test_files => 1,
    fix_shebang_line=>['bin/fixfilenames.pl'],
);

$builder->create_build_script();
