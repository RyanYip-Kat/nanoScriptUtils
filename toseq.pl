open IN,"$ARGV[0]";
while(<IN>){
	chomp;
	$seq=$_;
	@a=();@a=split(/\//,$seq);
        print "$a[0]\n";
	}
close IN;

