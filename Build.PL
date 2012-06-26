use strict;
use warnings;

use Module::Build 0.3601;


my %module_build_args = (
'requires_argument' => {
    'Module::Build' => '0.3601',
    'Bio::GFF3::LowLevel' => '1.3',
    'IO::File' => '1.3',
    'Class::Accessor' => '0.34'
},
'configure_requires' => {
    'Module::Build' => '0.3601',
    'Bio::GFF3::LowLevel' => '1.3',
    'IO::File' => '1.3',
    'Class::Accessor' => '0.34'    
    
},
'dist_abstract' => 'Converts InterPro File to GFF3',
'dist_author' => [
'Ismail Mitchell <Mitchell.Ismail@gmail.com>'
],
'dist_name' => 'InterPro2GFF3',
'dist_version' => '1.00',
'license' => 'perl',
'module_name' => 'InterPro2GFF3',
'recommends' => {},
'recursive_test_files' => 1,
'requires' => {
    'Bio::GFF3::LowLevel' => '1.3',
    'IO::File' => '1.3',
    'Class::Accessor' => '0.34'    
},
'script_files' => []
);


my $build = Module::Build->new(%module_build_args);

$build->create_build_script;