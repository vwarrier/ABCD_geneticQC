###Step 5: Run PC in Genesis

## 5.1: Load packages

library(GWASTools)
library(GENESIS)
library(SNPRelate)

## 5.2: Read files and prune SNPs for LD

snpgdsBED2GDS(bed.fn = "QC3_KGref_pass3.bed", 
              bim.fn = "QC3_KGref_pass3.bim", 
              fam.fn = "QC3_KGref_pass3.fam", 
              out.gdsfn = "QC3_KGref_pass3.gds")


gds <- snpgdsOpen("QC3_KGref_pass3.gds")
snpset <- snpgdsLDpruning(gds, method="corr", slide.max.bp=10e6, 
                          ld.threshold=sqrt(0.1), verbose=FALSE)
pruned <- unlist(snpset, use.names=FALSE)
length(pruned)

snpgdsClose(gds)

## 5.3 Read the kinship matrix, and run PC
KINGmat <- kingToMatrix(c("QC3_KGref_pass3_kinship.kin0","QC3_KGref_pass3_kinship.kin"))
KINGmat[1:5,1:5]

data1 <- GdsGenotypeReader(filename = "QC3_KGref_pass3.gds")
data2 <- GenotypeData(data1)
data2

mypcair <- pcair(data2, kinobj = KINGmat, divobj = KINGmat,
                 snp.include = pruned)


PC = data.frame(mypcair$vectors)
PC$Sample_name = row.names(PC)

save(PC, file = "PC.RData")


