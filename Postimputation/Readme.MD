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
wget ftp://ftp.ncbi.nih.gov/snp/organisms/human_9606_b150_GRCh37p13/VCF/common_all_20170710.vcf.gz
zgrep -v "^##" common_all_20170710.vcf.gz | cut -f1-3 > fileforrecoding.txt
awk '{print $1":"$2"\t"$3}' < fileforrecoding.txt > plinkrecodingfile.txt
```
```{R}
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
```
```{bash}
for i in {1..22}; do ./plink --bfile ./Plink_files/ABCD_chr${i}  --update-name plinkrecodingfile2.txt --make-bed --out ./Plink_files/ABCD_chr${i}_v2; done
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



