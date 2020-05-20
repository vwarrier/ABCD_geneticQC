library(GWASTools)
library(GENESIS)
library(SNPRelate)

## 5.2: Read files and prune SNPs for LD

snpgdsBED2GDS(bed.fn = "QC5output_forPC.bed", 
              bim.fn = "QC5output_forPC.bim", 
              fam.fn = "QC5output_forPC.fam", 
              out.gdsfn = "QC5output.gds")


gds <- snpgdsOpen("QC5output.gds")
snpset <- snpgdsLDpruning(gds, method="corr", slide.max.bp=10e6, 
                          ld.threshold=sqrt(0.1), verbose=FALSE)
pruned <- unlist(snpset, use.names=FALSE)
length(pruned)

snpgdsClose(gds)

## 5.3 Read the kinship matrix, and run PC
KINGmat <- kingToMatrix(c("QC5output_kinship.kin0","QC5output_kinship.kin"))
KINGmat[1:5,1:5]

data1 <- GdsGenotypeReader(filename = "QC5output.gds")
data2 <- GenotypeData(data1)
data2

mypcair <- pcair(data2, kinobj = KINGmat, divobj = KINGmat,
                 snp.include = pruned)


PC = data.frame(mypcair$vectors)
PC$Sample_name = row.names(PC)

save(PC, file = "PC.RData")

PC2 = PC[,c(33, 1:32)]
head(PC2)

write.table(PC2, file = "ABCD_PCsforGWAS.txt", row.names = F, col.names = T, quote = F)