#!/usr/bin/env perl

=head1 Name 

	TDgene.pl 	get tandem duplication genes by searching the genome sequence

=head1 Description

	This script is used to find TD genes in whole genome. pep and gff file are needed. Five steps are contained.
	The first step is blast, you can choose the E_value if you wanna, result of this step is blast's result(m8 format). Second step is extract the result of blast, two paramaters you can choose are E_value and Identity. Solar is used in third step. Extracting the solar's result in fourth step. TD genes are identited in fifth step.

=head1 Command-line Options

	perl TDgene.pl <pep.file> <gff3file> options
	--Evalue 	set the parameter when blast (default 1e-7)
	--choose_evalue	set the parameter when extracting result of blast(default 3e-25)
	--identity	the parameter when extracting result of blast(default 60)
	--step		the parameter if you wanna running particular step(default 12345)
	--first_len	the parameter is setted when extracting the result of solar(first pep's length)(default 50)
	--second_len	the parameter is setted when extracting the result of solar(second pep's length)(default 50)
	--dis		two genes would be identified TD gene if the distance is shorter than this parameter(default 100000)
	--clean		delete temporary files, default not
	--verbose	output verbose information to screen
	--help		output help information to screen

Note:the pepid must to been consistent with ID in gff3 file.
like this:
	>evm.model.scaffold30151.1
	MSDYFPPELLAEILSRLPVKSLIRFATVCKSWHSLISNPKFISSHLSNCKNKKTTLLLRR

scaffold30151   .       mRNA    74937   76539   .       -       .       ID=evm.model.scaffold30151.1;Parent=evm.TU.scaffold30151.1;Name=EVM%20prediction%20scaffold30151.1

=head1 Example

	perl TDgene.pl pep.fa Cra.gff3 
	perl TDgene.pl pep.fa Cra.gff3 -Evalue 1e-8 -choose_evalue 1e-25 -identity 70 -dis 150000 -clean

=cut
	
use Getopt::Long;
use FindBin qw($Bin);
use Data::Dumper;

my ($evalue,$choose_evalue,$identity,$step,$len1,$len2,$dis,$clean,$Verbose,$Help);
GetOptions(
	"Evalue=s"=>\$evalue,
	"choose_evalue=s"=>\$choose_evalue,
	"identity=s"=>\$identity,
	"step=s"=>\$step,
	"first_len=i"=>\$len1,
	"second_len=i"=>\$len2,
	"dis=i"=>\$dis,
	"clean"=>\$clean,
	"verbose!"=>\$Verbose,
	"help!"=>\$Help
);

die `pod2text $0` if (@ARGV == 0 || $Help);

$evalue ||= 1e-7;
$choose_evalue ||= 3e-25;
$identity ||= 60;
$len1 ||= 50;
$len2 ||= 50;
$step ||= 12345;
$dis ||= 100000;
my $pep = shift;
my $gff = shift;

open LOG,">monitor.log" or die $!;
if($step =~ /1/){
	print LOG "STEP1 Begin at:\t".`date`."\n";
	`/blast-2.2.26/bin/formatdb -i $pep -p T`;
	`/blast-2.2.26/bin/blastall -p blastp -i $pep -d $pep -m 8 -e $evalue -o blast.result`;
	print LOG "STEP1 End at:\t".`date`."\n";
}

if($step =~ /2/){
	print LOG "STEP2 Begin at:\t".`date`."\n";
	`perl $Bin/evalue_para.pl blast.result $choose_evalue $identity`;
	print LOG "STEP2 End at:\t".`date`."\n";
}

if($step =~ /3/){
	print LOG "STEP3 Begin at:\t".`date`."\n";
	`$Bin/solar.pl -a prot2prot -z -f m8 blast.result.2 > blast.solar`;
	print LOG "STEP3 End at:\t".`date`."\n";
}

if($step =~ /4/){
	print LOG "STEP4 Begin at:\t".`date`."\n";
	`perl $Bin/solar_len.pl blast.solar $len1 $len2 > blast.solar.2`;
	print LOG "STEP4 End at:\t".`date`."\n";
}


if($step =~ /5/){
	print LOG "STEP5 Begin at:\t".`date`."\n";
	`perl $Bin/take4distance.pl $gff blast.solar.2 $dis blast.solar.2.dis`;
	`perl $Bin/get_TD_gene.pl blast.solar.2.dis > TD_gene.result`;
	print LOG "STEP5 End at:\t".`date`."\n";
}

if($clean){
	`rm blast*`;
	`rm $pep.*`;
	`rm formatdb.log`;
}

print LOG "All job End at:\t".`date`."\n";
close LOG;
