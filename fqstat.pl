#! /usr/bin/perl
use List::Util qw/max min/;

open IN,"$ARGV[0]";
@seqlen=();$sum_len=0;$num_seq=0;
while($id=<IN>){
	chomp $id;
	$seq=<IN>;chomp $seq;
	$mark=<IN>;
	$qv=<IN>;
	# $seqlen1=0;
	$seqlen1=length($seq);
	$sum_len+=length($seq);
	push @seqlen,$seqlen1;
=pod
	if($_=~/^>/){
		push @seqlen,$seqlen1 if($num_seq>0);
		$num_seq++;
		$seqlen1=0;
	}else{
		$seqlen1+=length($_);
		$sum_len+=length($_);
	}
	push @seqlen,$seqlen1 if eof;
=cut
}
close IN;

=pod
while($id=<IN>){
	chomp $id;
	$seq=<IN>;chomp $seq;
	$seqlen1=length($seq);
	$sum_len+=$seqlen1;
	$num_seq++;
	push @seqlen,$seqlen1;
}
close IN;
=cut

@sort_seqlen=sort{$b<=>$a} @seqlen;
$n=0;
foreach $k(@sort_seqlen){
	$n+=$k;
	if($n>=($sum_len/2)){
		$n50=$k;
		last;
	}
}

$num_seq=@sort_seqlen;
$maxlen=max(@sort_seqlen);
$minlen=min(@sort_seqlen);
$sum_mean_len=sprintf('%.2f',$sum_len/$num_seq);
$sum_len1=sprintf('%.2f',$sum_len/1000000000);
print "num_seq\ttotal_length\tmax_len\tmin_len\tmean_len\tn50_len\n$num_seq\t$sum_len1\t$maxlen\t$minlen\t$sum_mean_len\t$n50\n";
