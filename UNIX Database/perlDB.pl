#!/usr/bin/perl
use strict;
use warnings;
use DB_File;

my %hash;
my $memory = "memory";
# Associate hash with unix database 
dbmopen(%hash, $memory, 0666) or die "Can't open $memory$!\n";
# %hash=();    # clears hash
while(<>) {
    chomp;
    #Discern Rules from Queries
    if(m/what is/si) {     # Query (type-A)
	$_ =~ s/\?//gsi;
	my $key;
	if(/what is (\w+)./si) {
		$key = lc($1);
	}
	if(exists($hash{$key})) {
	    my $val = $hash{$key};
	    my $data = (split / /, $val)[-1];    # grab last word in string
	    $val =~ s/$data/\u$data/si;
	    print "[A]: \u$key is $val\n";
	} else {
	    print "[A]: I don\'t know \u$key.\n";
	}
    } elsif(m/who/si && m/\?/s) {     # Query (type-B)
	$_ =~ s/\?/\./gsi;
	my $val = lc((split / is /, $_)[1]); 
	my %rev = reverse %hash;
	if(exists($rev{$val})) {
	    for my $key(sort keys %hash) {
		if($val =~ m/$hash{$key}/si) {
		    my $data = (split / /, $val)[-1];
		    $val =~ s/$data/\L\u$data\E/si;
		    print "[B]: \L\u$key is\E $val\n";
		}
	    }
	} else {
	    my $data = (split / /, $val)[-1]; 
	    $val =~ s/$data/\L\u$data\E/si;
	    print "[B]: Nobody is $val\n";
	}
    } else {    # Rule
	my ($key, $val) = (split / is /, $_, 2);
	$key = lc($key);
	$hash{$key} = lc($val);
	print "\u$key is $val\n";
    }
}
dbmclose(%hash);
