#!/usr/local/bin/perl

# $Date: 2012-06-13 $
# $Revision: 1.0.0 $
# $Source: /usr/local/Desktop/dictyProjects/​domain2gff3.pl $

use warnings;
use strict;
use Carp qw( croak );
use IO::File;
use Bio::GFF3::LowLevel qw (gff3_format_feature);
use Data::Dumper;

our $VERSION = '1.0.0';

#Opening File with IO file handlers to read in a line at a time

my $fh = IO::File->new( 'Dd_trial.txt', 'r' )
or croak "Can't open $ARGV[0] File: $!";

my $running_id;
my $current_id;
my $data;
my $input;

while ( my $line = $fh->getline ) {
    chomp($line);
    my @input_gff = split /\t/, $line;
    
    $current_id = $input_gff[0];
    
    if ( $running_id ) {
        if ( $current_id eq $running_id ) {
            push @$data, $line;
        }
        else {
            write_gff3($data);
            undef $data;
            push @$data, $line;
        }
        
    }    #End of Run/Current IF
    else {
        push @$data, $line;
         }
    
    
    $running_id = $current_id;
    
}    #End of While





sub write_gff3 {
    
    
    my ($data)  = @_;
    
    my @start_end;
    my $outstr = q{};
    my $name;
    my $running_id;
    my $current_id;
    my $domain;
    my $i = 0;
    
    foreach my $line(@$data)
    {
        my @parts;
        my $gff;
        @parts = split /\t/, $line;
        
        $gff->{seq_id} = $parts[0];
        $gff->{source} = $parts[3];
        $gff->{type} = $parts[5];
        $gff->{start} = $parts[6];
        $gff->{end} = $parts[7];
        $gff->{score} = $parts[8];
        $gff->{strand} = ".";
        $gff->{phase} = undef;
        $gff->{attributes}->{Alias} = $parts[4];

        $current_id = $parts[3];
        
        if ( $running_id ) {
            if ( $current_id eq $running_id ) {
                $gff->{attributes}->{ID} = $i;

            }
            else {
                $i++;
                $gff->{attributes}->{ID} = $i;
                            }
            
        }    #End of Run/Current IF
        else {
            $gff->{attributes}->{ID} = $i;
        }
        
        
        $running_id = $current_id;
        

        push @start_end, $parts[6], $parts[7];
        $outstr = gff3_format_feature($gff).$outstr;
        $name = $parts[0];
    }
    
    
    @start_end = sort { $a <=> $b } @start_end;
    
    print "##sequence-region\t$name\t$start_end[0]\t$start_end[-1]\n".$outstr."###\n";
    
    
    
    
    
    
}
