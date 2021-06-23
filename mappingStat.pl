#! /usr/bin/perl
# Usage: mappingStat.pl ONT_T014.isoseq_flnc.Transcript.sam  MappingStat.stat
open IN,"$ARGV[0]";
$total_reads=0;
$star_reads=0;
$mt_reads=0;   #  MT chrom reads
$chr_reads=0;
while($id=<IN>){
	chomp $id;
	@a=();@a=split(/\t/,$id);
	$seq=$a[0];
	if($seq=~/_CCS/){
		$total_reads+=1;
		if($a[2] eq "*"){
			$star_reads+=1;
		}elsif($a[2] eq "MT"){
			$mt_reads+=1;
		}else{
			$chr_reads+=1;
		}
	}
}
close IN;
$map_reads=$mt_reads+$chr_reads;
$star_ratio=sprintf("%.4f",$star_reads/$total_reads);
$mt_ratio=sprintf("%.4f",$mt_reads/$total_reads);
$chr_ratio=sprintf("%.4f",$chr_reads/$total_reads);
$map_ratio=sprintf("%.4f",$map_reads/$total_reads);
$total_ratio=sprintf("%.4f",1);
open OUT,">".$ARGV[1];
print OUT "TotalReads\tMapReads\tChrReads\tMtReads\tUnkonwReads\n";
print OUT "$total_reads\t$map_reads\t$chr_reads\t$mt_reads\t$star_reads\n";
print OUT "$total_ratio\t$map_ratio\t$chr_ratio\t$mt_ratio\t$star_ratio\n";
close OUT;


