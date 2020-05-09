## These are the post-imputation steps for ABCD. You have download and unzip all the files except for the VCF files.
# Step 1: Extract SNPs with MAF > 0.1% and r2 > 0.3

library(data.table)
for (i in 1:22){
  a = read.table(paste0("chr", i, ".info"), header = T)
  a$Rsq = as.numeric(as.character(a$Rsq))
  b = subset(a, Rsq > 0.3)
  b = subset(b, ALT_Frq > 0.001 & ALT_Frq < 0.999)
  write.table(b[,1], file = paste0("chr", i, "extract.txt"), row.names = F, col.names = T, quote = F)
}
