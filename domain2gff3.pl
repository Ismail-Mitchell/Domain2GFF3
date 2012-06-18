#!/usr/local/bin/perl

# $Date: 2012-06-13 $
# $Revision: 1.0.0 $
# $Source: /usr/local/Desktop/dictyProjects/​domain2gff3.pl $

use warnings;
use strict;
use Carp qw( croak );
use English qw( -no_match_vars );
use List::MoreUtils qw(uniq);

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

print
"Enter the name of the file after 'perl filename' if you have no information in domain.txt\n"
  or croak "failed\n";

#Opening DictyBase File for read in to arrays
open my $in, '<', $ARGV[0] or croak "Can't open Protein Domain File: $OS_ERROR";
my @lines = <$in>;

close $in or croak "$in: $OS_ERROR";

for my $line (@lines) {
    ( $f1, $f2, $f3, $f4, $f5, $f6, $f7, $f8, $f9, $f10, $f11, $f12, $f13 ) =
      split /\t/xms, $line;

    push @DICTYID, $f1;
    push @DBNAME,  $f4;
    push @START,   $f7;
    push @END,     $f8;
    push @SCORE,   $f9;
    push @DOMAINN, $f6;
    push @ALIAS,   $f5;
    push @NOTE1,   $f12;
    push @NOTE2,   $f13;

    #push(@DBX, $f2);
}

#Removing Headline of the Db_protein file from each array
shift @DICTYID;
shift @DBNAME;
shift @START;
shift @END;
shift @SCORE;
shift @DOMAINN;
shift @ALIAS;
shift @NOTE1;
shift @NOTE2;

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

my $length = scalar @DICTYID;

my @DICTYIDQ = uniq(@DICTYID);

my $length2 = scalar @DICTYIDQ;

my $c        = 0;
my $d        = 0;
my @startseq = ();
my @dictyseq = ();

while ( $d < $length2 ) {
    while ( $c < $length ) {

        if ( $DICTYIDQ[$d] eq $DICTYID[$c] ) {
            push @startseq, $START[$c];
            push @startseq, $END[$c];

        }
        else { }
        $c++;

    }    #End of while

    push @dictyseq, $DICTYIDQ[$d];
    @startseq = sort { $a <=> $b } @startseq;
    push @dictyseq, $startseq[0];    #Small Number
    @startseq = reverse @startseq;
    push @dictyseq, $startseq[0];    #Max Number
    @startseq = ();

    $c = 0;
    $d++;
}

#Opening a file to input the data into the gff3 format
open my $out, '>', 'domain.txt' or croak "Can't open output.txt: $OS_ERROR";

print {$out} "##gff-version 3\n" or croak "failed\n";

my $i         = 0;
my $s         = 0;
my $z         = 1;
my $old_dicty = q{};

push @DICTYID, q{Last One}
  ; #Adding one more element to the dictyid array for the ### if statement to work.

push @dictyseq, $old_dicty;    #Adding to end of array for s+3 function to work.
push @dictyseq, $old_dicty;    #Adding to end of array for s+3 function to work.
push @dictyseq, $old_dicty;    #Adding to end of array for s+3 function to work.

while ( $i < $length ) {

    #IF statement for printing out Sequence Regions
    if ( $dictyseq[$s] eq $DICTYID[$i] && $DICTYID[$i] ne $old_dicty ) {
        print {$out}
          "##sequence-region\t$dictyseq[$s]\t$dictyseq[$s+1]\t$dictyseq[$s+2]\n"
          or croak "failed\n";

        $old_dicty = $DICTYID[$i];
        $s         = $s + $z + $z + $z;
    }
    else { }

    #Prints out the lines for the sequences
    print {$out}
"$DICTYID[$i]\t$DBNAME[$i]\tpolypeptide\t$START[$i]\t$END[$i]\t$SCORE[$i]\t.\t.\tName=$DOMAINN[$i];Alias=$ALIAS[$i];Note=InterPro ID:$NOTE1[$i] | InterPro Name:$NOTE2[$i]\n"
      or croak "failed\n";

    #Prints out ### for end of sequence regions
    if ( $DICTYID[$i] ne $DICTYID[ $i + 1 ] ) {
        print {$out} "###\n" or croak "failed\n";
    }
    else { }

    $i++;

}    #End of $i While

close $out or croak "$in: $OS_ERROR";

