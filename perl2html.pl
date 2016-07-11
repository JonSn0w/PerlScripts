#!/usr/bin/perl
use strict;
use warnings;

my @out = ('<pre>'."\n");
while(<>) {
    $_ =~ s/</&lt;/;
    $_ =~ s/>/&gt;/;
    if(/\#/) {   # line has a comment
        chomp;
        $_ =~ s/\#/<em>\#/;
        $_ = $_.'</em>'."\n";
    }
    push @out, $_;
}
push @out, '</pre>'."\n";
print @out;
