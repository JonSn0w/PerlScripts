#!/usr/bin/perl
use strict;
use warnings;

die "You must specify a .bmp filename.\n" if not defined $ARGV[0];
my $filename = shift @ARGV;
open BMP, $filename or die "file error: $!";
read BMP, my $bmp, -s $filename;  # read file into $bmp
my $width = unpack("L", substr($bmp, 18, 4)); 
my $offset = unpack("L", substr($bmp, 10, 4));

my $byte;
my $i = 0;
my $index = $offset;
while($index < length($bmp)) {
    my $rgb = unpack("CCC", substr($bmp, $index));
    my $lsb = substr(sprintf ("%08b", $rgb), 7, 1);    # get least sig bits of rgb bytes 
    if($i % 10 == 0) {    # identify valid "start" bits
        $i-- if $lsb ==0;    
        $byte="";
    } elsif($i % 10 == 9) {   
        if($lsb == 1) {    # identify valid "stop" bits
            my $chars = length($byte);
            my @msg = pack("B$chars", $byte);
            print @msg;
        } else {
            while(substr($byte, 0) eq "0") {    # cycle until valid "start" & "stop" bits  
                $byte = substr($byte, 1, length($byte)-1);
            }
            $i = length($byte);
        }
    } else {
        $byte = $byte."$lsb";
    }
    $i++;
    $index++;
}
