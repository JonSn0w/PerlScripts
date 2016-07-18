#!/usr/bin/perl

my %hash;
while(<>) {
	print "Key: ";
	$| = 1;   # flush              
   	my $key = <STDIN>;
   	chomp $key;
	print "\nWhat is the value of ".$key.'? ' ;
	$| = 1;    # flush           
   	my $val = <STDIN>;
   	chomp $val;
	$hash{$key} = $val;
	print "\nKey: $key\nValue: $hash{$key}\n";
}
