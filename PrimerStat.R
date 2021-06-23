library(argparse)
library(stringr)
library(data.table)

parser <- ArgumentParser(description='Process some tasks')
parser$add_argument("-f","--filename",type="character",default=NULL,help="isoseq.PrimerStat.csv")
parser$add_argument("-o","--outdir",type="character",default="result",help="path to save result")
args <- parser$parse_args()

if(!dir.exists(args$outdir)){
        dir.create(args$outdir,recursive=TRUE)
}


outdir=args$outdir
print("Loading data...")
DATA=fread(args$filename)

Total_reads=nrow(DATA)
Total_read_Classify=table(DATA$SeqClassify)
Total_FL_reads=Total_read_Classify["FL"]
Total_NFL_reads=Total_read_Classify["NFL"]
Total_UNKNOW_reads=Total_read_Classify["UNKNOW"]

TotalTable=data.frame("Reads"=c(Total_reads,Total_FL_reads,Total_NFL_reads,Total_UNKNOW_reads))
TotalTable$Ratio=round(TotalTable$Reads/Total_reads,4)
rownames(TotalTable)=c("Total","FLNC","NFL","UNKNOW")
write.table(TotalTable,file.path(outdir,"TotalStat.csv"),sep=",",quote=F)
df=table(DATA$Primer1,DATA$Primer2,DATA$SeqClassify)
write.table(df,file.path(outdir,"PrimerCrossTable.csv"),row.names=F,sep=",",quote=F)

#####################
primers=c("primer_F+","primer_S-","primer_S+","primer_F-")
for(p1 in primers){
	for(p2 in primers){
		cat(sprintf(" Primer1 :%s --- Primer2 :%s\n",p1,p2))
		DF=subset(DATA,Primer1==p1 & Primer2==p2)
	        N=nrow(DF)
	        dfTable=table(DF$SeqClassify)
	        dfTable=as.data.frame(as.matrix(dfTable))
	        dfTable$Ratio=round(dfTable$V1/N,4)
	        colnames(dfTable)=c("Reads","Ratio")
	        write.table(dfTable,file.path(outdir,paste0(p1,"_",p2,"_PrimerStat.csv")),row.names=TRUE,sep=",",quote=F)
}
}



