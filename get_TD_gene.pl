#!/usr/bin/env perl
my $InFile = shift;
open FL,$InFile or die $!;
while(<FL>){
	chomp;
	my @a = split/\t/;
	if(! defined $hash{$a[0]}{$a[5]}  && ! defined $hash{$a[5]}{$a[0]}){
	        $hash{$a[0]}{$a[5]} = 1;
		if($a[0] le $a[5]){
			print "$a[0]\t$a[5]\n";
		}else{
			print "$a[5]\t$a[0]\n";
		}
	}else{
		next;
	}
}
=head
for my $kk(keys %hash){
	for my $kkk(keys %{$hash{$kk}}){
		print "$kk\t$kkk\n";
	}
}
=cut
