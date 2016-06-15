#!/usr/bin/perl
# Inserts a space between each character of the input. 

while(<>) {
	s// /g;
	print;
}
