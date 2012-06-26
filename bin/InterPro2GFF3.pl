use strict;
use InterPro2GFF3;
use Getopt::Long;


my $input = 'Dd_trial.txt';
my $output = 'Output.gff3';

#Creating Options using Get Long    
GetOptions(
'i|input=s'  => \$input,
'o|output=s' => \$output,
) or die "Incorrect usage!\n";



#Creating New Class
my $me = InterPro2GFF3->new({input => $input , output => $output });

#Processes the file for the output
$me->process_file;