@numberDict=();
foreach $k ( 1..24 ){
       if($k%4==0){
          $tag="A";
       }elsif($k%4==1){
          $tag="T";
       }elsif($k%4==2){
          $tag="C";
       }elsif($k%4==3){
          $tag="G";
       }else{
          $tag="N";
       }
       push @numberDict,$tag;
}
$stringr=join("",@numberDict);
print "$stringr\n";


sub max{
	my($max_so_far)=shift @_;# the first one is the largest yet seen
	foreach (@_){
		if($_ > $max_so_far){
			$max_so_far=$_;
		}
	}
	$max_so_far;
}

$maximum = &max(3, 5, 10, 4, 6);
print "\$maximum = $maximum\n";
       
       
        

