#!/usr/bin/env perl

if(@ARGV != 3){
	print "perl $0 solar_result length1 length2\n";
}

my $solar = shift;
my $len_1 = shift;
my $len_2 = shift;
open FL,$solar or die $!;
while(<FL>){
	chomp;
	my @a = split/\t/;
	my $len1 = abs($a[3] - $a[2] + 1);
	my $len2 = abs($a[8] - $a[7] + 1);
	print "$_\n" if ($len1 >= $len_1 && $len2 >= $len_2);
}
