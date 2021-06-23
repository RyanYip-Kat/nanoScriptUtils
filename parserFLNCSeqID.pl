#! /usr/bin/perl
use List::Util qw/max min/;
# Usage: " iparserFLNCSeqID.pl soseq.PrimerStat.csv SplitStat.stat 
open IN,"$ARGV[0]";
readline IN;

open OUT,">".$ARGV[1];
while(<IN>){
	chomp;
	@a=();@a=split(/,/,$_);$slen=@a;
        # 0:SeqID;1:SeqClassify;2:SeqLength;11:PolyAtailLength
        if($a[1] eq "FL"){
		print OUT "$a[0]\n";

	}
	     	
}
close IN;
close OUT;
