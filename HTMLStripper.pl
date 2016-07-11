#!usr/bin/perl
use strict;
use warnings;

# Reads html, removes the tags, and makes various substitutions and modifications depending on the type of tag.

while(<>) {
    	while(m/<(.*?)>/g) {
    		my $tag = $1;
    		if ($tag =~ m/p/i) {
    			s/<$tag>/\n/gi;
    		} elsif (m/br/i) {
    			s/<$tag>/\n/gi;
    		} elsif (m/hr/i) {
    			s/<$tag>/'-'x60/ie;
    		} elsif (m/em/i) {
    			s/<$tag>//gi;
    			s/[a-zA-Z]+/\/$&\//g;	  # this makes two slashes on either side of whitespace
    			s/\/\//\//g;			  # replace doubles with a single slash
    		} else {
    			s/<$tag>//;
    		} 
    	}
   	print $_;
}
