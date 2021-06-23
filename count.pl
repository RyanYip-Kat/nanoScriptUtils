open IN,"ONT_T014_clean.fa.m7";
%id=();$count=0;
while(<IN>){
	chomp;
	@a=();@a=split(/\t/,$_);
	if($_!~/^#/){
		$count++ if(!defined $id{$a[0]});
		$id{$a[0]}=1;
	}
}
close IN;

print "$count\n";
