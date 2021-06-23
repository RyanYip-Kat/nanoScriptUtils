$l2="ATNNNNCTNNNNACNNNNTCNNNNGTNNNNTGNNNNCANNNNCA";
# [0-2,6-8,12-14,18-20,24-26,30-32,36-38,42-44]
$a1=substr($l2,0,2);
$a2=substr($l2,6,2);
$a3=substr($l2,12,2);
$a4=substr($l2,18,2);
$a5=substr($l2,24,2);
$a6=substr($l2,30,2);
$a7=substr($l2,36,2);
$a8=substr($l2,42,2);
print "$l2\n$a1 $a2 $a3 $a4 $a5 $a6 $a7 $a8\n";


open IN,"larry.barcode.fasta";
while($id=<IN>){
        chomp $id;
        $larry_seq=<IN>;chomp $seq;
        $larry=substr($larry_seq,263,316-263);
        print "$larry\n";
}
close IN;
