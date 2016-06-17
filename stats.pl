#!/usr/bin/perl
# Demonstrates basic number manipulation. 

while(<>) {
	$count += 1;
	$sum += $_;
	if($max < $_) {
		$max = $_;
	}
}
print "count ", $count, "\n";
print "sum ", $sum, "\n";
print "max ", $max, "\n";