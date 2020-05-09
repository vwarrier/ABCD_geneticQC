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


wget -c ftp://ftp.ncbi.nih.gov/snp/organisms/human_9606/VCF/00-All.vcf.gz
wget -c ftp://ftp.ncbi.nih.gov/snp/organisms/human_9606/VCF/00-All.vcf.gz.tbi

Download SNPSift

for i in {1..22}; do java -jar ./snpEff/SnpSift.jar annotate 00-All.vcf.gz chr${i}.dose.vcf.gz |gzip -c >  chr${i}.dose.id.vcf.gz; done 
zcat ${target} |grep -v "#" |cut -f3 |perl -pe 's/:/\t/g;s/;/\t/' |awk '{OFS="\t"}{print $1":"$2":"$3":"$4,$1,$2,$3,$4,$5}'> ${tsvf}
mv ${tsvf} ${tsvf}.tmp
cat ${tsvf}.tmp |awk '{OFS="\t"}{if($6==""){print $0"\t"$1}else{$6=$1"_"$6;print $0}}' > ${tsvf}
