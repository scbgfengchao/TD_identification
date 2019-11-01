use strict;
if(@ARGV != 4){
	print "perl $0 gff.file blast.solar.2 distance outfile\n";
}

my $gFile = shift;
my $dFile = shift;
#my $cut4dis = 100000;
my $cut4dis = shift;
my $oFile = shift;
#my $fix = shift;

my %gene_pos = ();
open IN, $gFile or die $!;
while(<IN>){
	chomp;
	#AmTr_v1.0_scaffold00061 protein_coding  mRNA    2329330 2338805 .       -       .       ID=ERN19130;
	my @arr = split('\s+', $_);
	if($arr[2] eq "mRNA"){
		my $name = (split('[\=\;]', $arr[-1]))[1];
#		print "$name\n";
		#$name =~ s/;$//;
		#print ":".$name.":\n";
#		$gene_pos{ $name."_".$fix }{"scaf"} = $arr[0];
                $gene_pos{ $name}{"scaf"} = $arr[0];
                $gene_pos{ $name}{"start"} = $arr[3];
#		$gene_pos{ $name."_".$fix }{"start"} = $arr[3];
	}else{
		next;
	}
}
close(IN);

open IN, $dFile or die $!;
open OUT, ">".$oFile or die $!;
while(<IN>){
	chomp;
	#ERM93380_Amt    453     1       453     +       ERM93380_Amt    453     1       453     1       944     1,453;  1,453;  +944;
	my @arr = split('\s+', $_);
	next if($arr[0] eq $arr[5]);
	#my $id1 = (split('\_', $arr[0]))[0];
	#my $id2 = (split('\_', $arr[5]))[0];
	my $flag = &check4dis($arr[0], $arr[5]);
	if($flag == 1){
		#print OUT $id1."\t".$id2."\n";
		#print OUT $gene_pos{$arr[0]}{"scaf"}."\t".$gene_pos{$arr[5]}{"scaf"}."\n";
		print OUT $_."\n";	
	}
}
close(IN);
close(OUT);

sub check4dis{
	my $id1 = shift;
	my $id2 = shift;
	my $flag = -1;
	if( $gene_pos{$id1}{"scaf"} ne $gene_pos{$id2}{"scaf"} ){
		return $flag;
	}
	my $dis = abs( $gene_pos{$id1}{"start"}-$gene_pos{$id2}{"start"} );
	if($dis < $cut4dis){
		return 1;
	}else{
		return -1;
	}
}


