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
InterPro2GFF3::write_gff3($self, $data2, $filehand );
$filehand->close;

open( FH, 'WriteGFF_test.txt' ) or die "Can't open File: $!";
my @text = <FH>;

if($text[0] =~ m/sequence-region/)
{
    ok(1==1, 'Write-GFF3 works');
}

else{
    ok(2==1, 'Write-GFF3 works');
    
}

close FH;

$me->process_file;

#Checking to see if file export exists after the file has been processed

is(-e $output,1,'File Export Exists');

open( FH2, $output ) or die "Can't open File: $!";
my @text2 = <FH2>;


if($text[0] =~ m/DDB0184107/)
{
    ok(1==1, 'Is there something in the output for process_file');
}

else{
    ok(2==1, 'Is there something in the output for process_file');
    
}

close FH2;