use strict;
use warnings;
use lib ("./lib");
use InterPro2GFF3;
use Test::More qw/no_plan/;
use FindBin;


BEGIN { use_ok 'InterPro2GFF3' }

my $input = $FindBin::Bin."/data/Dd_trial.txt";

my $output = "Test.gff3";

my $me = InterPro2GFF3->new({input => $input , output => $output});

#Checking if the class object has been made
isa_ok($me, 'InterPro2GFF3', 'Checking Object to be InterPro2GFF3 object');

#Checking the Write_GFF3 subroutine
my $filehand = IO::File->new( 'WriteGFF_test.txt', 'w' ) or die "Can't open File: $!";
my $s_line1 = "DDB0184107	D79C83DA61B22B0D	774	PANTHER	PTHR19446	FAMILY NOT NAMED	225	754		T	26-MAY-12	IPR015706	RNA-directed DNA polymerase (reverse transcriptase)";
my $data2;
push @$data2, $s_line1;
my $self;

my $me2 = InterPro2GFF3->new();
$me2->write_gff3($data2,$filehand);

$filehand->close;

#Opening File to Read the Wrtie_GFF3 subroutine
my $filehand2 = IO::File->new( 'WriteGFF_test.txt', 'r' ) or die "Can't open File: $!";
my @text = <$filehand2>;

like($text[0], qr/sequence-region/, 'Write-GFF3 works');
$filehand2->close;



$me->process_file;

#Checking to see if file export exists after the file has been processed

is(-e $output,1,'File Export Exists');

#Checking to see if there is something in the output for the file the process_file creates
my $filehand3 = IO::File->new( $output, 'r' ) or die "Can't open File: $!";
my @text2 = <$filehand3>;
my $text_final = join('',@text2);

like($text_final, qr/DDB0184107/, 'Is there something in the output for process_file');
$filehand3->close;
