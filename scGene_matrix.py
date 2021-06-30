import argparse
from itertools import groupby
from collections import Counter, defaultdict

def load_tgsbcumi_fq(fastq,bc_len=24):
    id2bc=dict()
    id2umi=dict()
    with open(fastq,'r') as fin:
        lines = [fin.readline() for i in range(4)]
        while lines[0]:
            readid = lines[0].strip()[1:]
            barcode = lines[1].strip()[:bc_len]
            umi = lines[1].strip()[bc_len:]
            id2bc[readid]=barcode
            id2umi[readid]=umi
            lines = [fin.readline() for i in range(4)]

    fin.close()
    return  id2bc,id2umi


def load_tmap(tmap,tgsbc,tgsumi,class_code="ckmnjeo"):
    """
    tmap : flnc.filtered.tmap file from gffcompare
    tgsbc : tgs barcode dict from load_tgsbcumi_fq
    tgsumi : tgs umi dict from load_tgsbcumi_fq
    """
    #matrix = defaultdict(lambda: defaultdict(int))
    matrix = defaultdict(lambda: defaultdict(lambda : defaultdict(int)))
    tgsbccount = defaultdict(lambda: defaultdict(int))

    with open(tmap,'r') as fin:
        lines = fin.readlines()
        for line in lines:
            a=line.strip().split('\t')
            a[3]=a[3].replace(".m1","")
            if a[2] in class_code and a[3] in tgsbc and a[3] in tgsumi:
                bc=tgsbc[a[3]]
                umi=tgsumi[a[3]]
                matrix[a[0]][bc][umi]+=1
            if a[2] in class_code and a[3] in tgsbc and a[3] in tgsumi:
                bc=tgsbc[a[3]]
                umi=tgsumi[a[3]]
                geneumi=a[0]+umi
                tgsbccount[bc][geneumi]+=1
    fin.close()
    return matrix,tgsbccount

def tgstopK(tgsbccount,topbc=2500):
    """
    tgsbccount : tgsbccount from load_tmap
    topbc : topK bc to return
    """
    tgsbclist=defaultdict(int)
    tgs_bc= defaultdict(int)
    key1=list(tgsbccount.keys())
    
    for k1 in key1:
        bc1=list(tgsbccount[k1].keys())
        count1=len(bc1)
        tgsbclist[k1]+=count1

    mark=0
    tgsbc_list=sorted(tgsbclist.items(), key=lambda kv: kv[1], reverse=True)
    for x in tgsbc_list:
        mark+=1
        if mark <= topbc:
            tgs_bc[x[0]]=1
        else:
            break
    return tgs_bc


def getmatrix(matrix,tgsbccount,topbc=2500,outfile="gene.matrix.txt"):
    """
    matrix : matrix object from load_tmap
    tgsbccount : object from load_tmap
    outfile : file to save gene matrix
    """
    key1=list(matrix.keys())
    if topbc is not None:
        tgs_bc=tgstopK(tgsbccount,topbc)
        key2=list(tgs_bc.keys())
    else:
        key2=list(tgsbccount.keys())
    
    sk2=[]
    for k in key2:
        sk2.append(k)
    
    string2="\t".join(sk2)
    tgsbc= defaultdict(int)
    with open(outfile,"w") as fout:
        fout.write(string2+"\n")
        for k1 in key1:
            #fout.write(k1)
            s=[k1]
            for k2 in key2:
                k3=list(matrix[k1][k2])
                count=len(k3)
                tgsbc[k2]+=1
                #fout.write(str(count))
                s.append(str(count))
            fout.write("\t".join(s))
            fout.write("\n")
    fout.close()


if __name__=="__main__":
    parser = argparse.ArgumentParser(description='Get Count Matrix')
    parser.add_argument('-i','--bcumifq',type=str,default=None, help = 'Barcode UMI fastq file')
    parser.add_argument('-r','--tmap',type=str,default=None, help ='filter tmap file')
    parser.add_argument('-o','--outfile',type=str,default="gene.matrix.txt",help='gene.matrix.txt')
    parser.add_argument('-n','--bc_len',type=int,default=24,help="barcode length")
    parser.add_argument('--topbc',type=int,default=2500,help="top barcode to be write")
    parser.add_argument('--class_code',type=str,default="ckmnjeo")
    args = parser.parse_args()

    print("loading FLNC Barcode UMI Fastq")
    tgsbc,tgsumi=load_tgsbcumi_fq(args.bcumifq,args.bc_len)

    print("loading FLNC Filter Tmap file")
    matrix,tgsbccount=load_tmap(args.tmap,tgsbc,tgsumi,class_code=args.class_code)

    print("get gene matrix")
    getmatrix(matrix,tgsbccount,args.topbc,args.outfile)

