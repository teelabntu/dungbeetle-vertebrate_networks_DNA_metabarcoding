####### DNA Metabarcoding of dung beetle gut contents
####### Author: Xin Rui Ong
####### 6. Data cleaning

library(tidyverse)

# Read data ----
samples_16S_OTU <- read.csv("6_Data_Cleaning/16S_OTU_filtered2.csv",
                   header = T)
samples_12S_OTU <- read.csv("6_Data_Cleaning/12S_OTU_filtered2.csv",
                            header = T)

nOTU_16S <- read.csv("6_Data_Cleaning/16S_OTU_final_assignment.csv",
                     header = T)
nOTU_12S <- read.csv("6_Data_Cleaning/12S_OTU_final_assignment.csv",
                     header = T) 

# Combine sample replicates ----
combined_16S_OTU <- samples_16S_OTU %>%
  group_by(ID) %>%
  summarise_each(funs(sum))

combined_12S_OTU <- samples_12S_OTU %>%
  group_by(ID) %>%
  summarise_each(funs(sum))

# Final OTU assignment ----
names(combined_16S_OTU)[match(nOTU_16S[,"qseid"], names(combined_16S_OTU))] = nOTU_16S[,"nOTU"]
names(combined_12S_OTU)[match(nOTU_12S[,"qseid"], names(combined_12S_OTU))] = nOTU_12S[,"nOTU"]

# Save matrices ----
write.csv(combined_16S_OTU,
          "6_Data_Cleaning/16S_OTU_matrix.csv")
write.csv(combined_12S_OTU,
          "6_Data_Cleaning/12S_OTU_matrix.csv")

#### Remove non-assigned OTUs in excel and reimport files to combine reads across each OTU

# Read data again ----
matrix_16S_OTU <- read.csv("6_Data_Cleaning/16S_OTU_matrix2.csv",
                            header = T)
matrix_12S_OTU <- read.csv("6_Data_Cleaning/12S_OTU_matrix2.csv",
                            header = T)

# Combine OTU/ESV replicates ----
matrix3_16S_OTU <- matrix_16S_OTU %>%
  group_by(ID) %>%
  summarise_each(funs(sum))

matrix3_12S_OTU <- matrix_12S_OTU %>%
  group_by(ID) %>%
  summarise_each(funs(sum))

# Save matrices again ----
write.csv(matrix3_16S_OTU,
          "6_Data_Cleaning/16S_OTU_matrix3.csv")
write.csv(matrix3_12S_OTU,
          "6_Data_Cleaning/12S_OTU_matrix3.csv")