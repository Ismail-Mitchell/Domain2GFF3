#!/usr/local/bin/perl

# $Date: 2012-06-13 $
# $Revision: 1.0.0 $
# $Source: /usr/local/Desktop/dictyProjects/​domain2gff3.pl $

use warnings;
use strict;
use Carp qw( croak );
use English qw( -no_match_vars );

our $VERSION = '1.0.0';

#Creating holders for read in to allocate to Arrays
my ( $f1, $f2, $f3, $f4, $f5, $f6, $f7, $f8, $f9, $f10, $f11, $f12, $f13 );
$f1 = $f2 = $f3 = $f4 = $f5 = $f6 = $f7 = $f8 = $f9 = $f10 = $f11 = $f12 =
  $f13 = q{};    #Setting to an empty string

#Creating Arrays for Columns for
my @DICTYID = ();    #f1 Seq ID
my @DBNAME  = ();    #f4 Source or Database
my @START   = ();    #f7
my @END     = ();    #f8
my @SCORE   = ();    #f9
my @DOMAINN = ();    #f6 Domain Name
my @ALIAS   = ();    #f5 Domain ID
my @NOTE1   = ();    #f12 interprot ID
my @NOTE2   = ();    #f13 interprot name
my @DBX     = ();    #f2 CRC64

#Opening DictyBase File for read in to arrays
open( my $in, '<', 'Dd_trial.txt' ) or croak "Can't open input.txt: $OS_ERROR";
my @lines = <$in>;

close $in or croak "$in: $OS_ERROR";

for my $line (@lines) {
    ( $f1, $f2, $f3, $f4, $f5, $f6, $f7, $f8, $f9, $f10, $f11, $f12, $f13 ) =
    split(/\t/, $line)xms;

    push( @DICTYID, $f1 );
    push( @DBNAME,  $f4 );
    push( @START,   $f7 );
    push( @END,     $f8 );
    push( @SCORE,   $f9 );
    push( @DOMAINN, $f6 );
    push( @ALIAS,   $f5 );
    push( @NOTE1,   $f12 );
    push( @NOTE2,   $f13 );

    #push(@DBX, $f2);
}

#Removing Headline of the Db_protein file from each array
shift(@DICTYID);
shift(@DBNAME);
shift(@START);
shift(@END);
shift(@SCORE);
shift(@DOMAINN);
shift(@ALIAS);
shift(@NOTE1);
shift(@NOTE2);

#Removing any Newline operations that may be in the front or the end of a line
foreach ( @DICTYID, @DBNAME, @NOTE1, @NOTE2 ) {

    chomp $_;
}

#Replacing commas, semi colons for URL escaping conventions.
foreach ( @NOTE2, @NOTE1, @DOMAINN, @ALIAS ) {

    $_ =~ s/,/%2C/xms;
    $_ =~ s/;/%3B/xms;

}    #End of Foreach

#Replacing Blank entries in score with a . to make it valid with gff3
foreach (@SCORE) {
    if ( !$_ ) {

        $_ = q{.};

    }
    else { }
}    #End of foreach of Score

#Opening a file to input the data into the gff3 format
open( my $out, '>', 'domain.txt' ) or croak "Can't open output.txt: $OS_ERROR";

print {$out} "##gff-version 3\n";

my $length = scalar(@DICTYID);

my $i = 0;

while ( $i < $length ) {

    print {$out} "$DICTYID[$i]\t";    #Seq ID
    print {$out} "$DBNAME[$i]\t";     # Source
    print {$out} "polypeptide\t";     # Type
    print {$out} "$START[$i]\t";      # Start
    print {$out} "$END[$i]\t";        # End
    print {$out} "$SCORE[$i]\t";      # Score
    print {$out} ".\t";               # Strand
    print {$out} ".\t";               # Phase
    print {$out}
"Name=$DOMAINN[$i];Alias=$ALIAS[$i];Note=InterPro ID:$NOTE1[$i] | InterPro Name:$NOTE2[$i]\n"
      ;                               # Attributes
    $i++;

}

close $out or croak "$in: $OS_ERROR";
