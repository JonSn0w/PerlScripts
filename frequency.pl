#!\usr\bin\perl

my $filename1 = $ARGV[0];
my $filename2 = $ARGV[1];
open FILE1, $filename1 or die $!;
open FILE2, $filename2 or die $!;

@arr1=<FILE1>;
@arr2=<FILE2>;
$index=0;
foreach $n (@arr2) {
	chomp($n);
	@counter[$n] = 0;
	$i = 0;
	do {
		if(@arr1[$i] == $n) { 
   			@counter[$n]++;
	 	}
   		$i++;
	} while($i < scalar(@arr1));
	@out[$index++] =  $n . ' ' . @counter[$n] . "\n";
}
chomp(@out[scalar(@out)-1]);
print @out;