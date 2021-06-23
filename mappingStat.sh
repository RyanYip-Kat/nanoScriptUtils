awk -F "\t" '{print}' ONT_T014.isoseq_flnc.Transcript.sam | grep -E "*_CCS" | awk '{print $1,$3}' >  CCS.Chrs
awk -F "\t" '{print}' CCS.Chrs | grep "*" > CCS.star
awk -F "\t" '{print}' CCS.Chrs | grep "MT" > CCS.MT

