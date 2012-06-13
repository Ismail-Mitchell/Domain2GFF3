#!/usr/local/bin/perl

#Creating holders for read in to allocate to Arrays
my ($f1, $f2, $f3, $f4, $f5, $f6, $f7, $f8, $f9, $f10, $f11, $f12, $f13);
$f1 = $f2 = $f3 = $f4 = $f5 = $f6 = $f7 = $f8 = $f9 = $f11 = $f12 = $f13 = "";

#Creating Arrays for Columns for 
my @dictyID = (); #f1 Seq ID
my @dbName  = (); #f4 Source or Database
my @Start = ();   #f7
my @End = ();     #f8
my @Score = ();   #f9
my @DomainN = (); #f6 Domain Name
my @Alias = ();   #f5 Domain ID
my @Note1 = ();   #f12 interprot ID
my @Note2 = ();   #f13 interprot name
my @Dbx = ();     #f2 CRC64

#Opening DictyBase File for read in to arrays
open DDFILE, "Dd_trial.txt" or die $!;
while (<DDFILE>) {
    ($f1, $f2, $f3, $f4, $f5, $f6, $f7, $f8, $f9, $f10, $f11, $f12, $f13) = split("\t", $_);
    
    push(@dictyID, $f1);
    push(@dbName, $f4);
    push(@Start, $f7);
    push(@End, $f8);
    push(@Score, $f9);
    push(@DomainN, $f6);
    push(@Alias, $f5);
    push(@Note1, $f12);
    push(@Note2, $f13);
    #push(@Dbx, $f2);
}

close DDFILE;

#Removing Headline of the Db_protein file from each array
shift(@dictyID);
shift(@dbName);
shift(@Start);
shift(@End);
shift(@Score);
shift(@DomainN);
shift(@Alias);
shift(@Note1);
shift(@Note2);

#Removing any Newline operations that may be in the front or the end of a line
foreach(@dictyID, @dbName, @Note1, @Note2){
    
    chomp $_;
}

#Replacing commas, semi colons for URL escaping conventions.
foreach (@Note2, @Note1, @DomainN, @Alias) {
  
$_ =~ s/,/%2C/;
$_ =~ s/;/%3B/;
    
} #End of Foreach


#Replacing Blank entries in score with a . to make it valid with gff3
foreach (@Score){
if(!$_){

    $_ = ".";

}
else
{}
    }#End of foreach of Score





#Opening a file to input the data into the gff3 format
open (MYFILE, '>domain.txt') || die("This file will not open!");

print MYFILE "##gff-version 3\n";

my $length = scalar(@dictyID);
for (my $i = 0; $i < $length; $i++)
{

    print MYFILE "$dictyID[$i]\t"; #Seq ID 
    print MYFILE "$dbName[$i]\t"; # Source
    print MYFILE "polypeptide\t"; # Type
    print MYFILE "$Start[$i]\t"; # Start
    print MYFILE "$End[$i]\t"; # End
    print MYFILE "$Score[$i]\t"; # Score
    print MYFILE ".\t"; # Strand
    print MYFILE ".\t"; # Phase
    print MYFILE "Name=$DomainN[$i];Alias=$Alias[$i];Note=InterPro ID:$Note1[$i] | InterPro Name:$Note2[$i]\n"; # Attributes

}

close MYFILE;
   

