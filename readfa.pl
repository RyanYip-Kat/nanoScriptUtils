=pod
use Getopt::Long;

my $fasta;
GetOptions(
        "fasta=s"=>\$fasta,
) or die $!;
print "$fasta\n";
=cut


my %hash_reads;
my $name;
open IN,"$ARGV[0]" or die $!;
while(<IN>){
    chomp;
    if(/^>(.*)$/){
        $name=$1;
        $hash_reads{$name}="";
    }else{
        $hash_reads{$name} .= $_;
    }
}
close IN;

foreach(keys(%hash_reads)){
        print "$_ => $hash_reads{$_}\n";
}
