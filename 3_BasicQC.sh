###Step 3: Basic SNP level QC
./plink --bfile ABCD_release_2.0.1_r1 --geno 0.1  --make-bed --out QC1output

###Step 4: Basic individual level QC 
./plink --bfile QC1output --mind 0.05 --me 0.05 0.1  --make-bed --out QC2output
./plink --bfile QC2output --check-sex --out QC2checksex

R 
sex = read.delim("QC2checksex.sexcheck", sep = "")
head(sex)
sexproblem = subset(sex, STATUS == "PROBLEM")
sex2 = sexproblem[,c(1:2)]
write.table(sex2, file = "failedsample.txt", row.names = F, col.names = T, quote = F)
q()
n

./plink --bfile QC2output --remove failedsample.txt --make-bed --out QC3output
