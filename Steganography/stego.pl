#!/usr/bin/perl
use strict;
use warnings;

die "You must specify a .bmp filename.\n" if not defined $ARGV[0];
my $filename = shift @ARGV;
open BMP, $filename or die "file error: $!";
read BMP, my $bmp, -s $filename;  # read file into $bmp
my $width = unpack("L", substr($bmp, 18, 4)); 
my $offset = unpack("L", substr($bmp, 10, 4));

my @val;
my $flag;
my $index = $offset;
while($index < length($bmp)) {      # get least sig bits of rgb bytes
    my $rgb = unpack("CCC", substr($bmp, $index));
    my $lsb = substr(sprintf ("%08b", $rgb), 7, 1);
    $flag = 1 if($lsb eq '1');
    push @val, $lsb if defined $flag;
    $index += 1;
}

my $byte;
my $i = 0;
foreach my $n(@val) {
    if($i % 10 == 0) {
        $i-- if $n ==0;
        $byte="";
    } elsif($i % 10 == 9) {
        if($n == 1) {
            my $chars = length($byte);
            my @msg = pack("B$chars", $byte);
            print @msg;
        } else {
            while(substr($byte, 0, 1) eq "0") {
                $byte = substr($byte, 1, length($byte)-1);
            }
            $i = length($byte);
        }
    } else {
        $byte = $byte."$n";
    }
   $i++;
}
