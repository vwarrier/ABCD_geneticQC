###Step 1: Update the fam file
## Sex info isn't provided in the fam file
fam = fread("ABCD_release_2.0.1_r1.fam")
fam$id = 1:nrow(fam)


abcd_genomics_info = fread("abcd_ygs01.txt")
abcd_genomics_info = abcd_genomics_info[-1,]
abcd_genomics_info$gender2 = ifelse(abcd_genomics_info$gender == "M", 1, 2)
abcd_genomics_info$gender2 = ifelse(abcd_genomics_info$gender == "F", 2, abcd_genomics_info$gender2)
abcd_genomics_info$gender2 = ifelse(abcd_genomics_info$gender == "", 0, abcd_genomics_info$gender2)

abcd_geno = abcd_genomics_info[,c("subjectkey", "gender2")]
merged = merge(fam, abcd_geno, by.x = "V2", by.y = "subjectkey")
merged = merged[order(merged$id), ]
fam2 = merged[,c("V1", "V2", "V3", "V4", "gender2", "V6")]
write.table(fam2, file = "~/ABCD/ABCDgenotype/Genotype_preimputation/ABCD_release_2.0.1_r1.fam", row.names = F, col.names = F, quote = F)
