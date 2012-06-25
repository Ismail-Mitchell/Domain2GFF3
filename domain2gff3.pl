#!/usr/local/bin/perl

# $Date: 2012-06-13 $
# $Revision: 1.0.0 $
# $Source: /usr/local/Desktop/dictyProjects/​domain2gff3.pl $

use warnings;
use strict;
use IO::File;
use Bio::GFF3::LowLevel qw (gff3_format_feature);
use Data::Dumper;
use Getopt::Long;
our $VERSION = '1.0.0';

# setup defaults
my $input_file  = 'Dd_trial.txt';
my $output_file = 'output.gff3';

GetOptions(
    'i|input=s'  => \$input_file,
    'o|output=s' => \$output_file,
) or die "Incorrect usage!\n";

#Opening File with IO file handlers to read in a line at a time

my $fh = IO::File->new( $input_file, 'r' )
  or die "Can't open $input_file File: $!";

my $fh2 = IO::File->new( $output_file, 'w' )
  or die "Couldn't open file for writing: $!\n";

$fh2->print("##gff-version\t3\n");

my $running_id;
my $current_id;
my $data;

while ( my $line = $fh->getline )
{
    chomp($line);
    my @input_gff = split /\t/, $line;

    $current_id = $input_gff[0];

    if ($running_id)
    {
        if ( $current_id eq $running_id )
        {
            push @$data, $line;
        }
        else
        {
            write_gff3( $data, $fh2 );
            undef $data;
            push @$data, $line;
        }

    }    #End of Run/Current IF
    else
    {
        push @$data, $line;
    }

    $running_id = $current_id;

}    #End of While

$fh->close;
$fh2->close;

sub write_gff3
{

    my ( $data, $fh2 ) = @_;

    my @start_end;
    my $outstr = q{};
    my $name;
    my $running_id;
    my $current_id;
    my $domain;
    my $i = 0;

    foreach my $line (@$data)
    {
        my @parts;
        my $gff;
        @parts = split /\t/, $line;

        $gff->{seq_id}              = $parts[0];
        $gff->{source}              = $parts[3];
        $gff->{type}                = $parts[5];
        $gff->{start}               = $parts[6];
        $gff->{end}                 = $parts[7];
        $gff->{strand}              = ".";
        $gff->{phase}               = undef;
        $gff->{attributes}->{Alias} = $parts[4];

        if ( !$parts[8] )
        {

            $gff->{score} = q{.};
        }
        else
        {
            $gff->{score} = $parts[8];

        }

        $current_id = $parts[3];

        if ($running_id)
        {
            if ( $current_id eq $running_id )
            {
                $gff->{attributes}->{ID} = $i;

            }
            else
            {
                $i++;
                $gff->{attributes}->{ID} = $i;
            }

        }    #End of Run/Current IF
        else
        {
            $gff->{attributes}->{ID} = $i;
        }

        $running_id = $current_id;

        push @start_end, $parts[6], $parts[7];
        $outstr .= gff3_format_feature($gff);
        $name = $parts[0];
    }

    @start_end = sort { $a <=> $b } @start_end;

    $fh2->print( "##sequence-region $name $start_end[0] $start_end[-1]\n" 
          . $outstr
          . "###\n" );

}
