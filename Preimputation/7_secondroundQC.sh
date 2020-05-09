### Second round of SNP level QC - HWE at a sample level
./plink --bfile QC3output --keep keep_American.txt --hwe 0.000001  --make-bed --out QC3_american
./plink --bfile QC3output --keep keep_African.txt --hwe 0.000001  --make-bed --out QC3_african
./plink --bfile QC3output --keep keep_Bengali.txt --hwe 0.000001  --make-bed --out QC3_bengali
./plink --bfile QC3output --keep keep_SouthAsian.txt --hwe 0.000001  --make-bed --out QC3_southasian
./plink --bfile QC3output --keep keep_EastAsian.txt --hwe 0.000001  --make-bed --out QC3_eastasian
./plink --bfile QC3output --keep keep_European.txt --hwe 0.000001  --make-bed --out QC3_european
./plink --bfile QC3output --keep keep_Finnish.txt --hwe 0.000001  --make-bed --out QC3_finnish



### Second round fo Sample level QC - Excessive heterozygosity
for i in QC3_american QC3_african QC3_bengali QC3_southasian QC3_eastasian QC3_european QC3_finnish; do ./plink --bfile ${i} --het --out check_het${i}; done

## In R
R
het_check = function (input){ 
  het = read.delim(input, sep = "")
  het$HET = (het$N.NM. - het$O.HOM.)/het$N.NM. #create heterozygosity stats
  mean = mean(het$HET)
  sd = sd(het$HET)
  het$Z = (het$HET - mean)/sd #create Z scores of heterozygosity
  hetoutlier = subset(het, abs(Z) > 3)
  failedsample = hetoutlier[,c(1:2)]
  write.table(failedsample, file = paste0(input, "het.txt"), row.names = F, col.names = T, quote = F)
}


filelist = list("check_hetQC3_southasian.het", "check_hetQC3_bengali.het", "check_hetQC3_eastasian.het",
                "check_hetQC3_european.het", "check_hetQC3_african.het", "check_hetQC3_finnish.het",
                "check_hetQC3_american.het")

lapply(filelist,het_check)

q()
n

##In Plink
for i in american african bengali southasian eastasian european finnish; do ./plink --bfile QC3_${i} --remove check_hetQC3_${i}.hethet.txt --make-bed --out QC4_${i}; done

