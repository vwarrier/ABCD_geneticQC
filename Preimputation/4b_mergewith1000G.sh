./plink --bfile KGref --bmerge QC3output --geno 0.1 --maf 0.01 --autosome --make-bed --out QC3_KGref_pass3

./king -b QC3_KGref_pass3.bed --kinship --prefix QC3_KGref_pass3_kinship
