@Seqs=();
open IN,"NFL.SeqID";
while(<IN>){
	chomp;
	$seq=$_;
	@a=();@a=split(/\//,$seq);
        push @Seqs,$a[0];
	}
close IN;

#=pod
$num_seq=0;
open IN,"$ARGV[0]";
open OUT,">$ARGV[1]";
while($id=<IN>){
	chomp $id;
	@a=();@a=split(/ /,$id);
        $name=$a[0];
        $name=~s/^@//;
	#print "$name\n";
	if( $name ~~ @Seqs ){
		print OUT "$id\n";
		$num_seq+=1;
	}

}
close IN;
close OUT;
#=cut
print "num_seqs\t$num_seq\n";
