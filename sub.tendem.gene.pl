#!/usr/bin/perl -w
use strict;
open FA,$ARGV[0] or die $!;
my %hash1;
while(<FA>){
	chomp;
	my ($ID1,$ID2)=(split /\t/,$_)[0,1];
	my $scaffold1=(split /\./,$ID1)[2];
	my $scaffold2=(split /\./,$ID2)[2];
	if(($ID1 ne $ID2) && ($scaffold1 eq $scaffold2)){
	$hash1{$ID1}{$ID2}=$scaffold1;
}
}
foreach my $a(keys %hash1){
foreach my $b (keys %{$hash1{$a}})
{
if($hash1{$b}{$a}){
if ($hash1{$a}{$b} eq $hash1{$b}{$a}){delete $hash1{$a}{$b}}}
}
}

close (FA);
#foreach my $key(keys %hash1){
#	for my $key2(keys %{$hash1{$key}}){
#		print "$key\t$key2\n";
#}
#}
my %gff;
open GFF,$ARGV[1] or die $!;
open OUT, ">tendem.inter.gene" || die $!;
while(<GFF>){
	chomp;
	my ($scaffold,$type,$start,$id)=(split /\t/,$_)[0,2,3,8];
	if($type eq 'mRNA'){
	my $NAME=(split /\;/,$id)[0];
	$NAME=~s/ID=//g;
        $gff{$scaffold}{$NAME}=$start;
#	print "$NAME\n";
	}
}
foreach my $a (keys %hash1){
foreach my $b (keys %{$hash1{$a}})
{
my $sc=$hash1{$a}{$b};
my $count=0;
foreach my $s(keys %{$gff{$sc}} )
{
if(( $gff{$sc}{$s}  >$gff{$sc}{$a} && $gff{$sc}{$s} <$gff{$sc}{$b})|| ($gff{$sc}{$s}  <$gff{$sc}{$a} && $gff{$sc}{$s} >$gff{$sc}{$b}))
{
$count++
}
}
print OUT"$a\t$b\t$count\n";
}
}
close OUT;
close(GFF);

