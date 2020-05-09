# These are the steps involved in the post-imputation of the ABCD dataset.

Before embarking on this, please unzip all the files. 

## Step 1: Create a list of SNPs with acceptable QC stats
We will create a list of SNPs which have a MAF > 0.1% and Imputation R2 > 0.3

## Step 2: Update the SNP names
The SNP names provided do not rsIDs, but instead have Chr:Post:Allele format. We need to change this to make this into rsids.
To do this, let's have a look at where the files are available. 

Details are available here: https://www.ncbi.nlm.nih.gov/variation/docs/human_variation_vcf/
Download the right file from: ftp://ftp.ncbi.nih.gov/snp/organisms/human_9606_b150_GRCh38p7/VCF/


wget ftp://ftp.ncbi.nih.gov/snp/organisms/human_9606_b150_GRCh37p13/VCF/common_all_20170710.vcf.gz
zgrep -v "^##" common_all_20170710.vcf.gz | cut -f1-3 > fileforrecoding.txt
awk '{print $1":"$2"\t"$3}' < fileforrecoding.txt > plinkrecodingfile.txt
