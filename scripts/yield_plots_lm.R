######## still work in progress ########

# edit edit

# load libraries
library(ggplot2) ## for plotting
library(dplyr) ## for data manipulation

# read data
yield <- read.csv("data/DNA yield_cleaned.csv", header=T)
colnames(yield)[1] <-"SpecimenID" ## rename first column header
names(yield) ## check all column headers
str(yield) ## check data frame
yield$TimePt <- as.factor(yield$TimePt) # change TimePt to factor
str(yield) ## check again

# filter data by species
yield_Catharsius <- yield %>% filter(Species == "Catharsius_molossus")
yield_Paragymnopleurus <- yield %>% filter(Species == "Paragymnopleurus_maurus")
yield_Onthophagus <- yield %>% filter(Species == "Onthophagus_babirussa")

# plot data

yield_Catharsius %>% ggplot()+
  geom_boxplot(aes(x=TimePt, y=DNAYield, fill=Storage))+
  xlab("Time Point")+
  ylab(expression(paste("DNA Yield (", mu, "g)"))) +
  ggtitle(expression(paste(italic("Catharsius molossus"))))+
  theme_classic()

yield_Paragymnopleurus %>% ggplot()+
  geom_boxplot(aes(x=TimePt, y=DNAYield, fill=Extraction))+
  xlab("Time Point")+
  ylab(expression(paste("DNA Yield (", mu, "g)"))) +
  ggtitle(expression(paste(italic("Paragymnopleurus maurus"))))+
  theme_classic()

yield_Onthophagus %>% ggplot()+
  geom_boxplot(aes(x=TimePt, y=DNAYield, fill=Storage))+
  facet_wrap(~Extraction)+
  xlab("Time Point")+
  ylab(expression(paste("DNA Yield (", mu, "g)"))) +
  ggtitle(expression(paste(italic("Onthophagus babirussa"))))+
  theme_bw()

# linear models
## Catharsius models
catharsius_m1<-lm(DNAYield~TimePt+Storage, data=yield_Catharsius)
catharsius_m2<-lm(DNAYield~TimePt*Storage, data=yield_Catharsius)
anova(catharsius_m1,catharsius_m2)

anova(catharsius_m2)

## Paragymnopleurus models
paragymnopleurus_m1<-lm(DNAYield~TimePt+Extraction, data=yield_Paragymnopleurus)
paragymnopleurus_m2<-lm(DNAYield~TimePt*Extraction, data=yield_Paragymnopleurus)

anova(paragymnopleurus_m1, paragymnopleurus_m2)

anova(paragymnopleurus_m1)

## Onthophagus models
onthophagus_m1<-lm(DNAYield~TimePt+Storage, data=yield_Onthophagus)
onthophagus_m2<-lm(DNAYield~TimePt+Storage+Extraction, data=yield_Onthophagus)

anova(onthophagus_m1, onthophagus_m2)

onthophagus_m3<-lm(DNAYield~TimePt*Storage, data=yield_Onthophagus)
anova(onthophagus_m1, onthophagus_m3)

anova(onthophagus_m3)

## all combined
m1 <- lm(DNAYield~TimePt + Storage + Extraction, data=yield)
m2 <- lm(DNAYield~TimePt * Storage + Extraction, data=yield)
anova(m1,m2)
m3 <- lm(DNAYield~TimePt + Storage + Extraction + TimePt:Storage + TimePt:Extraction, data=yield)
anova(m2, m3)
anova(m3)

m1 <- lm(DNAYield~TimePt + Storage, data=yield)
m2 <- lm(DNAYield~TimePt * Storage, data=yield)
anova(m1,m2)

# interaction.plot(x.factor=yield$TimePt, trace.factor=yield$Storage, response=yield$DNAYield)
# interaction.plot(x.factor=yield$TimePt, trace.factor=yield$Extraction, response=yield$DNAYield)
# interaction.plot(x.factor=yield$Storage, trace.factor=yield$Extraction, response=yield$DNAYield)