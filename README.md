# ABCD Genetic QC

This is the script to run QC in the ABCD dataset.

## Prerequisites: Install the packages

1. Plink
http://zzz.bwh.harvard.edu/plink/download.shtml

2. KING
http://people.virginia.edu/~wc9c/KING/Download.htm

3. 1000 genomes: phase 3, hg19
```{bash}
wget http://people.virginia.edu/~wc9c/KING/KGref.tar.gz
tar -xvf KGref.tar.gz
```

4. Genesis and related packages (in R)
```{R}
setwd("~/ABCD/ABCDgenotype/Genotype_preimputation")
if (!requireNamespace("BiocManager", quietly = TRUE))
  install.packages("BiocManager")

BiocManager::install("GWASTools")

if (!requireNamespace("BiocManager", quietly = TRUE))
  install.packages("BiocManager")

BiocManager::install("GENESIS")

if (!requireNamespace("BiocManager", quietly = TRUE))
  install.packages("BiocManager")

BiocManager::install("SNPRelate")
```

5. File check for Michigan/TOPMED imputation server (in terminal)
```{bash}
wget http://www.well.ox.ac.uk/~wrayner/tools/HRC-1000G-check-bim-v4.2.9.zip
unzip HRC-1000G-check-bim-v4.2.9.zip

wget http://www.well.ox.ac.uk/~wrayner/tools/1000GP_Phase3_combined.legend.gz
gunzip 1000GP_Phase3_combined.legend.gz
````

## Prerequisites: Files needed
1. abcd_ygs01.txt : This is needed to update sex information in the FAM file and can be downloaded as a part of the ABCD phenotypic files.

2. Dataset_1KG_population.txt: This is a file with self-identified ethnicity from ABCD and 1KG. The 1KG part of the file is provided in the folder "Datasets".

## Run the analyses

### Step 1: Update fam file
Sex isn't provided in the ABCD script. Update sex:

```{bash}
Rscript 1_updatefam.R
```

### Step 2: Check Genomic Build
This will create a genomic build file. Ideally, we want to work with hg19 as the 1000 Genomes file is hg19. 



### Step 3: Run SNP level and sample-level QC
Basic SNP level and sample level QC excluding HWE at a SNP level and excessive heterogeneity at a sample level due to multiple ancestries.
3.1: geno 0.01 --> QC1output
3.2: mind0.05 and me 0.05 0.1 --> QC2outupt
3.3: check-sex, followed by remove --> QC3output

```{bash}

run ./3_BasicQC.sh
```{bash}
