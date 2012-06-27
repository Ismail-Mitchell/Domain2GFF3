use strict;
use warnings;
use lib ("./lib");
use InterPro2GFF3;
use Test::More tests => 2;

BEGIN { use_ok 'InterPro2GFF3' }


my $me = InterPro2GFF3->new({input => '/t/data/Dd_trial.txt' , output => 'Test.gff3' });

isa_ok($me, 'InterPro2GFF3', 'Checking Object to be InterPro2GFF3 object');
