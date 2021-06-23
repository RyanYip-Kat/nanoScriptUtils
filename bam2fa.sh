samtools view ONT_T014.isoseq_flnc.Transcript.sorted.bam -O SAM |  awk -F"\t" '{print ">"$1"\n"$10}' > ONT_T014.isoseq_flnc.Transcript.fasta 
