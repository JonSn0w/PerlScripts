#!/usr/bin/perl
use strict;
use warnings;
use DB_File;

my %hash;
my $data = "memory.db";
# Associate hash with unix database 
dbmopen(%hash, $data, 0666) or die "Can't open $data$!\n";
# %hash=();    # clears hash
while(<>) {
	chomp;
	#Discern Rules from Queries
	if(m/what/si && m/\?/s) {     # Query (type-A)
		$_ =~ s/\?//gsi;
		my $key = lc((split / /, $_)[-1]);    # grab last word in string
		$key = substr($key, 0, length($key)-1);
		if(exists($hash{$key})) {
			my $val = $hash{$key};
			my $data = ucfirst((split / /, $val)[-1]); 
			my $first = (split / /, $_)[0];
			my $last = (split / /, $_)[-1]; 
			$val =~ s/$data/$data/si;
			$key = ucfirst($key);
			$_ =~ s/$last/$val/i;
			$_ =~ s/$first/$key/i;
		} else {
			$key = ucfirst($key);
			$_ =~ s/what is/I don\'t know/i;
			$_=~ s/$key/$key/si;
		}
		print '[A]: '.$_."\n";
	} elsif(m/who/si && m/\?/s) {     # Query (type-B)
		$_ =~ s/\?/\./gsi;
		my $val = lc((split / is /, $_)[1]); 
		my %rev = reverse %hash;
		if(exists($rev{$val})) {
			#TODO: needs to be able to handle multiple
			for my $key(sort keys %hash) {
				if($val =~ m/$hash{$key}/si) {
					my $data = ucfirst((split / /, $val)[-1]);
					$val =~ s/$data/$data/si;
					print '[B]: '.ucfirst($key).' is '.$val."\n";
				}
			}
		} else {
			my $data = ucfirst((split / /, $val)[-1]); 
			$val =~ s/$data/$data/si;
			print '[B]: Nobody is '.$val."\n";
		}
	} else {    # Rule
		my ($key, $val) = (split / is /, $_, 2);
		$key = lc($key);
		$hash{$key} = lc($val);
		#print ucfirst($key).' is '.$val."\n";
	}
}
dbmclose(%hash);