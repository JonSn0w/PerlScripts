#!/usr/bin/perl
# file: stego
# parse a (simple) 24bit uncompressed BMP image and display some info

# 1. Read the heder info
# 2. Modify the width and height attributes
# 3. Modify the file size attr
# 4. Get the bitmap data starting at the offset and modify it pixel linewise to get what you want, remebering that you need to pack with nulls to a multiple of 4 - so if the image is 10pix wide at 24 bits each line will be 10+*24/8 = 30 bytes + 2 = 32 bytes to make it divisible by 4.
# 5. Repack all the data into a scalar and write to a file.

use strict;
use warnings;

# my @head = qw(
#     bfType
#     bfSize
#     bfReserved1
#     bfReserved2
#     bfOffBits
#     biSize
#     biWidth
#     biHeight
#     biPlanes
#     biBitCount
#     biCompression
#     biSizeImage
#     biXPelsPerMeter
#     biYPelsPerMeter
#     biClrUsed
#     biClrImportant
# 			);

# binmode STDIN;
# binmode STDOUT;

# my $filename = $ARGV[0];
# if (not defined $filename) {
#     die "You must specify a .bmp filename.\n";
# }
# print $filename."\n";
# open BMP, $filename or die $!;
# binmode BMP;
# my $data = <BMP>;
# close BMP;

# my @head_data = unpack "SLSSLLLLSSLLLLLL", $data;
# my %header;
# my @hdr;
# @header{@hdr}=@head_data;
# print "$_\t$header{$_}\n" for @head;

# chop in half!
# $header{biHeight} = int($header{biHeight}/2);

# my $new_head = pack "SLSSLLLLSSLLLLLL", @header{@hdr};

# $data =~ s/^.{54}/$new_head/;
# open OUT, ">$filename.out.bmp" or die $!;
# binmode OUT;
# print OUT $data;
# close OUT;

if (not defined $ARGV[0]) {
    die "You must specify a .bmp filename.\n";
}
my $bmp;
my $filename = shift @ARGV;
open BMP, $filename or die "file error: $!";
read BMP, $bmp, -s $filename;  # read file into $bmp
# print substr($bmp, 4517, 4588)."\n";
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
printf ("  Red: %d - (hex:%x)\n", $r, $r);
printf ("  Green: %d - (hex:%x)\n", $g, $g);
printf ("  Blue: %d - (hex:%x)\n\n", $b, $b);

print "  Type: ".$bfType."\n";
print "  File Size (in bits): ".$bfSize."\n";
print "  Bit Count: ".$bitCount."\n";
print "  Compression: ".$bitComp."\n";
print "  X-PX Per Meter: ".$xPelsPerMeter."\n";
print "  Y-PX Per Meter: ".$yPelsPerMeter."\n";
print "  Colors Used: ".$colorsUsed."\n";
print "  Important Colors: ".$colorsVIP."\n\n";
print "Offset: $offset\n";
my $i = 1;
my $pos = $offset;
my @val;
while($pos +3 <= length($bmp)) {
    my ($b, $g, $r) = unpack("CCC", substr($bmp, $pos, 3));
    print "$i: \n";
    printf ("  Red: %08b\n", $r);
    push @val, substr(sprintf ("%08b", $r), 7, 1);
    # push @val, substr(%08b $r, 7, 1)
    printf ("  Green: %08b\n", $g);
    push @val, substr(sprintf ("%08b", $g), 7, 1);
    # push @val, substr(%08b $g, 7, 1);
    printf ("  Blue: %08b\n", $b);
    push @val, substr(sprintf ("%08b", $b), 7, 1);
    # push @val, substr(%08b $b, 7, 1);
    $pos = $pos + 3; 
    $i++;
}
print "\nValues: ";
my $j = 0;
foreach my $n (@val) {
    # if($j != 0 && j != 9)
    if($j % 8 == 0) {
        print " - ";
    }
    print $n;
   $j++;
}
print "\n";
print "Pos: $pos\n";
#11111111 - 11110001 - 11111111
