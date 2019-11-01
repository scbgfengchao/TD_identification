#!/usr/bin/perl -w
use strict;
unless(@ARGV){
	print "perl $0 [gene pairs]\n";
	exit;
}
my $infile=shift;
my $cluster=shift;
my %mapid=();
my %cluster=();
my $count=0;
open IN,"<","$infile" or die;
while(<IN>){
	chomp;
	my @a=split;
	if(!exists $mapid{$a[0]} && !exists $mapid{$a[1]}){
		$count++;
		$mapid{$a[0]}=$count;
		$mapid{$a[1]}=$count;
		$cluster{$count}{$a[0]}=1;
		$cluster{$count}{$a[1]}=1;
	}elsif(exists $mapid{$a[0]} && !exists $mapid{$a[1]}){
		my $mapid1=$mapid{$a[0]};
		$mapid{$a[1]}=$mapid1;
		$cluster{$mapid1}{$a[1]}=1;
	}elsif(!exists $mapid{$a[0]} && exists $mapid{$a[1]}){
		my $mapid2=$mapid{$a[1]};
		$mapid{$a[0]}=$mapid2;
		$cluster{$mapid2}{$a[0]}=1;
	}else{
		my $mapid3=$mapid{$a[0]};
		my $mapid4=$mapid{$a[1]};
		next if($mapid3 == $mapid4);
		if($mapid3 < $mapid4){
			foreach my $f1(keys %{$cluster{$mapid4}}){
				$cluster{$mapid3}{$f1}=1;
				$mapid{$f1}=$mapid3;
				}
				delete $cluster{$mapid4};
		}else{
			foreach my $f2(keys %{$cluster{$mapid3}}){
				$cluster{$mapid4}{$f2}=1;
				$mapid{$f2}=$mapid4;
				}
				delete $cluster{$mapid3};
				}
			}
}
close IN;
open OUT,">","Tendem.repeat.cluster" or die;
foreach my $k1(sort {$a<=>$b}keys %cluster){
		print OUT "$k1\t";
foreach my $k2(sort keys %{$cluster{$k1}}){
		print OUT "$k2,";
	}
		print OUT "\n";
}
		
