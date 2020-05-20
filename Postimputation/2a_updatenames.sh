wget ftp://ftp.ncbi.nih.gov/snp/organisms/human_9606_b150_GRCh37p13/VCF/common_all_20170710.vcf.gz
zgrep -v "^##" common_all_20170710.vcf.gz | cut -f1-3 > fileforrecoding.txt
awk '{print $1":"$2"\t"$3}' < fileforrecoding.txt > plinkrecodingfile.txt