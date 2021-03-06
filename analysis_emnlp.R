##### Load Data #####
df <- read.csv("emnlp_data_medians.csv")
df_all <- read.csv("emnlp_data_individual_hum_scores.csv")

##### Import Packages #####
library(dplyr)
library(reshape2)
library(ggplot2)
library(Hmisc)
library(psych)
library(multcomp)
library(corrgram)
library(corrplot)
library(qdap)

library(irr)
library(tidyr)
require(gridExtra)

##### Inter-rater Agreement on Human Ratings (Table 7) #####

    ######## Subset data by judge: ########
j1 = df_all %>%
  filter(df_all$judge == 1)

j2 = df_all %>%
  filter(df_all$judge == 2)

j3 = df_all %>%
  filter(df_all$judge == 3)

    ######## Subset data by dataset (ds) and system (sys): ########
ds <- c(as.character(j1$dataset), as.character(j2$dataset), as.character(j3$dataset))
sys <- c(as.character(j1$system), as.character(j2$system), as.character(j3$system))
j1_all <- c(j1$informativeness, j1$naturalness, j1$quality)
j2_all <- c(j2$informativeness, j2$naturalness, j2$quality)
j3_all <- c(j3$informativeness, j3$naturalness, j3$quality)
j_all <- cbind.data.frame(ds, j1_all, j2_all, j3_all, sys)

    ######## Calculate intra-class correlation coefficient: ########
icc(j_all[,2:4], unit = "a", model = "t") # 0.45, p<0.01

icc(subset(j_all, ds == "BAGEL")[,2:4], unit = "a") # 0.31, p<0.01
icc(subset(j_all, ds == "BAGEL" & sys=="LOLS")[,2:4], unit = "a") # 0.24, p<0.01
icc(subset(j_all, ds == "BAGEL" & sys=="Dusek")[,2:4], unit = "a") # 0.31, p<0.01

icc(subset(j_all, ds == "SFHOT")[,2:4], unit = "a") # 0.50, p<0.01
icc(subset(j_all, ds == "SFHOT" & sys =="WEN")[,2:4], unit = "a") # 0.52, p<0.01
icc(subset(j_all, ds == "SFHOT" & sys =="LOLS")[,2:4], unit = "a") # 0.45, p<0.01

icc(subset(j_all, ds == "SFRES")[,2:4], unit = "a") # 0.35, p<0.01
icc(subset(j_all, ds == "SFRES" & sys =="WEN")[,2:4], unit = "a") # 0.25, p<0.01
icc(subset(j_all, ds == "SFRES" & sys =="LOLS")[,2:4], unit = "a") # 0.38, p<0.01

# agreement on informativeness:
j1_inf <- c(j1$informativeness)
j2_inf <- c(j2$informativeness)
j3_inf <- c(j3$informativeness)
sys.out <- as.character(j1$sys_ref)
sys <- j1$system
j_inf <- cbind.data.frame(ds, j1_inf, j2_inf, j3_inf,sys)
icc(j_inf[,2:4], unit = "a", model = "t") # 0.39, p<0.01
icc(subset(j_inf, ds == "SFHOT")[,2:4], unit = "a") # 0.41, p<0.01
icc(subset(j_inf, ds == "SFHOT" & sys == "WEN")[,2:4], unit = "a") # 0.38, p<0.01
icc(subset(j_inf, ds == "SFHOT" & sys == "LOLS")[,2:4], unit = "a") # 0.38, p<0.01
icc(subset(j_inf, ds == "SFRES")[,2:4], unit = "a") # 0.35, p<0.01
icc(subset(j_inf, ds == "SFRES" & sys == "WEN")[,2:4], unit = "a") # 0.23, p<0.01
icc(subset(j_inf, ds == "SFRES" & sys == "LOLS")[,2:4], unit = "a") # 0.38, p<0.01
icc(subset(j_inf, ds == "BAGEL")[,2:4], unit = "a") # 0.16, p<0.01
icc(subset(j_inf, ds == "BAGEL" & sys == "Dusek")[,2:4], unit = "a") # 0.30, p<0.01
icc(subset(j_inf, ds == "BAGEL" & sys == "LOLS")[,2:4], unit = "a") # 0.16, p<0.01

# agreement on naturalness:
j1_nat <- c(j1$naturalness)
j2_nat <- c(j2$naturalness)
j3_nat <- c(j3$naturalness)
j_nat <- cbind.data.frame(ds, j1_nat, j2_nat, j3_nat, sys)
icc(j_nat[,2:4], unit = "a") # 0.42, p<0.01
icc(subset(j_nat, ds == "BAGEL")[,2:4], unit = "a") # 0.36, p<0.01
icc(subset(j_nat, ds == "BAGEL" & sys == "Dusek")[,2:4], unit = "a") # 0.46, p<0.01
icc(subset(j_nat, ds == "BAGEL" & sys == "LOLS")[,2:4], unit = "a") # 0.3, p<0.01
icc(subset(j_nat, ds == "SFHOT")[,2:4], unit = "a") # 0.47, p<0.01
icc(subset(j_nat, ds == "SFHOT" & sys == "WEN")[,2:4], unit = "a") # 0.40, p<0.01
icc(subset(j_nat, ds == "SFHOT" & sys == "LOLS")[,2:4], unit = "a") # 0.49, p<0.01
icc(subset(j_nat, ds == "SFRES")[,2:4], unit = "a") # 0.29, p<0.01
icc(subset(j_nat, ds == "SFRES" & sys == "WEN")[,2:4], unit = "a") # 0.13, p<0.01
icc(subset(j_nat, ds == "SFRES" & sys == "LOLS")[,2:4], unit = "a") # 0.29, p<0.01

# agreement on quality:
j1_qual <- c(j1$quality)
j2_qual <- c(j2$quality)
j3_qual <- c(j3$quality)
j_qual <- cbind.data.frame(ds, j1_qual, j2_qual, j3_qual,sys)
icc(j_qual[,2:4], unit = "a") # 0.46, p<0.01
icc(subset(j_qual, ds == "SFHOT")[,2:4], unit = "a") # 0.52, p<0.01
icc(subset(j_qual, ds == "SFHOT" & sys == "WEN")[,2:4], unit = "a") # 0.59, p<0.01
icc(subset(j_qual, ds == "SFHOT" & sys == "LOLS")[,2:4], unit = "a") # 0.40, p<0.01

icc(subset(j_qual, ds == "SFRES")[,2:4], unit = "a") # 0.35, p<0.01
icc(subset(j_qual, ds == "SFRES" & sys == "WEN")[,2:4], unit = "a") # 0.28, p<0.01
icc(subset(j_qual, ds == "SFRES" & sys == "LOLS")[,2:4], unit = "a") # 0.38, p<0.01

icc(subset(j_qual, ds == "BAGEL")[,2:4], unit = "a") # 0.38, p<0.01
icc(subset(j_qual, ds == "BAGEL" & sys == "Dusek")[,2:4], unit = "a") # 0.46, p<0.01
icc(subset(j_qual, ds == "BAGEL" & sys == "LOLS")[,2:4], unit = "a") # 0.31, p<0.01

##### Systems Performance for All Datasets (Table 8) #####
dus <- subset(df, system=="Dusek")
lols.bag <- subset(df, system=="LOLS" & dataset=="BAGEL")

wen.sfh <- subset(df,system=="WEN" & dataset=="SFHOT")
lols.sfh <- subset(df, system=="LOLS" & dataset=="SFHOT")

wen.sfr <- subset(df,system=="WEN" & dataset=="SFRES")
lols.sfr <- subset(df, system=="LOLS" & dataset=="SFRES")

bag.dus.avg<-as.data.frame(summary(dus[,c(6:27,29:31)]))[seq(4,150,6),] %>% 
  separate(Freq, sep = ":", into = c(" ", "mean"))
bag.lols.avg<-as.data.frame(summary(lols.bag[,c(6:27,29:31)]))[seq(4,150,6),] %>% 
  separate(Freq, sep = ":", into = c(" ", "mean"))
wen.sfh.avg<-as.data.frame(summary(wen.sfh[,c(6:27,29:31)]))[seq(4,150,6),] %>% 
  separate(Freq, sep = ":", into = c(" ", "mean"))
lols.sfh.avg<-as.data.frame(summary(lols.sfh[,c(6:27,29:31)]))[seq(4,150,6),] %>% 
  separate(Freq, sep = ":", into = c(" ", "mean"))
wen.sfr.avg<-as.data.frame(summary(wen.sfr[,c(6:27,29:31)]))[seq(4,150,6),] %>% 
  separate(Freq, sep = ":", into = c(" ", "mean"))
lols.sfr.avg<-as.data.frame(summary(lols.sfr[,c(6:27,29:31)]))[seq(4,150,6),] %>% 
  separate(Freq, sep = ":", into = c(" ", "mean"))

avg <- cbind(bag.dus.avg[,c(2,4)], as.data.frame(sapply(dus[,c(6:27,29:31)], sd)), 
             bag.lols.avg[,4], as.data.frame(sapply(lols.bag[,c(6:27,29:31)], sd)),
             wen.sfh.avg[,4], as.data.frame(sapply(wen.sfh[,c(6:27,29:31)], sd)),
             lols.sfh.avg[,4], as.data.frame(sapply(lols.sfh[,c(6:27,29:31)], sd)),
             wen.sfr.avg[,4], as.data.frame(sapply(wen.sfr[,c(6:27,29:31)], sd)),
             lols.sfr.avg[,4], as.data.frame(sapply(lols.sfr[,c(6:27,29:31)], sd)))
names(avg) <- c("Metric", "TGen/Bagel, avg", "TGen/Bagel, sd", "LOLS/Bagel, avg", "LOLS/Bagel, sd",
                "RNNLG/SFHotel, avg", "RNNLG/SFHotel, sd", "LOLS/SFHotel, avg", "LOLS/SFHotel, sd",
                "RNNLG/SFRes, avg", "RNNLG/SFRes, sd", "LOLS/SFRes, avg", "LOLS/SFRes, sd")

bag<-subset(df, dataset == "BAGEL")
pairwise.t.test(bag$Bleu_1, bag$system, p.adj = "none") #*
pairwise.t.test(bag$Bleu_2, bag$system, p.adj = "none") 
pairwise.t.test(bag$Bleu_3, bag$system, p.adj = "none")
pairwise.t.test(bag$Bleu_4, bag$system, p.adj = "none")
pairwise.t.test(bag$TER, bag$system, p.adj = "none")
pairwise.t.test(bag$ROUGE_L, bag$system, p.adj = "none")
pairwise.t.test(bag$NIST, bag$system, p.adj = "none") #*
pairwise.t.test(bag$LEPOR, bag$system, p.adj = "none") #*
pairwise.t.test(bag$CIDEr, bag$system, p.adj = "none")
pairwise.t.test(bag$METEOR, bag$system, p.adj = "none")
pairwise.t.test(bag$sim.mr.sys, bag$system, p.adj = "none")
pairwise.t.test(bag$sys.read.flesch, bag$system, p.adj = "none")
pairwise.t.test(bag$sys.cpw, bag$system, p.adj = "none")
pairwise.t.test(bag$sys.ref.len, bag$system, p.adj = "none") #*
pairwise.t.test(bag$sys.wps, bag$system, p.adj = "none") #*
pairwise.t.test(bag$sys.sps, bag$system, p.adj = "none") #*
pairwise.t.test(bag$sys.spw, bag$system, p.adj = "none")
pairwise.t.test(bag$sys.n.poly, bag$system, p.adj = "none")
pairwise.t.test(bag$sys.pspw, bag$system, p.adj = "none")
pairwise.t.test(bag$n.misspel, bag$system, p.adj = "none") #*
pairwise.t.test(bag$parser.sc.mean, bag$system, p.adj = "none") #*

pairwise.t.test(bag$informativeness, bag$system, p.adj = "none")
pairwise.t.test(bag$naturalness, bag$system, p.adj = "none")
pairwise.t.test(bag$quality, bag$system, p.adj = "none")

sfh<-subset(df, dataset == "SFHOT")
pairwise.t.test(sfh$Bleu_1, sfh$system, p.adj = "none") #*
pairwise.t.test(sfh$Bleu_2, sfh$system, p.adj = "none") #*
pairwise.t.test(sfh$Bleu_3, sfh$system, p.adj = "none") #*
pairwise.t.test(sfh$Bleu_4, sfh$system, p.adj = "none") #*
pairwise.t.test(sfh$TER, sfh$system, p.adj = "none") #*
pairwise.t.test(sfh$ROUGE_L, sfh$system, p.adj = "none") #*
pairwise.t.test(sfh$NIST, sfh$system, p.adj = "none") #*
pairwise.t.test(sfh$LEPOR, sfh$system, p.adj = "none") #*
pairwise.t.test(sfh$CIDEr, sfh$system, p.adj = "none") #*
pairwise.t.test(sfh$METEOR, sfh$system, p.adj = "none") #*
pairwise.t.test(sfh$sim.mr.sys, sfh$system, p.adj = "none") #*
pairwise.t.test(sfh$sys.read.flesch, sfh$system, p.adj = "none")
pairwise.t.test(sfh$sys.cpw, sfh$system, p.adj = "none")
pairwise.t.test(sfh$sys.ref.len, sfh$system, p.adj = "none") #*
pairwise.t.test(sfh$sys.wps, sfh$system, p.adj = "none") #*
pairwise.t.test(sfh$sys.sps, sfh$system, p.adj = "none") #*
pairwise.t.test(sfh$sys.spw, sfh$system, p.adj = "none")
pairwise.t.test(sfh$sys.n.poly, sfh$system, p.adj = "none")
pairwise.t.test(sfh$sys.pspw, sfh$system, p.adj = "none")
pairwise.t.test(sfh$n.misspel, sfh$system, p.adj = "none") 
pairwise.t.test(sfh$parser.sc.mean, sfh$system, p.adj = "none") #*

pairwise.t.test(sfh$informativeness, sfh$system, p.adj = "none")
pairwise.t.test(sfh$naturalness, sfh$system, p.adj = "none")
pairwise.t.test(sfh$quality, sfh$system, p.adj = "none")

sfr<-subset(df,dataset == "SFRES")
pairwise.t.test(sfr$Bleu_1, sfr$system, p.adj = "none") #*
pairwise.t.test(sfr$Bleu_2, sfr$system, p.adj = "none") #*
pairwise.t.test(sfr$Bleu_3, sfr$system, p.adj = "none") #*
pairwise.t.test(sfr$Bleu_4, sfr$system, p.adj = "none") #*
pairwise.t.test(sfr$TER, sfr$system, p.adj = "none") #*
pairwise.t.test(sfr$ROUGE_L, sfr$system, p.adj = "none") #*
pairwise.t.test(sfr$NIST, sfr$system, p.adj = "none") #*
pairwise.t.test(sfr$LEPOR, sfr$system, p.adj = "none") #*
pairwise.t.test(sfr$CIDEr, sfr$system, p.adj = "none") #*
pairwise.t.test(sfr$METEOR, sfr$system, p.adj = "none") #*
pairwise.t.test(sfr$sim.mr.sys, sfr$system, p.adj = "none")
pairwise.t.test(sfr$sys.read.flesch, sfr$system, p.adj = "none")
pairwise.t.test(sfr$sys.cpw, sfr$system, p.adj = "none") #*
pairwise.t.test(sfr$sys.ref.len, sfr$system, p.adj = "none") #*
pairwise.t.test(sfr$sys.wps, sfr$system, p.adj = "none") #*
pairwise.t.test(sfr$sys.sps, sfr$system, p.adj = "none") #*
pairwise.t.test(sfr$sys.spw, sfr$system, p.adj = "none")
pairwise.t.test(sfr$sys.n.poly, sfr$system, p.adj = "none")
pairwise.t.test(sfr$sys.pspw, sfr$system, p.adj = "none")
pairwise.t.test(sfr$n.misspel, sfr$system, p.adj = "none")
pairwise.t.test(sfr$parser.sc.mean, sfr$system, p.adj = "none")

pairwise.t.test(sfr$informativeness, sfr$system, p.adj = "none")
pairwise.t.test(sfr$naturalness, sfr$system, p.adj = "none")
pairwise.t.test(sfr$quality, sfr$system, p.adj = "none")

##### Correlations by Dataset and System (Table 9) #####

      ######## For Bagel / TGen: ########
dus <- subset(df, system=="Dusek")
dusek.cor <- as.data.frame(cbind(cor(dus[, c(6:31)], 
                                     method = "spearman")[1:23,-c(1:23)],
                                 rcorr(as.matrix(dus[, c(6:31)]), 
                                       type = "spearman")$P[1:23,-c(1:23)]))
names(dusek.cor) <- c("inf","nat","qual","inf.p","nat.p","qual.p")

      ######## For Bagel / LOLS: ########
lols.bag <- subset(df, system=="LOLS" & dataset=="BAGEL")
lols.bag.cor <- as.data.frame(cbind(cor(lols.bag[, c(6:31)], 
                                        method = "spearman")[1:23,-c(1:23)],
                                    rcorr(as.matrix(lols.bag[, c(6:31)]), 
                                          type = "spearman")$P[1:23,-c(1:23)]))
names(lols.bag.cor) <- c("inf","nat","qual","inf.p","nat.p","qual.p")

      ######## For SFHotel / RNNLG: ########
wen.sfh <- subset(df,system=="WEN" & dataset=="SFHOT")
wen.sfh.cor <- as.data.frame(cbind(cor(wen.sfh[, c(6:31)], 
                                       method = "spearman")[1:23,-c(1:23)],
                                   rcorr(as.matrix(wen.sfh[, c(6:31)]), 
                                         type = "spearman")$P[1:23,-c(1:23)]))
names(wen.sfh.cor) <- c("inf","nat","qual","inf.p","nat.p","qual.p")

      ######## For SFHotel / LOLS: ########
lols.sfh <- subset(df, system=="LOLS" & dataset=="SFHOT")
lol.sfh.cor <- as.data.frame(cbind(cor(lols.sfh[, c(6:31)], 
                                       method = "spearman")[1:23,-c(1:23)],
                                   rcorr(as.matrix(lols.sfh[, c(6:31)]), 
                                         type = "spearman")$P[1:23,-c(1:23)]))
names(lol.sfh.cor) <- c("inf","nat","qual","inf.p","nat.p","qual.p")

      ######## For SFRest / RNNLG: ########
wen.sfr <- subset(df,system=="WEN" & dataset=="SFRES")
wen.sfr.cor <- as.data.frame(cbind(cor(wen.sfr[, c(6:31)], 
                                       method = "spearman")[1:23,-c(1:23)],
                                   rcorr(as.matrix(wen.sfr[, c(6:31)]), 
                                         type = "spearman")$P[1:23,-c(1:23)]))
names(wen.sfr.cor) <- c("inf","nat","qual","inf.p","nat.p","qual.p")

      ######## For SFRest / LOLS: ########
lols.sfr <- subset(df, system=="LOLS" & dataset=="SFRES")
lol.sfr.cor <- as.data.frame(cbind(cor(lols.sfr[, c(6:31)], 
                                       method = "spearman")[1:23,-c(1:23)],
                                   rcorr(as.matrix(lols.sfr[, c(6:31)]), 
                                         type = "spearman")$P[1:23,-c(1:23)]))
names(lol.sfr.cor) <- c("inf","nat","qual","inf.p","nat.p","qual.p")

##### Correlation Graph for TGen on Bagel (Fig.1) #####

dus <- subset(df, system=="Dusek")
lols.bag <- subset(df, system=="LOLS" & dataset=="BAGEL")

dus.rbm <- dus[,c(6:16,29:31)]
names(dus.rbm) <- c("TER", "B1", "B2", "B3", "B4","RG", "NST", "LP", "CID","MET", "SIM","INF","NAT","QUA")
dus.lbm <- dus[,c(18:27,29:31)]
names(dus.lbm) <- c("RE","CPW", "LEN","WPS","SPS","SPW","POL","PPW","MSP","PRS", "INF","NAT","QUA")
par(mfrow=c(1,2))
corrplot::corrplot.mixed(cor(dus.rbm, method = "spearman"),
                         lower = "circle", upper = "number", 
                         main = "WBM", mar=c(0,0,1,0),
                         tl.cex = .8, number.cex = 0.8, number.digits = 1,
                         col=colorRampPalette(c("red","grey45","blue"))(200))
corrplot::corrplot.mixed(cor(dus.lbm, method = "spearman"),
                         lower = "circle", upper = "number", 
                         main = "GBM", mar=c(0,0,1,0),
                         tl.cex = .8, number.cex = 0.8, number.digits = 1,
                         col=colorRampPalette(c("red","grey45","blue"))(200))


##### Correlations by Dataset (Table 10) #####

      ######## For Bagel: ######## 
bagel <- subset(df, dataset=="BAGEL")
bagel.cor <- as.data.frame(cbind(cor(bagel[, c(6:31)], 
                                     method = "spearman")[1:23,-c(1:23)],
                                 rcorr(as.matrix(bagel[, c(6:31)]), 
                                       type = "spearman")$P[1:23,-c(1:23)]))
names(bagel.cor) <- c("inf","nat","qual","inf.p","nat.p","qual.p")

      ######## For SFHotel: ######## 
sfh <- subset(df, dataset=="SFHOT")
sfh.cor <- as.data.frame(cbind(cor(sfh[, c(6:31)], 
                                   method = "spearman")[1:23,-c(1:23)],
                               rcorr(as.matrix(sfh[, c(6:31)]), 
                                     type = "spearman")$P[1:23,-c(1:23)]))
names(sfh.cor) <- c("inf","nat","qual","inf.p","nat.p","qual.p")

      ######## For SFRest: ######## 
sfr <- subset(df, dataset == "SFRES")
sfr.cor <- as.data.frame(cbind(cor(sfr[, c(6:31)], 
                                   method = "spearman")[1:23,-c(1:23)],
                               rcorr(as.matrix(sfr[, c(6:31)]), 
                                     type = "spearman")$P[1:23,-c(1:23)]))
names(sfr.cor) <- c("inf","nat","qual","inf.p","nat.p","qual.p")

      ######## Significance of correlation differences: ########
diff <- as.data.frame(matrix(nrow=22, ncol = 9)) # diff of corr btw systems

for (i in 6:27){
  diff[i-5,1] <- r.test(n=2101, r12=cor(bagel$informativeness, bagel[,i], method = "spearman"),
                        r34=cor(sfh$informativeness, sfh[,i], method = "spearman"),
                        n2=359)$p
  diff[i-5,2] <- r.test(n=2101, r12=cor(bagel$informativeness, bagel[,i], method = "spearman"),
                        r34=cor(sfr$informativeness, sfr[,i], method = "spearman"),
                        n2=359)$p
  diff[i-5,3] <- r.test(n=2101, r12=cor(sfr$informativeness, sfr[,i], method = "spearman"),
                        r34=cor(sfh$informativeness, sfh[,i], method = "spearman"),
                        n2=359)$p
  
  diff[i-5,4] <- r.test(n=2101, r12=cor(bagel$naturalness, bagel[,i], method = "spearman"),
                        r34=cor(sfh$naturalness, sfh[,i], method = "spearman"),
                        n2=359)$p
  diff[i-5,5] <- r.test(n=2101, r12=cor(bagel$naturalness, bagel[,i], method = "spearman"),
                        r34=cor(sfr$naturalness, sfr[,i], method = "spearman"),
                        n2=359)$p
  diff[i-5,6] <- r.test(n=2101, r12=cor(sfr$naturalness, sfr[,i], method = "spearman"),
                        r34=cor(sfh$naturalness, sfh[,i], method = "spearman"),
                        n2=359)$p
  
  diff[i-5,7] <- r.test(n=2101, r12=cor(bagel$quality, bagel[,i], method = "spearman"),
                        r34=cor(sfh$quality, sfh[,i], method = "spearman"),
                        n2=359)$p
  diff[i-5,8] <- r.test(n=2101, r12=cor(bagel$quality, bagel[,i], method = "spearman"),
                        r34=cor(sfr$quality, sfr[,i], method = "spearman"),
                        n2=359)$p
  diff[i-5,9] <- r.test(n=2101, r12=cor(sfr$quality, sfr[,i], method = "spearman"),
                        r34=cor(sfh$quality, sfh[,i], method = "spearman"),
                        n2=359)$p
}
names(diff)<-c("inf bag-sfh", "inf bag-sfr", "inf sfr-sfh",
               "nat bag-sfh", "nat bag-sfr", "nat sfr-sfh",
               "qua bag-sfh", "qua bag-sfr", "qua sfr-sfh")
rownames(diff)<-colnames(bagel[,6:27])


##### Correlations by System (Table 11) #####

lols <- subset(df, system=="LOLS")
wen <- subset(df, system=="WEN")
dus <- subset(df, system == "Dusek")

lols.cor <- as.data.frame(cbind(cor(lols[, c(6:31)], 
                                    method = "spearman")[1:23,-c(1:23)],
                                rcorr(as.matrix(lols[, c(6:31)]), 
                                      type = "spearman")$P[1:23,-c(1:23)]))
names(lols.cor) <- c("inf","nat","qual","inf.p","nat.p","qual.p")

wen.cor <- as.data.frame(cbind(cor(wen[, c(6:31)], 
                                   method = "spearman")[1:23,-c(1:23)],
                               rcorr(as.matrix(wen[, c(6:31)]), 
                                     type = "spearman")$P[1:23,-c(1:23)]))
names(wen.cor) <- c("inf","nat","qual","inf.p","nat.p","qual.p")

dus.cor <- as.data.frame(cbind(cor(dus[, c(6:31)], 
                                   method = "spearman")[1:23,-c(1:23)],
                               rcorr(as.matrix(dus[, c(6:31)]), 
                                     type = "spearman")$P[1:23,-c(1:23)]))
names(dus.cor) <- c("inf","nat","qual","inf.p","nat.p","qual.p")

diff <- as.data.frame(matrix(nrow=22, ncol = 9)) # diff of corr btw systems

for (i in 6:27){
  diff[i-5,1] <- r.test(n=2101, r12=cor(dus$informativeness, dus[,i], method = "spearman"),
                        r34=cor(lols$informativeness, lols[,i], method = "spearman"),
                        n2=359)$p
  diff[i-5,2] <- r.test(n=2101, r12=cor(dus$informativeness, dus[,i], method = "spearman"),
                        r34=cor(wen$informativeness, wen[,i], method = "spearman"),
                        n2=359)$p
  diff[i-5,3] <- r.test(n=2101, r12=cor(lols$informativeness, lols[,i], method = "spearman"),
                        r34=cor(wen$informativeness, wen[,i], method = "spearman"),
                        n2=359)$p
  
  diff[i-5,4] <- r.test(n=2101, r12=cor(dus$naturalness, dus[,i], method = "spearman"),
                        r34=cor(lols$naturalness, lols[,i], method = "spearman"),
                        n2=359)$p
  diff[i-5,5] <- r.test(n=2101, r12=cor(dus$naturalness, dus[,i], method = "spearman"),
                        r34=cor(wen$naturalness, wen[,i], method = "spearman"),
                        n2=359)$p
  diff[i-5,6] <- r.test(n=2101, r12=cor(lols$naturalness, lols[,i], method = "spearman"),
                        r34=cor(wen$naturalness, wen[,i], method = "spearman"),
                        n2=359)$p
  
  diff[i-5,7] <- r.test(n=2101, r12=cor(dus$quality, dus[,i], method = "spearman"),
                        r34=cor(lols$quality, lols[,i], method = "spearman"),
                        n2=359)$p
  diff[i-5,8] <- r.test(n=2101, r12=cor(dus$quality, dus[,i], method = "spearman"),
                        r34=cor(wen$quality, wen[,i], method = "spearman"),
                        n2=359)$p
  diff[i-5,9] <- r.test(n=2101, r12=cor(lols$quality, lols[,i], method = "spearman"),
                        r34=cor(wen$quality, wen[,i], method = "spearman"),
                        n2=359)$p
}
names(diff)<-c("inf dusek-lols", "inf dusek-wen", "inf lols-wen",
               "nat dusek-lols", "nat dusek-wen", "nat lols-wen",
               "qua dusek-lols", "qua dusek-wen", "qua lols-wen")
rownames(diff)<-colnames(dus[,6:27])


###### Correlations between WBM and Human Ratings Bins (Tab.13) ######
bad.inf <- subset(df, inf_bin == "bad")
not.bad.inf <- subset(df, inf_bin != "bad")

bad.nat <- subset(df, nat_bin == "bad")
not.bad.nat <- subset(df, nat_bin != "bad")

bad.q <- subset(df, qual_bin == "bad")
not.bad.q <- subset(df, qual_bin != "bad")

bad.inf.cor <- as.data.frame(cbind(cor(bad.inf[, c(6:31)], 
                                       method = "spearman")[1:23,-c(1:23)],
                                   rcorr(as.matrix(bad.inf[, c(6:31)]), 
                                         type = "spearman")$P[1:23,-c(1:23)]))
names(bad.inf.cor) <- c("inf","nat","qual","inf.p","nat.p","qual.p")
not.bad.inf.cor <- as.data.frame(cbind(cor(not.bad.inf[, c(6:31)], 
                                           method = "spearman")[1:23,-c(1:23)],
                                       rcorr(as.matrix(not.bad.inf[, c(6:31)]), 
                                             type = "spearman")$P[1:23,-c(1:23)]))
names(not.bad.inf.cor) <- c("inf","nat","qual","inf.p","nat.p","qual.p")

bad.nat.cor <- as.data.frame(cbind(cor(bad.nat[, c(6:31)], 
                                       method = "spearman")[1:23,-c(1:23)],
                                   rcorr(as.matrix(bad.nat[, c(6:31)]), 
                                         type = "spearman")$P[1:23,-c(1:23)]))
names(bad.nat.cor) <- c("inf","nat","qual","inf.p","nat.p","qual.p")
not.bad.nat.cor <- as.data.frame(cbind(cor(not.bad.nat[, c(6:31)], 
                                           method = "spearman")[1:23,-c(1:23)],
                                       rcorr(as.matrix(not.bad.nat[, c(6:31)]), 
                                             type = "spearman")$P[1:23,-c(1:23)]))
names(not.bad.nat.cor) <- c("inf","nat","qual","inf.p","nat.p","qual.p")

bad.q.cor <- as.data.frame(cbind(cor(bad.q[, c(6:31)], 
                                     method = "spearman")[1:23,-c(1:23)],
                                 rcorr(as.matrix(bad.q[, c(6:31)]), 
                                       type = "spearman")$P[1:23,-c(1:23)]))
names(bad.q.cor) <- c("inf","nat","qual","inf.p","nat.p","qual.p")
not.bad.q.cor <- as.data.frame(cbind(cor(not.bad.q[, c(6:31)], 
                                         method = "spearman")[1:23,-c(1:23)],
                                     rcorr(as.matrix(not.bad.q[, c(6:31)]), 
                                           type = "spearman")$P[1:23,-c(1:23)]))
names(not.bad.q.cor) <- c("inf","nat","qual","inf.p","nat.p","qual.p")

###### Correlation by MR Type (Tab.14) ######
inform <- subset(df, mr_type == "inform")
not.inform <- subset(df, mr_type != "inform")

inform.cor <- as.data.frame(cbind(cor(inform[, c(6:31)], 
                                      method = "spearman")[1:23,-c(1:23)],
                                  rcorr(as.matrix(inform[, c(6:31)]), 
                                        type = "spearman")$P[1:23,-c(1:23)]))
names(inform.cor) <- c("inf","nat","qual","inf.p","nat.p","qual.p")
not.inform.cor <- as.data.frame(cbind(cor(not.inform[, c(6:31)], 
                                          method = "spearman")[1:23,-c(1:23)],
                                      rcorr(as.matrix(not.inform[, c(6:31)]), 
                                            type = "spearman")$P[1:23,-c(1:23)]))
names(not.inform.cor) <- c("inf","nat","qual","inf.p","nat.p","qual.p")


diff <- as.data.frame(matrix(nrow=22, ncol = 3))

for (i in 6:27){
  diff[i-5,1] <- r.test(n=2101, r12=cor(inform$informativeness, inform[,i], method = "spearman"),
                        r34=cor(not.inform$informativeness, not.inform[,i], method = "spearman"),
                        n2=359)$p
  diff[i-5,2] <- r.test(n=2101, r12=cor(inform$naturalness, inform[,i], method = "spearman"),
                        r34=cor(not.inform$naturalness, not.inform[,i], method = "spearman"),
                        n2=359)$p
  diff[i-5,3] <- r.test(n=2101, r12=cor(inform$quality, inform[,i], method = "spearman"),
                        r34=cor(not.inform$quality, not.inform[,i], method = "spearman"),
                        n2=359)$p
}
names(diff)<-c("INF","NAT","QUA")
rownames(diff)<-colnames(inform[,6:27])
