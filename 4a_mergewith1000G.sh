./plink --bfile KGref --bmerge QC3output --make-bed --out QC3_KGref_pass1

./plink --bfile QC3output --flip QC3_KGref_pass1-merge.missnp --make-bed --out QC3output_flippedfile

./plink --bfile KGref --bmerge QC3output_flippedfile --make-bed --out QC3_KGref_pass2

./plink --bfile KGref --exclude QC3_KGref_pass2-merge.missnp --make-bed --out KGref_formerging

./plink --bfile QC3output_flippedfile --exclude QC3_KGref_pass2-merge.missnp --make-bed --out QC3output_flippedfileformerging

./plink --bfile KGref_formerging --bmerge QC3output_flippedfileformerging --make_bed --autosome --out QC3_KGref_pass3

./plink --bfile QC3_KGref_pass3 --maf 0.01 --geno 0.1 --make-bed --autosome --out QC3_KGref_pass3_commonvariants

./king -b QC3_KGref_pass3.bed --kinship --prefix QC3_KGref_pass3_kinship
