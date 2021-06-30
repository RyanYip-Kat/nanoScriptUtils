#! /usr/bin/perl
use PerlIO::gzip;
use Getopt::Long;
use File::Basename;
use FindBin '$Bin';
use Cwd qw(abs_path);
sub usage {
    print STDERR<< "USAGE";

Despriprion: BGI version's scIsoSeq isoform expression count matrix generation program.
Usage: perl $0 -tmap flnc.filtered.tmap -tgsbcumi flnc.BarcodeUMI.fastq -group collapsed.group.txt -topbc 2000 -sample test -outdir ./

Options:
        -tgsbcumi*:             flnc.BarcodeUMI.fastq from classify_by_primer.pl
	-tmap*:                 flnc.filtered.tmap file from filter.tmap.pl
        -group*:                collapsed.group.txt file from cDNA_cupcake 
        -topbc*:                top rank expression cellBC for tgs, mutex with -ngsbc
	-minUMIcount		filter out the minimum umi count isoform
        -sample*:               sample name
        -outdir*:               output directory
        -help:                  print this help
USAGE
    exit 0;
}

GetOptions(
        "tmap:s" => \$tmap,
        "tgsbcumi:s" => \$tgsbcumi,
        "group:s" => \$group,
        "topbc:s" => \$topbc,
        "minUMIcount:s" => \$minUMIcount,
        "sample:s" => \$sample,
        "outdir:s" => \$outdir,
        "help:s" => \$help
);
die &usage() if ((!defined $tgsbcumi) or (!defined $tmap) or (!defined $group) or (!defined $minUMIcount) or (!defined $sample) or (defined $help));

# load tgs barcode umi
open IN,"$tgsbcumi";
%tgsbc=();%tgsumi=();
while(<IN>){
        chomp;
        $seq=$_;
        $a=$seq;
        if($seq=~/^[ATCG]/){
                $bc=substr($seq,0,24);
                $umi=substr($seq,24);
        }

        if(!defined $tgsbc{$a} and $a=~/^@/){
                $a=~s/@//;
                $tgsbc{$a}=$bc;
                $tgsumi{$a}=$umi;
        }
}
close IN;

# load group 
open IN,"$group";
%groupbcgene=();
while(<IN>){
	chomp;
	@a=();@a=split;  # pb :isoform
	@b=();@b=split(/\,/,$a[1]); # b : seqid
        $i=1;
        foreach $k(@b){
	        $groupbcgene{$k}=$a[0]."_$i";
	        $i+=1;
	}
}

#load tmap
open IN,"$tmap";
%matrix=();%tgsbccount=();
while(<IN>){
	chomp;
	@a=();@a=split(/\t/,$_);
	$a[3]=~s/.m1//;
	if($a[0] ne "-"){
		if(defined $tgsbc{$a[3]}){
			$bc=$tgsbc{$a[3]};
			$umi=$tgumi{$a[3]};
                        if(defined $groupbcgene{$a[3]}){
				$x=$a[0]."($groupbcgene{$a[3]})";
			}else{
				$x=$a[0];
			}
			$matrix{$x}{$bc}{$umi}++;
			$isoumi="$x.$umi";
			$tgsbccount{$bc}{$isoumi}++;
		}
	}
}
close IN;


#%
%tgsbclist=();%tgs_bc=();
@key1=();@key1=keys %tgsbccount;
foreach $k1(@key1){
	@bc1=();@bc1=keys %{$tgsbccount{$k1}};
        $count1=@bc1;
        $tgsbclist{$k1}+=$count1;
}
        
$mark=0;
foreach $k(sort {$tgsbclist{$b} <=> $tgsbclist{$a}} keys %tgsbclist){
	$mark++;
        $tgs_bc{$k}=1 if($mark<=$topbc);
        last if($mark>=$topbc);
}

@key1=();@key1=keys %matrix;
@key2=keys %tgs_bc;

open OUT1,">$outdir/$sample.isoform.matrix";
foreach $k2(@key2){
    $str.="\"$k2\",";
}
$str=~s/\,$//;
print OUT1 "$str\n";

foreach $k1(@key1){
    $exp_sum=0;
    $str="\"$k1\"";
    foreach $k2(@key2){
        if(defined $matrix{$k1}{$k2}){
		@key3=();@key3=keys %{$matrix{$k1}{$k2}};
            	$exp=@key3;
            	$str.="\,$exp";
            	$exp_sum+=$exp;
        }else{
            	$str.="\,0";
        }
    }
    print OUT1 "$str\n" if($exp_sum>=$minUMIcount);
}
