#!/usr/bin/perl

open(DATA, "<OST_STUDENTS.csv");
@students = <DATA>;
$count = @students;

@fourOne = grep { /4-1/ } @students;
$countOne = @fourOne;
@fourTwo = grep { /4-2/ } @students;
$countTwo = @fourTwo;
$date = localtime();
$creator1 = "Justinne Dale Anova";
$creator3 = "Gladys Joy Catimbang";
$creator2 = "Casandra Joyce Catibog";

format header =
------------------------------------------------------
						Page @<<
						     $%
	Open Source Technology CS @<<< Students
				  $sec
No. Name				Student No
------------------------------------------------------
.

format student =
@<<<@<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<@<<<<<<<<<
$n, $name, $studno
------------------------------------------------------
.

format footer =


				Prepared by: @<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<
				    	     $creator1
					     @<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<
					     $creator2
					     @<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<
					     $creator3
				Date: @<<<<<<<<<<<<<<<<<<<<<<<<<
					$date
.

sub fourOne {
        open(DATA, ">OST_LAB_STUDENT_4-1.txt") or die "Couldn't open";
        select(DATA);
        $~ = "student";
        $^ = "header";
        $i = 0;
        $n = 0;


        foreach my $c (@fourOne){
	      ($lastname, $firstname, $studno, $sec) = split /,/, @fourOne[$i];
	       $n;	
	       $name = $lastname .','. $firstname;
	       $studno[$i];
	       $i++;
	       $n++;
	       write;
         }
close(DATA);
}

sub fourTwo {
        open(DATA, ">OST_LAB_STUDENT_4-2.txt") or die "Couldn't open";
        select(DATA);
        $~ = "student";
        $^ = "header";
        $- = "footer";
        $i = 0;
        $n = 0;


        foreach my $c (@fourTwo){
	      ($lastname, $firstname, $studno, $sec) = split /,/, @fourTwo[$i];
	       $n;	
	       $name = $lastname .','. $firstname;
	       $studno[$i];
	       $i++;
	       $n++;
	       write;
         }
		close(DATA);
}


fourOne();
fourTwo();

sub append1 {
	open(DATA, ">>OST_LAB_STUDENT_4-1.txt") or die "Couldn't open";
	select(DATA);
	$~ = "footer";
	write;
	close(DATA);
}

sub append2 {
	open(DATA, ">>OST_LAB_STUDENT_4-2.txt") or die "Couldn't open";
	select(DATA);
	$~ = "footer";
	write;
	close(DATA);
}

append1();
append2();




