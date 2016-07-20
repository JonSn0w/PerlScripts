#!/usr/bin/perl
use strict;
use warnings;

my %h;
foreach my $file(@ARGV) {
    open TAGS, $file or die $!;
    while(<TAGS>) {
	chomp;
	my ($key,$val) = (split /:/, $_, 2);
	$h{lc($key)} = $val;
    } 
}
while(<STDIN>) {
    chomp;
    if($. == 1) {
	my $head = '<html><head><title>'.$_.'</title></head>'."\n"
	    .'<body><h1>'.$_.'</h1>'."\n";
	$_ =~ s/$_/$head/;
    } else {
	for $w(split) {
	    $w =~ s/[[:punct:]]//;
	    if(exists($h{lc($w)})) {
		my $t = '<'.$h{lc($w)}.'>'.$w.'</'.$h{lc($w)}.'>';
		$_ =~ s/(?<!\>)$w/$t/i;
	    }
	}
	my $newline = $_.'<br />'."\n";
	$_ =~ s/$_/$newline/s;
    }
    print $_;
}
print '</body></html>'."\n";
