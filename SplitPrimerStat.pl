#! /usr/bin/perl
use List::Util qw/max min/;
# Usage: "SplitPrimerStat.pl isoseq.PrimerStat.csv SplitStat.stat 
open IN,"$ARGV[0]";
readline IN;
$num_reads=0;$flnc=0;$nfc=0;$unknow=0;

while(<IN>){
	chomp;
	@a=();@a=split(/,/,$_);$slen=@a;
	# 0:SeqID;1:SeqClassify;2:SeqLength;11:PolyAtailLength
	if($a[3] eq "primer_S+"){
		if($a[1] eq "FL"){
		  $flnc+=1
	        }elsif($a[1] eq "NFL"){
		  $nfc+=1
	        }else{
		  $unknow+=1
	        }
	     	
	        $num_reads+=1;
	}
	#push @seqlen,$seqlen1;
}
close IN;

$flnc_ratio=sprintf("%.4f",$flnc/$num_reads);
$nfc_ratio=sprintf("%.4f",$nfc/$num_reads);
$unknow_ratio=sprintf("%.4f",$unknow/$num_reads);

open OUT,">".$ARGV[1];
print OUT "Total_Reads\tFLNC_Reads\tNFC_Reads\tUnknow_Reads\n$num_reads\t$flnc\t$nfc\t$unknow\n";
print OUT "FLNC_Ratio\tNFC_Ratio\tUnknow_Ratio\n$flnc_ratio\t$nfc_ratio\t$unknow_ratio\n";
