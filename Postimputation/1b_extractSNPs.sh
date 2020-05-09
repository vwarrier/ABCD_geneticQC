for i in {1..22}; do ./plink --vcf chr${i}.dose.vcf.gz --make-bed --out ./Plink_files/ABCD_chr${i}  --extract chr${i}extract.txt --const-fid 0; done
