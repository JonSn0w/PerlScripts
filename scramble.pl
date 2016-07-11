#!usr/local/bin/perl

$count=<>;
@arr=<STDIN>;
$i=0;
do { # loops through the integers
    $index=@arr[$i]+$count;
    if($index < scalar(@arr)) {
        print @arr[$index];
    }
    $i++;
} while($i<$count);
