#!/usr/local/bin/perl

# $Date: 2012-06-13 $
# $Revision: 1.0.0 $
# $Source: /usr/local/Desktop/dictyProjects/​domain2gff3.pl $

use warnings;
use strict;
use Carp qw( croak );
use English qw( -no_match_vars );
use IO::File;
use Bio::GFF3::LowLevel;

our $VERSION = '1.0.0';

#Opening File with IO file handlers to read in a line at a time

my $fh = IO::File->new( 'Dd_trial.txt', 'r' ) or croak "Can't open $ARGV[0] File: $OS_ERROR";

my $running_id;
my $current_id;
my @data = ();
my $i = 0;

while (my $line = $fh->getline) {
chomp($line);
    my @input_gff = split /\t/, $line;
      
  if(defined($running_id))
  {
      
   if(current_id eq running_id)   
  {    
      push @data, $line;
  } 
  else
  {
      write_gff3(@data);
      undef @data;
  
  }
  
  }#End of Run/Current IF
  else{}
    
}#End of While





    sub write_gff3{
    
    
    }
