open IN,"all.collapsed.group.txt";
%matrix=();%tgsbccount=();
while(<IN>){
	#chomp;
	$seq=$_;chomp $seq;
        @a=();@a=split(/\s/,$seq);
        @b=();@b=split(/\,/,$a[1]);
	print "$a[0]\n";
}
close IN;



