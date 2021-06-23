open IN,"larry.barcode.fasta";
while($id=<IN>){
	chomp $id;
	$larry_seq=<IN>;chomp $seq;
	$larry=substr($larry_seq,263,316-263);
	# print "$larry\n";
}
close IN;

open IN,"ONT_T015.isoseq_flnc.Transcript.larry.sam";
<IN>;<IN>;%lb=();
while(<IN>){
	@a=();@a=split(/\t/,$_);
	$bit=$a[1] & 0x10;
	# print "$a[0]\t$a[3]\t$a[5]\t$a[9]\n" if($a[3]<=264);
	# print "$a[0]\t$bit\t$a[3]\t$a[5]\t$a[9]\n" if($a[3]>=264);
	$ciga=$a[5];
	@g=();@g=split(/\D/,$ciga);
	$ciga=~s/^(\d+)//;
	@h=();@h=split(/\d+/,$ciga);
	# $clip=0;$sub=0;$ins=0;$del=0;$cov=0;
	
	$map="";$ref="";
	$end=0;$end+=$a[3];
	$pos=0;
	for($i=0;$i<=$#h;$i++){
		if ($h[$i] eq "I"){
			$pos+=$g[$i];
			# $map.=substr($a[9],$pos-$g[$i],$g[$i]);
		}elsif($h[$i] eq "D"){
			$end+=$g[$i];
			# $pos+=$g[$i];
			$map.=substr($larry_seq,$end-$g[$i]-1,$g[$i]);
		}elsif($h[$i] eq "M"){
			$end+=$g[$i];
			$pos+=$g[$i];
			$map.=substr($a[9],$pos-$g[$i],$g[$i]);
		}elsif($h[$i] eq "S" or $h[$i] eq "H"){
			$clip=0;$clip=$g[$i] if($i==0);
			$pos+=$clip;
			# $map=substr($a[9],$clip,0);
		}
	}
	
	$ref=substr($larry_seq,$a[3]-1,$end-$a[3]);
	# print "$a[0]\t$a[3]\t$end\t$a[5]\t$a[9]\n" if($a[3]<=264 and $end>=316);
	$l1=substr($map,316-$a[3]-43,44);
	$l2=substr($ref,316-$a[3]-43,44);
	# print "$a[0]\t$l1\t$map\n" if($a[3]<=264 and $end>=316);
	# print "$a[0]\t$l2\t$ref\n" if($a[3]<=264 and $end>=316);

	# ATNNNNCTNNNNACNNNNTCNNNNGTNNNNTGNNNNCANNNNCA
	# [0-2,6-8,12-14,18-20,24-26,30-32,36-38,42-44]
	$right=0;@str=();@str=split(//,$l1);
	$a1=substr($l1,0,2);$right++ if($a1 eq "AT");if($a1 ne "AT"){$str[0]="A";$str[1]="T";}
	$a2=substr($l1,6,2);$right++ if($a2 eq "CT");if($a2 ne "CT"){$str[6]="C";$str[7]="T";}
	$a3=substr($l1,12,2);$right++ if($a3 eq "AC");if($a3 ne "AC"){$str[12]="A";$str[13]="C";}
	$a4=substr($l1,18,2);$right++ if($a4 eq "TC");if($a4 ne "TC"){$str[18]="T";$str[19]="C";}
	$a5=substr($l1,24,2);$right++ if($a5 eq "GT");if($a5 ne "GT"){$str[24]="G";$str[25]="T";}
	$a6=substr($l1,30,2);$right++ if($a6 eq "TG");if($a6 ne "TG"){$str[30]="T";$str[31]="G";}
	$a7=substr($l1,36,2);$right++ if($a7 eq "CA");if($a7 ne "CA"){$str[36]="C";$str[37]="A";}
	$a8=substr($l1,42,2);$right++ if($a8 eq "CA");if($a8 ne "CA"){$str[42]="C";$str[43]="A";}
	
	# print "$a[0]\t$l1\n" if($a[3]<=264 and $end>=316 and $right>=6);
	$s1=join('',@str);
	# print "$a[0]\t$s1\t$a1\t$str[0] $str[1]\n";
	$lb{$a[0]}=$s1 if($a[3]<=264 and $end>=316 and $right>=6);
	
	# print "$a[0]\tread\t$l1\n" if($a[3]<=264 and $end>=316);
	# print "$a[0]\tref\t$l2\n" if($a[3]<=264 and $end>=316);
}
close IN;

open IN,"ONT_T015.isoseq.PrimerStat.csv";
while(<IN>){
	chomp;
	@a=();@a=split(/\,/,$_);
	print "$a[0]\t$lb{$a[0]}\t$a[9]\t$a[10]\n" if(defined $lb{$a[0]});
}
close IN;
