#!/usr/bin/perl
# use strict; 
# use warnings; 
use HTML::Parser;

my @fill;
my @date;
my @contrib;
my $url = 'https://github.com/JonSn0w'; 
printf(" %8s    %5s    %-11s\n","[Date]", "[Contribs]", "[Fill]");
while(<>) {
	while(/fill="#(.*)".* data-count="(.*)".* data-date="(.*)".*\/>/mgi) {
		push @fiill, $1;
		push @contrib, $2;
		my ($y, $m, $d) = (split '-', $3, 3);
		$y = substr($y, 2, 2);
		push @date, "$m/$d/$y";
		# my $rgb;
		# if($1 eq 'eeeeee') {
		# 	$rgb = '238,238,238';
		# } elsif($1 eq '44a340') {
		# 	$rgb = '68,163,64';
		# } elsif($1 eq '1e6823') {
		# 	$rgb = '30,104,35';
		# } elsif($1 eq 'd6e685') {
		# 	$rgb = '214,230,133';
		# } elsif($1 eq '8cc665') {
		# 	$rgb = '140,198,101';
		# }
	printf("%10s    %4d    %12s\n", "$m/$d/$y", $2, '#'.$1);
	}
}
print "\n";
