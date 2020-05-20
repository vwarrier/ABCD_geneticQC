./plink --bfile QC5output --maf 0.05 --make-bed --out QC5output_forPC --thread 20

./king -b QC5output_forPC.bed --kinship --prefix QC5output_kinship