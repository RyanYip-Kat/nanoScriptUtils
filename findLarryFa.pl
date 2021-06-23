$header="ACGGTGGCGATATCGGATCC";
$tailer="CATATGGTCTCTCCTAGCAA";

open IN,"$ARGV[0]";
open OUT,">$ARGV[1]";
$num_seq=0;
$num_larry=0;
@larry=();

while(<IN>){
	chomp;
	$seq=$_;
	if($seq!~/^>/){   # not header >
		$n=length($seq);
		$num_seq+=1;
		if($seq=~/ACGGTGGCGATATCGGATCC/){
			$hloc=index($seq,"ACGGTGGCGATATCGGATCC");
			$hn=$hloc+20;
			if($seq=~/CATATGGTCTCTCCTAGCAA/){
				$tloc=index($seq,"CATATGGTCTCTCCTAGCAA");
				$lap=$tloc-$hn;
				if($lap>=32){
					$larrybc=substr($seq,$hn,$lap);

					if($larrybc=~/[A-Z]{4,}CT[A-Z]{4}AC[A-Z]{4}TC[A-Z]{4}GT[A-Z]{4}TG[A-Z]{4}CA[A-Z]{4,}/){
						$larrybc=~/CT[A-Z]{4}AC[A-Z]{4}TC[A-Z]{4}GT[A-Z]{4}TG[A-Z]{4}CA/;
						$bc=$&;
						$bci=index($seq,$bc);
						#$bcie=$bci+length($&);
						print OUT ">LarryBC_$&_$bci\n";
						print OUT "$seq\n";
						$num_larry+=1;
					}
				}
			}
		}
	}
}
close IN;
close OUT;
print "seq_number :\t$num_seq\tlarry_barcode_number :$num_larry\n";

