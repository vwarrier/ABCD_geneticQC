library(data.table)
bim22 = fread("./Plink_files/ABCD_chr22.bim")
bim22$CHROM_POS = paste(bim22$V1, bim22$V4, sep = ":")
bim22_update = bim22[, c("CHROM_POS", "V2")]
update = bim22_update

for (i in 1:21){
  bim = fread(paste0("./Plink_files/ABCD_chr", i, ".bim"))
  bim$CHROM_POS = paste(bim$V1, bim$V4, sep = ":")
  bim_update = bim[, c("CHROM_POS", "V2")]
  update = rbind(update, bim_update)
}

plink_recoding = fread("plinkrecodingfile.txt")
plink_recoding_file = merge(plink_recoding, update, by.x = "#CHROM:POS", by.y = "CHROM_POS")
plink_recoding_file = plink_recoding_file[!duplicated(plink_recoding_file$V2), ]

write.table(plink_recoding_file[,c("V2", "ID")], file = "plinkrecodingfile2.txt", col.names = T, row.names = F, quote = F)