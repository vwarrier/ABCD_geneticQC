## 6.1 Load resources

library(umap)
library(ggplot2)

## 6.2 Read additional population files and define races
load(PC.RData)

populationfile = fread("Dataset_1KG_population.txt")
setnames(PC, "Sample_name", "Sample")

populationfile = populationfile[!duplicated(populationfile$Sample),]

PC_withancestry = merge(populationfile, PC, by = "Sample")
PC_withancestry = unique(PC_withancestry)

#####We will fist identify clusters using only the 1KG dataset and then project the remaining data on it######

##6.3 UMAP with 1KG only (5 PCs, 8 PCs, and then 10 PCs)
# First subset to only 1 KG
PC_withancestry_1KG = subset(PC_withancestry, Dataset == "1000G")

# 6.3.1 Keep only the first five PCs and make plots
PC_forumap_1KG = PC_withancestry_1KG[,c(5:9)]
PC_forumap_labels_1KG = PC_withancestry_1KG[,c(1:4)]
PC_umap_1KG = umap(PC_forumap_1KG)

PC_umap_layout_1KG = PC_umap_1KG$layout
PC_umap_layout_1KG = cbind(PC_umap_layout_1KG, PC_forumap_labels_1KG)
ggplot(PC_umap_layout_1KG,aes(x=V1,y=V2,color=Population)) + geom_point(aes(shape = Superpopulation, colour = Population)) + scale_shape_manual(values=c(1, 2,3,4,5,6,7,8,9,10,11,12))
ggplot(PC_umap_layout_1KG,aes(x=V1,y=V2,color=Population)) + geom_point(aes(shape = Population, colour = Population)) + scale_shape_manual(values=c(0,1, 2,3,4,5,6,7,8,9,10,11,12,13,14,15,16,17,18,19,20,21,22,23,24,25))

# 6.3.2 Keep only the first eight PCs and make plots
PC_forumap_1KG = PC_withancestry_1KG[,c(5:12)]
PC_forumap_labels_1KG = PC_withancestry_1KG[,c(1:4)]
PC_umap_1KG = umap(PC_forumap_1KG)

PC_umap_layout_1KG = PC_umap_1KG$layout
PC_umap_layout_1KG = cbind(PC_umap_layout_1KG, PC_forumap_labels_1KG)
ggplot(PC_umap_layout_1KG,aes(x=V1,y=V2,color=Population)) + geom_point(aes(shape = Superpopulation, colour = Population)) + scale_shape_manual(values=c(0,1, 2,3,4,5,6,7,8,9,10,11,12,13,14,15,16,17,18,19,20,21,22,23,24,25))
ggplot(PC_umap_layout_1KG,aes(x=V1,y=V2,color=Population)) + geom_point(aes(shape = Population, colour = Population)) + scale_shape_manual(values=c(0,1, 2,3,4,5,6,7,8,9,10,11,12,13,14,15,16,17,18,19,20,21,22,23,24,25))


# 6.3.3 Keep only the first ten PCs and make plots
PC_forumap_1KG = PC_withancestry_1KG[,c(5:14)]
PC_forumap_labels_1KG = PC_withancestry_1KG[,c(1:4)]
PC_umap_1KG = umap(PC_forumap_1KG)

PC_umap_layout_1KG = PC_umap_1KG$layout
PC_umap_layout_1KG = cbind(PC_umap_layout_1KG, PC_forumap_labels_1KG)
ggplot(PC_umap_layout_1KG,aes(x=V1,y=V2,color=Population)) + geom_point(aes(shape = Superpopulation, colour = Population)) + scale_shape_manual(values=c(0,1, 2,3,4,5,6,7,8,9,10,11,12,13,14,15,16,17,18,19,20,21,22,23,24,25))
ggplot(PC_umap_layout_1KG,aes(x=V1,y=V2,color=Population)) + geom_point(aes(shape = Population, colour = Population)) + scale_shape_manual(values=c(0,1, 2,3,4,5,6,7,8,9,10,11,12,13,14,15,16,17,18,19,20,21,22,23,24,25))


###6.4 Go back to 5 
## UMAP with 1KG - 5 PCs

PC_forumap_1KG = PC_withancestry_1KG[,c(5:9)]
PC_forumap_labels_1KG = PC_withancestry_1KG[,c(1:4)]
PC_umap_1KG = umap(PC_forumap_1KG)


PC_umap_layout_1KG = PC_umap_1KG$layout
PC_umap_layout_1KG = cbind(PC_umap_layout_1KG, PC_forumap_labels_1KG)
ggplot(PC_umap_layout_1KG,aes(x=V1,y=V2,color=Population)) + geom_point(aes(shape = Superpopulation, colour = Population)) + scale_shape_manual(values=c(1, 2,3,4,5,6,7,8,9,10,11,12))


##6.5 UMAP with others and project - 5 PCs
PC_withancestry_no1KG = subset(PC_withancestry, Dataset == "ABCD") ####Change ABCD to your population

PC_forumap_no1KG = PC_withancestry_no1KG[,c(5:9)]
PC_forumap_labels_no1KG = PC_withancestry_no1KG[,c(1:4)]
PC_umap_no1KG = predict(PC_umap_1KG, PC_forumap_no1KG)
PC_umap_layout_no1KG = cbind(PC_umap_no1KG, PC_forumap_labels_no1KG)


PC_all_umap = rbind(PC_umap_layout_1KG, PC_umap_layout_no1KG)

p = ggplot(PC_all_umap,aes(x=V1,y=V2,color=Superpopulation)) + geom_point(aes(shape = Superpopulation, colour = Population)) + scale_shape_manual(values=c(1, 2,3,4,5,6,7,8,9,10,11,12,13,14,15))

p + theme(panel.grid.minor = element_line(colour="white", size=0.5)) +  scale_y_continuous(minor_breaks = seq(-15 , 15, 0.5), breaks = seq(-15 , 15, 1)) + scale_x_continuous(minor_breaks = seq(-15 , 15, 0.5), breaks = seq(-15 , 15, 1))

###6.6 Subset populations
American_chunk1 = subset(PC_all_umap, V1 > -14.5 & V1 < -9.5 & V2 > -6 & V2 < -2 )
American_chunk2 = subset(PC_all_umap, V1 > -9.5 & V1 < -4.5 & V2 > -3.5 & V2 < -2 )
American_chunk = rbind(American_chunk1, American_chunk2)

p = ggplot(American_chunk,aes(x=V1,y=V2,color=Population)) + geom_point(aes(shape = Superpopulation, colour = Population)) + scale_shape_manual(values=c(1, 2,3,4,5,6,7,8,9,10,11,12,13,14,15))
p + theme(panel.grid.minor = element_line(colour="white", size=0.5)) +  scale_y_continuous(minor_breaks = seq(-15 , 15, 0.5), breaks = seq(-15 , 15, 0.5)) + scale_x_continuous(minor_breaks = seq(-15 , 15, 0.5), breaks = seq(-15 , 15, 0.5))


Finnish_chunk = subset(PC_all_umap, V1 < -12.5 & V2 < -11.5)
p = ggplot(Finnish_chunk,aes(x=V1,y=V2,color=Population)) + geom_point(aes(shape = Superpopulation, colour = Population)) + scale_shape_manual(values=c(1, 2,3,4,5,6,7,8,9,10,11,12,13,14,15))
p + theme(panel.grid.minor = element_line(colour="white", size=0.5)) +  scale_y_continuous(minor_breaks = seq(-15 , 15, 0.5), breaks = seq(-15 , 15, 0.5)) + scale_x_continuous(minor_breaks = seq(-15 , 15, 0.5), breaks = seq(-15 , 15, 0.5))


European_chunk = subset(PC_all_umap, V1 < -4.5 & V1 > -10 & V2 < -9)
p = ggplot(European_chunk,aes(x=V1,y=V2,color=Population)) + geom_point(aes(shape = Superpopulation, colour = Population)) + scale_shape_manual(values=c(1, 2,3,4,5,6,7,8,9,10,11,12,13,14,15))
p + theme(panel.grid.minor = element_line(colour="white", size=0.5)) +  scale_y_continuous(minor_breaks = seq(-15 , 15, 0.5), breaks = seq(-15 , 15, 0.5)) + scale_x_continuous(minor_breaks = seq(-15 , 15, 0.5), breaks = seq(-15 , 15, 0.5))

EastAsian_chunk = subset(PC_all_umap, V1 >-13.5 & V1 < -6.5 & V2 > 8.5)
p = ggplot(EastAsian_chunk,aes(x=V1,y=V2,color=Population)) + geom_point(aes(shape = Superpopulation, colour = Population)) + scale_shape_manual(values=c(1, 2,3,4,5,6,7,8,9,10,11,12,13,14,15))
p + theme(panel.grid.minor = element_line(colour="white", size=0.5)) +  scale_y_continuous(minor_breaks = seq(-15 , 15, 0.5), breaks = seq(-15 , 15, 0.5)) + scale_x_continuous(minor_breaks = seq(-15 , 15, 0.5), breaks = seq(-15 , 15, 0.5))


SouthAsian_chunk = subset(PC_all_umap, V1 >5 & V2 > 11)
p = ggplot(SouthAsian_chunk,aes(x=V1,y=V2,color=Population)) + geom_point(aes(shape = Superpopulation, colour = Population)) + scale_shape_manual(values=c(1, 2,3,4,5,6,7,8,9,10,11,12,13,14,15))
p + theme(panel.grid.minor = element_line(colour="white", size=0.5)) +  scale_y_continuous(minor_breaks = seq(-15 , 15, 0.5), breaks = seq(-15 , 15, 0.5)) + scale_x_continuous(minor_breaks = seq(-15 , 15, 0.5), breaks = seq(-15 , 15, 0.5))


Bengali_chunk = subset(PC_all_umap, V1 >12 & V2 > 5 & V2 < 8)
p = ggplot(Bengali_chunk,aes(x=V1,y=V2,color=Population)) + geom_point(aes(shape = Superpopulation, colour = Population)) + scale_shape_manual(values=c(1, 2,3,4,5,6,7,8,9,10,11,12,13,14,15))
p + theme(panel.grid.minor = element_line(colour="white", size=0.5)) +  scale_y_continuous(minor_breaks = seq(-15 , 15, 0.5), breaks = seq(-15 , 15, 0.5)) + scale_x_continuous(minor_breaks = seq(-15 , 15, 0.5), breaks = seq(-15 , 15, 0.5))


African_chunk1 = subset(PC_all_umap, V1 > 8 &  V2 > -11.5 & V2 < -8 )
African_chunk2 = subset(PC_all_umap, V1 > 11 &  V2 > -8 & V2 < -2 )
African_chunk = rbind(African_chunk1, African_chunk2)
p = ggplot(African_chunk,aes(x=V1,y=V2,color=Superpopulation)) + geom_point(aes(shape = Superpopulation, colour = Population)) + scale_shape_manual(values=c(1, 2,3,4,5,6,7,8,9,10,11,12,13,14,15))
p + theme(panel.grid.minor = element_line(colour="white", size=0.5)) +  scale_y_continuous(minor_breaks = seq(-15 , 15, 0.5), breaks = seq(-15 , 15, 0.5)) + scale_x_continuous(minor_breaks = seq(-15 , 15, 0.5), breaks = seq(-15 , 15, 0.5))

## 6.7 Keep only the samples in your data and not in 1000G and save
American_chunk_data2 = subset(American_chunk, Dataset == "ABCD") ###input your dataname
dim(American_chunk_data2)

African_chunk_data2 = subset(African_chunk, Dataset == "ABCD") ###input your dataname
dim(African_chunk_data2)

Bengali_chunk_data2 = subset(Bengali_chunk, Dataset == "ABCD") ###input your dataname
dim(Bengali_chunk_data2)

SouthAsian_chunk_data2 = subset(SouthAsian_chunk, Dataset == "ABCD") ###input your dataname
dim(SouthAsian_chunk_data2)

EastAsian_chunk_data2 = subset(EastAsian_chunk, Dataset == "ABCD") ###input your dataname
dim(EastAsian_chunk_data2)

European_chunk_data2 = subset(European_chunk, Dataset == "ABCD") ###input your dataname
dim(European_chunk_data2)

Finnish_chunk_data2 = subset(Finnish_chunk, Dataset == "ABCD") ###input your dataname
dim(Finnish_chunk_data2)


save(American_chunk_data2, file = "American_chunk_ABCD.rda") ###input your dataname
save(African_chunk_data2, file = "African_chunk_ABCD.rda") ###input your dataname
save(Bengali_chunk_data2, file = "Bengali_chunk_ABCD.rda") ###input your dataname
save(SouthAsian_chunk_data2, file = "SouthAsian_chunk_ABCD.rda") ###input your dataname
save(EastAsian_chunk_data2, file = "EastAsian_chunk_ABCD.rda") ###input your dataname
save(European_chunk_data2, file = "European_chunk_ABCD.rda") ###input your dataname
save(Finnish_chunk_data2, file = "Finnish_chunk_ABCD.rda") ###input your dataname

##6.8 Create keep files
fam_check = fread("QC3output.fam")
fam_check = fam_check[,c("V1", "V2")]

keep_American = fam_check[fam_check$V2 %in% American_chunk_data2$Sample,]
keep_African = fam_check[fam_check$V2 %in% African_chunk_data2$Sample,]
keep_Bengali = fam_check[fam_check$V2 %in% Bengali_chunk_data2$Sample,]
keep_SouthAsian = fam_check[fam_check$V2 %in% SouthAsian_chunk_data2$Sample,]
keep_EastAsian = fam_check[fam_check$V2 %in% EastAsian_chunk_data2$Sample,]
keep_European = fam_check[fam_check$V2 %in% European_chunk_data2$Sample,]
keep_Finnish = fam_check[fam_check$V2 %in% Finnish_chunk_data2$Sample,]

write.table(keep_American, file = "keep_American.txt", row.names = F, col.names = F, quote = F)
write.table(keep_African, file = "keep_African.txt", row.names = F, col.names = F, quote = F)
write.table(keep_Bengali, file = "keep_Bengali.txt", row.names = F, col.names = F, quote = F)
write.table(keep_SouthAsian, file = "keep_SouthAsian.txt", row.names = F, col.names = F, quote = F)
write.table(keep_EastAsian, file = "keep_EastAsian.txt", row.names = F, col.names = F, quote = F)
write.table(keep_European, file = "keep_European.txt", row.names = F, col.names = F, quote = F)
write.table(keep_Finnish, file = "keep_Finnish.txt", row.names = F, col.names = F, quote = F)
