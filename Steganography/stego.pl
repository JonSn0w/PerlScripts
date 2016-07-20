#!/usr/bin/perl
# file: stego
# parse a (simple) 24bit uncompressed BMP image and display some info
use strict;
use warnings;

die "You must specify a .bmp filename.\n" if not defined $ARGV[0];
my $filename = shift @ARGV;
open BMP, $filename or die "file error: $!";
read BMP, my $bmp, -s $filename;  # read file into $bmp
#decode some BMP information from the image header
my $width = unpack("L", substr($bmp, 18, 4));   # width
my $height = unpack("L", substr($bmp, 22, 4));   # height
# each "row" of image has multiple of 4 bytes (0 padded)
my $rowbytes=(int($width*3/4)+((int $width*3/4 == $width*3/4 )?0:1))*4;
# offset from start of file to start of image data
my $offset = unpack("L", substr($bmp, 10, 4));
# pixels stored in blue, green, red order
my ($b, $g, $r) = unpack("CCC", substr($bmp, $offset, 3));
# my $b2 = unpack("L", substr($b, 1, 4)); 
my $bfType =  unpack("C", substr($bmp, 1, 2));
my $bfSize =  unpack("C", substr($bmp, 3, 4));
my $bitCount =  unpack("C", substr($bmp, 28, 2));
my $bitComp =  unpack("C", substr($bmp, 30, 2));
my $xPelsPerMeter = unpack("C", substr($bmp, 38, 4));
my $yPelsPerMeter = unpack("C", substr($bmp, 42, 4));
my $colorsUsed = unpack("C", substr($bmp, 46, 4));
my $colorsVIP = unpack("C", substr($bmp, 50, 4));

print "------BMP Info------\n\n";
print "  Filename: $filename\n";
print "  Size: ".length($bmp)." bytes\n";
print "  Width(px): $width\n";
print "  Height(px): $height\n";
print "  Bytes per row: $rowbytes\n";
print "  Image data begins at byte: $offset\n\n";
print "  First pixel(last row of image):\n";
# printf ("  Red: %d - (hex:%x)\n", $r, $r);
# printf ("  Green: %d - (hex:%x)\n", $g, $g);
# printf ("  Blue: %d - (hex:%x)\n\n", $b, $b);

print "  Type: ".$bfType."\n";
print "  File Size (in bits): ".$bfSize."\n";
print "  Bit Count: ".$bitCount."\n";
print "  Compression: ".$bitComp."\n";
print "  X-PX Per Meter: ".$xPelsPerMeter."\n";
print "  Y-PX Per Meter: ".$yPelsPerMeter."\n";
print "  Colors Used: ".$colorsUsed."\n";
print "  Important Colors: ".$colorsVIP."\n";
print "  Offset: $offset\n";

my @val;
my $pos = $offset;
while($pos + 3 < length($bmp)) {
    my ($b, $g, $r) = unpack("CCC", substr($bmp, $pos, 3));
    push @val, substr(sprintf ("%08b", $b), 7, 1);
    push @val, substr(sprintf ("%08b", $g), 7, 1);
    push @val, substr(sprintf ("%08b", $r), 7, 1);
    $pos = $pos + 3;
}

my $j = 0;
my $byte;
my @out;
my @start;
my @end;
my $k = 0;
foreach my $n (@val) {
    if($j == 9) {
            if($n == 1) {
                push @out, $byte.' ';# if $byte ne "00000000";
                push @end, $n;
            } else { $byte = ""; }

    } elsif($j == 0) { 
        $k++;
        $byte = "";
        $j = -1 if $n ==0;
        if($n == 1) {
            push @start, $n if $k > 7322 && $k <= 7622;
        }
    } else {
        $byte = $byte."$n";
    }
   $j++;
   if($j > 9) {
        $j = 0;
   }
}
print "\n";
print @out;
print "\n\n";
print scalar(@start).'  -  '.scalar(@end)."\n";
foreach my $val(@out) {
    my $chars = length($val);
    my @packArray = pack("B$chars", $val);
    print "@packArray";
}
print "\n";
print 'START: ';
print @start;
print "\n";
print 'END: ';
print @end;
print "\n";

# my $c = 0;
# my $sum = 0;
# while($c < scalar(@start)) {
#     if($end[$c] eq $start[$c] && $end[$c] eq '1') {
#         $sum += $start[$c];
#         print $end[$c];
#     } else {
#         print "-"
#     }
#     $c++;
# }
# print "\n";
# print "$sum\n";
