./plink --bfile QC5output --exclude Exclude-QC5output-1000G.txt --make-bed --out TEMP1
./plink --bfile TEMP1 --update-map Chromosome-QC5output-1000G.txt --update-chr --make-bed --out TEMP2
./plink --bfile TEMP2 --update-map Position-QC5output-1000G.txt --make-bed --out TEMP3
./plink --bfile TEMP3 --flip Strand-Flip-QC5output-1000G.txt --make-bed --out TEMP4
./plink --bfile TEMP4 --reference-allele Force-Allele1-QC5output-1000G.txt --make-bed --out QC5output-updated
rm TEMP*
for i in {1..23}; do ./plink --bfile QC5output-updated --reference-allele Force-Allele1-QC5output-1000G.txt --chr ${i} --recode-vcf --out QC5output_file_chr${i}; done
for i in {1..23}; do vcf-sort QC5output_file_chr${i}.vcf | bgzip -c > QC5output_file_chr${i}.vcf.gz; done
for i in {1..23}; do rm QC5output_file_chr${i}.vcf | rm QC5output_file_chr${i}.log; done