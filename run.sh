GENOME="/home/ye/Data/10X/VDJ/ref/refdata-cellranger-GRCh38-3.0.0/fasta/genome.fa"
GTF="/home/ye/Data/10X/VDJ/ref/refdata-cellranger-GRCh38-3.0.0/genes/genes.gtf"
BIN="/home/ye/Work/BioAligment/Nanopore/Larry/scISA-Tools/bin/"
FASTQ="/home/ye/Work/BioAligment/Nanopore/Larry/shizhuoxing/scONT/RawData/ONT_T014_clean.fq"

# seqtk seq -a in.fq.gz > out.fa
#makeblastdb -in primer.fa -dbtype nucl
#blastn -query $FASTA -db primer.fa -outfmt 7 -word_size 5 > mapped.m7
#perl ${BIN}/classify_by_primer.pl -blastm7 mapped.m7 -ccsfq $FASTQ -min_primerlen 16 -min_seqlen  50 -outdir ./
#perl /home/ye/Work/BioAligment/Nanopore/Larry/shizhuoxing/classify_by_primer.singleron.v3.pl -blastm7 ONT_T014_clean.fa.m7 -ccsfq $FASTQ -min_primerlen 16 -min_seqlen  50 -outdir ./
perl classify_by_primer.singleron.v3.pl -blastm7 ONT_T014_clean.fa.m7 -ccsfq $FASTQ -min_primerlen 16 -min_seqlen  50 -outdir ./
minimap2 -ax splice -t 6 -uf --secondary=no -C5 -t 5 $GENOME isoseq_flnc.Transcript.fastq > isoseq_flnc.Transcript.sam
#perl ${BIN}/sam2gff.pl isoseq_flnc.Transcript.sam > isoseq_flnc.Transcript.gff
#gffcompare -r ${GTF} isoseq_flnc.Transcript.gff -o flnc
#perl ${BIN}/filter.tmap.pl isoseq_flnc.Transcript.gff.tmap > flnc.filtered.tmap

#/home/ye/Software/cellranger-3.1.0/miniconda-cr-cs/4.3.21-miniconda-cr-cs-c10/bin/python ${BIN}/cellBC_UMI_corrector.py -w celescope-bclist.txt -t 0.95 --input ONT_T014.isoseq_flnc.BarcodeUMI.fastq --tmap ONT_T014.flnc.filtered.tmap --output ./flnc.cellBC_UMI_correction.xls --cellranger_path /home/ye/Software/cellranger-3.1.0/

#perl ${BIN}/scGene_matrix.pl -tgsbcumi flnc.cellBC_UMI_correction.xls -tmap flnc.filtered.tmap -topbc 2500 -outdir ./ -sample TEST

#samtools view -bS isoseq_flnc.Transcript.sam  > isoseq_flnc.Transcript.bam
#samtools sort -@ 16  -o isoseq_flnc.Transcript.sorted.bam isoseq_flnc.Transcript.bam
#sort -k 3,3 -k 4,4n isoseq_flnc.Transcript.sam > isoseq_flnc.Transcript.sorted.sam
#collapse_isoforms_by_sam.py --input isoseq_flnc.BarcodeUMI.fastq --fq -b isoseq_flnc.Transcript.sorted.bam -o TEST --cpus 24 

#python /home/ye/Work/BioAligment/Nanopore/SQANTI3/sqanti3_qc.py ./TEST.collapsed.rep.fq $GTF $GENOME -d ./TEST --isoAnnotLite -t 30
#perl ${BIN}/scIsoform_matrix.pl -tgsbcumi flnc.cellBC_UMI_correction.xl -topbc 2500 -group TEST.collapsed.group.txt -minUMIcount 1 -outdir ./ -sample TEST
