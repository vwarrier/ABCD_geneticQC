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


wget ftp://ftp.ncbi.nih.gov/snp/organisms/human_9606_b150_GRCh37p13/VCF/common_all_20170710.vcf.gz
zgrep -v "^##" common_all_20170710.vcf.gz | cut -f1-3 > fileforrecoding.txt
awk '{print $1":"$2"\t"$3}' < fileforrecoding.txt > plinkrecodingfile.txt

## Change it in R
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
write.table(plink_recoding_file[,c("V2", "ID")], file = "plinkrecodingfile2.txt", col.names = T, row.names = F, quote = F)

##Update it again


