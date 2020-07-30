# These are the steps involved in the post-imputation of the ABCD dataset.

Before embarking on this, please unzip all the files. 

## Step 1: Create a list of SNPs with acceptable QC stats
We will create a list of SNPs which have a MAF > 0.1% and Imputation R2 > 0.3. Let's do this in R (1a_ExtractSNPs.R).

Using this, we will then create plink binary files from the vcfs (1b_ExtractSNPs.sh)

## Step 2: Update the SNP names
The SNP names provided do not rsIDs, but instead have Chr:Post:Allele format. We need to change this to make this into rsids.
To do this, let's have a look at where the files are available. 

Details are available here: https://www.ncbi.nlm.nih.gov/variation/docs/human_variation_vcf/
Download the right file from: ftp://ftp.ncbi.nih.gov/snp/organisms/human_9606_b150_GRCh38p7/VCF/

```{bash}
run 2a_update.sh
```
```{bash}
Rscript 2b_updatenames.R
```

```{bash}
run 2c_updatenames.R
```
## Step 3: Update family names
```{R}
library(data.table)
library(tidyr)


fileimputed = fread("./Plink_files/ABCD_chr1_v2.fam")
fileimputed$oldFID = fileimputed$V1
fileimputed$oldIID = fileimputed$V2


fileimputed = fileimputed %>% separate(V2, into = c('FID', 'IID'), sep = 10)
fileimputed$FID = substr(fileimputed$FID,1,nchar(fileimputed$FID)-1)

write.table(fileimputed[,c("oldFID", "oldIID", "FID", "IID")], file = "updatefamenames.txt", row.names = F, col.names = F, quote = F)
```
```{bash}
for i in {1..22}; do ./plink --bfile ./Plink_files/ABCD_chr${i}_v2  --update-ids updatefamenames.txt --make-bed --out ./Plink_files/ABCD_chr${i}_v3; done
```
## Step 4: Liftover to hg19
Get the chain file, get liftover and liftoverplink.py into the same folder as all other files

```{bash}
# Convert plink binary to map and ped
for i in {1..22}; do ./plink --bfile ./Plink_files/ABCD_chr${i}_v3  --recode --out ./Plink_files/ABCD_chr${i}_v4; done

# Run liftover
for i in {1..22}; do python2 liftOverPlink.py -m ./ABCD_chr${i}_v4.map -p ./ABCD_chr${i}_v4.ped  -o ./ABCD_chr${i}_hg19 -e ./liftOver -c ./hg38ToHg19.over.chain.gz; done
```


## Step 5: Convert to bed and remove final incosistencies
We need to convert it to bed and remove some incosistencies in chromosome names

```{bash}
for i in {1..22}; do ./plink --file ABCD_chr{i}_hg19 --make-bed --out ABCD_chr${i}_hg19 --allow-extra-chr; done
```

```{R}
for (i in 1:22){
  data1 = fread(paste0("~/ABCD/ABCDgenotype/Genotype_postimputation/TOPMED/Plink_files/ABCD_chr",i,"_hg19.bim"))
  subset(data1, V1 == i)
  write.table(data1, file = paste0("~/ABCD/ABCDgenotype/Genotype_postimputation/TOPMED/Plink_files/ABCD_chr",i,"_hg19.bim"), row.names = F, col.names = F, quote = F)
}
```

# Step 6: Repeat the whole process for the X chromosome
## In R
```{R}
  a = fread("chrX.info", header = T)
  a$Rsq = as.numeric(as.character(a$Rsq))
  b = subset(a, Rsq > 0.3)
  b = subset(b, ALT_Frq > 0.001 & ALT_Frq < 0.999)
  write.table(b[,1], file = "chrXextract.txt", row.names = F, col.names = T, quote = F)
```

## In bash
```{bash}
 ./plink --vcf chrX.dose.vcf.gz --make-bed --out ./Plink_files/ABCD_chrX  --extract chrXextract.txt --const-fid 0
``` 
 ## In R
 ```{R}
library(data.table)
bimX = fread("./Plink_files/ABCD_chrX.bim")
bimX$CHROM_POS = paste(bimX$V1, bimX$V4, sep = ":")
bimX_update = bimX[, c("CHROM_POS", "V2")]
update = bimX_update
update$CHROM_POS = gsub("23:", "X:",update$CHROM_POS)


plink_recoding = fread("plinkrecodingfile.txt")
plink_recoding_file = merge(plink_recoding, update, by.x = "#CHROM:POS", by.y = "CHROM_POS")
plink_recoding_file = plink_recoding_file[!duplicated(plink_recoding_file$V2), ]

write.table(plink_recoding_file[,c("V2", "ID")], file = "plinkrecodingfile2_forX.txt", col.names = T, row.names = F, quote = F)
```
## In bash
```{bash}
./plink --bfile ./Plink_files/ABCD_chrX  --update-name plinkrecodingfile2_forX.txt --make-bed --out ./Plink_files/ABCD_chrX_v2
./plink --bfile ./Plink_files/ABCD_chrX_v2  --update-ids updatefamenames.txt --make-bed --out ./Plink_files/ABCD_chrX_v3
./plink --bfile ./Plink_files/ABCD_chrX_v3  --recode --out ./Plink_files/ABCD_chrX_v4
```

You need to update the chromosome in the map file from 23 to X. Do it in R. 

```{bash}
python2 liftOverPlink.py -m ./ABCD_chrX_v4.map -p ./ABCD_chrX_v4.ped  -o ./ABCD_chrX_hg19 -e ./liftOver -c ./hg38ToHg19.over.chain.gz
./plink --file ABCD_chrX_hg19 --make-bed --out ABCD_chrX_hg19 --allow-extra-chr
```

## In R
```{R}
data1 = fread("~/ABCD/ABCDgenotype/Genotype_postimputation/TOPMED/Plink_files/ABCD_chrX_hg19.bim")
subset(data1, V1 == X)
write.table(data1, file = "~/ABCD/ABCDgenotype/Genotype_postimputation/TOPMED/Plink_files/ABCD_chrX_hg19.bim"), row.names = F, col.names = F, quote = F)
```

## Additional step: combine into 1 file for polygenic scoring
```{bash}
./plink --bfile ABCD_chr1_hg19 --merge-list ABCD_merge.txt --maf 0.001 --make-bed --out ABCD_hg19_allchrs --threads 10
for i in {1..22}; do ./plink --bfile ABCD_chr${i}_hg19 --exclude ABCD_hg19_allchrs-merge.missnp --maf 0.001 --make-bed --out ABCD_chr${i}_hg19_v2 --threads 10; done
./plink --bfile ABCD_chr1_hg19_v2 --merge-list ABCD_merge.txt --maf 0.001 --make-bed --out ABCD_hg19_allchrs --threads 10

for i in {1..22}; do rm ABCD_chr${i}_hg19_v2*; done

#Retain European
./plink --bfile ABCD_hg19_allchrs --keep ~/ABCD/ABCDgenotype/GWAS/QC4_european_grm.grm.id --make-bed --out ABCD_hg19_allchrs_europeanonly --maf 0.001 --threads 15

```

