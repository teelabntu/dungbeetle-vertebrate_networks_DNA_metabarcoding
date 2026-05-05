####### DNA Metabarcoding of dung beetle gut contents
####### Author: Xin Rui Ong
####### 6. Data cleaning

library(tidyverse)
library(readxl)

# Read data ----
## 16S & 12S mapped OTUs ----
nOTU_16S <- read_xlsx("6_Data_Cleaning/16S_OTU_TopHits_edited.xlsx",
                      sheet = "Finalised", col_names = T)
nOTU_12S <- read_xlsx("6_Data_Cleaning/12S_OTU_TopHits_edited.xlsx",
                      sheet = "Finalised", col_names = T) 

nOTU_16S <- nOTU_16S %>% select(qseid, qseid_new)
nOTU_12S <- nOTU_12S %>% select(qseid, qseid_new)

## Formatted 16S & 12S matrix (post-bioinformatics filtering) ----
samples_16S_OTU <- read.csv("6_Data_Cleaning/16S_OTU_filtered_v2.csv",
                            header = T)
samples_12S_OTU <- read.csv("6_Data_Cleaning/12S_OTU_filtered_v2.csv",
                            header = T)

# Combine sample replicates & assigned mapped OTUs ----
## Process 16S Reads
combined_replicates_16S <- samples_16S_OTU %>%
  group_by(ID) %>%
  summarise(across(everything(), sum))

combined_replicates_16S_t <-
  combined_replicates_16S %>% 
  t() %>% 
  janitor::row_to_names(row_number = 1) %>% 
  type.convert(as.is=TRUE) %>%
  as.data.frame() %>%
  tibble::rownames_to_column("ID")

combined_assigned_16S <-
  combined_replicates_16S_t %>%
  left_join(nOTU_16S, by = join_by(ID == qseid)) %>%
  relocate(ID, qseid_new) %>%
  na.omit() %>%
  select(!ID) %>%
  group_by(qseid_new) %>%
  summarise(across(everything(), sum))

## Process 12S Reads
combined_replicates_12S <- samples_12S_OTU %>%
  group_by(ID) %>%
  summarise(across(everything(), sum))

combined_replicates_12S_t <-
  combined_replicates_12S %>% 
  t() %>% 
  janitor::row_to_names(row_number = 1) %>% 
  type.convert(as.is=TRUE) %>%
  as.data.frame() %>%
  tibble::rownames_to_column("ID")

combined_assigned_12S <-
  combined_replicates_12S_t %>%
  left_join(nOTU_12S, by = join_by(ID == qseid)) %>%
  relocate(ID, qseid_new) %>%
  na.omit() %>%
  select(!ID) %>%
  group_by(qseid_new) %>%
  summarise(across(everything(), sum))

# Save matrices ----
write.csv(combined_assigned_16S,
          "6_Data_Cleaning/16S_OTU_matrix.csv")
write.csv(combined_assigned_12S,
          "6_Data_Cleaning/12S_OTU_matrix.csv")
