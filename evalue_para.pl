#!/usr/bin/env perl
if(@ARGV != 3){
	print "perl $0 blast.result evalue identity\n";
}
my $blast_result = shift;
my $evalue = shift;
my $identity = shift;
open BL,$blast_result or die $!;
open OUT,">$blast_result.2" or die $!;
while(<BL>){
	chomp;
	my @a = split/\t/;
	if ($a[10] < $evalue && $a[2] > $identity){
		print OUT "$_\n";
	}
}
