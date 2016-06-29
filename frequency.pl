#!usr/bin/perl

my ($filename1, $filename2) = @ARGV;
if (not defined $filename2) {
    die "You must specify two filenames.\n";
}
open FILE1, '<', $filename1 or die "Could not open ". $filename1;
open FILE2, '<', $filename2 or die "Could not open ". $filename2;
@arr=<FILE1>;
$index=0;
foreach $num (<FILE2>) {
    last if(chomp $num == 0);
    chomp $num;
    $count{$num} = 0;
    $i=0;
    do{
        if(@arr[$i] == $num) {
            $count{$num}++;
        }
        $i++;
    } while($i < scalar(@arr) && @arr[$i] != 0);
    if($num != 0) {
        @out[$index++] =  $num . ' ' . $count{$num} . "\n";
    }
}
print @out;