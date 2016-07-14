#!/usr/bin/perl
# use strict;
# use warnings;
use DB_File;

#TODO: needs to be able to handle a(n)

my %hash;
my $data = "memory.db";
dbmopen(%hash, $data, 0666) or die "Can't open $data$!\n";
# %hash=();    # clears hash
while(<>) {
	chomp;
	#discern Rules from Queries
	if(m/what/si && m/\?/s) {     # Query (type-A)
		$_ =~ s/\?//gsi;
		my $key = (split / /, $_)[-1];   # grab last word in string
		$key = lc($key);
		$key = substr($key, 0, length($key)-1);
		if(exists($hash{$key})) {
			my $val = ucfirst($hash{$key});
			print '[A]: '.ucfirst($key).' is a(n) '.$val."\n";
		} else {
			print '[A]: '."I don't know $key\n";
		}
	} elsif(m/who/si && m/\?/s) {     # Query (type-B)
		$_ =~ s/\?//gsi;
		my $val = (split / /, $_)[-1];   # grab last word in string
		$val = lc($val);
		my %rev = reverse %hash;
		if(exists($rev{$val})) {
			#TODO: needs to be able to handle multiple
			my $key = $rev{$val};
			$val = ucfirst($val);
			print '[B]: '.ucfirst($key).' is a(n) '.$val."\n";
		} else {
			print '[B]: '."Nobody is a(n) $val"."\n";
		}
	} else {    # Rule
		$_ =~ s/\.//gsi;
		my ($key, $val) = split / is a /, $_, 2;
		$key = lc($key);
		$hash{$key} = lc($val);
		$val = ucfirst($val);
		print ucfirst($key).' is a '.$val."\n";
	}
}
# print "\n";
# for my $key(sort keys %hash) {
# 	my $val = ucfirst($hash{$key});
# 	print ucfirst($key).' is a '.$val."\n";
# }
print "\n".'%rev:'."\n";
my %rev = reverse %hash;
for my $key(sort keys %rev) {
	my $val = ucfirst($rev{$key});
	$key = ucfirst($key);
	print $val.' is a '.$key."\n";
}
dbmclose(%hash);