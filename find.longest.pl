#!/usr/bin/perl -w
use strict;
open FA, $ARGV[0] or die $!;
open OUT,">Sort.Tendem.repeat.cluster" or die $!;
my %hash;
while(<FA>){
	chomp;
	my ($family,$id)=(split /\t/,$_,2);
	my @a=(split /\,/,$id);
	my $num=scalar@a;
	$hash{$family}=$num;
}
close(FA);
foreach my $key(sort {$hash{$b}<=>$hash{$a}}keys %hash){
		print OUT "$key\t$hash{$key}\n";
}
		
