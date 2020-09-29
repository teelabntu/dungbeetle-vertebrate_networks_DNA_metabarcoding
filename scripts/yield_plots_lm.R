######## still work in progress ########

# load libraries
library(ggplot2) ## for plotting
library(dplyr) ## for data manipulation

# read data
yield <- read.csv("data/DNA yield_cleaned.csv", header=T)
colnames(yield)[1] <-"SpecimenID" ## rename first column header
names(yield) ## check all column headers
str(yield) ## check data frame

# plot data
ggplot()+
  geom_point(data=yield, aes(x=TimePt, y=DNAYield, colour=Species))
