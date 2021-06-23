$bc="CTAGGTACTTGATCTGCAGTTTATTGGTTTCA";
$bc1=substr($bc,0,2);
$bc2=substr($bc,6,2);
$bc3=substr($bc,12,2);
$bc4=substr($bc,18,2);
$bc5=substr($bc,24,2);
$bc6=substr($bc,30,2);
print "$bc\n";
print "$bc1\t$bc2\t$bc3\t$bc4\t$bc5\t$bc6\n";

open IN,"ONT_T014_Larry.fa";
@Index=();
@Header=();
@sequence=();
$target="CTNNNNACNNNNTCNNNNGTNNNNCANNNNCA";
$N=32;
while(<IN>){
     chomp;
     $seq=$_;
     if($seq=~/^>/){
         @a=();@a=split(/_/,$seq);
         $header=$seq;
         $idx=$a[2];
         push @Index,$idx;
         push @Header,$header;
     }else{
         push @sequence,$seq;
     }
}
close IN;
print "$Index[3]\n";
print "$Index[0]\n";
open OUT,">T014.LarryBC.fa";
$nlen=@sequence;
print "$nlen\n";
for($i=0;$i<$nlen;$i+=1){
    @a=();
    $seq=$sequence[$i];
    $idx=$Index[$i];
    $header=$Header[$i];
    $before=substr($seq,0,$idx);$after=substr($seq,$idx+$N);
    $a[0]=$before;$a[1]=$target;$a[2]=$after;
    $s1=join('',@a);
    print OUT "$header\n";
    print OUT "$s1\n";
    #$tag[2:6]="N";$tag[8:12]="N";$tag[14:18]="N";$tag[20:24]="N";$tag[26:30]="N";
    
}
close OUT;

 
