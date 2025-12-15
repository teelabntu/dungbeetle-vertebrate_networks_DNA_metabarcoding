####### DNA Metabarcoding of dung beetle gut contents
####### Author: Xin Rui Ong
####### 4. Post-bioinformatics filtering

# Setup ----
library(tidyverse)
library(data.table)
library(janitor)

# Read 16S and 12S OTU matrix generated from APSCALE ----
raw_16S_OTU <- read.csv("4_Post-apscale/16S_OTU_raw.csv",
                        header = T)
raw_12S_OTU <- read.csv("4_Post-apscale/12S_OTU_raw.csv",
                        header = T)

# Analyse 16S OTU matrix ----
## Step 0. Check initial total number of reads for each dataset ----
## Determine total number of reads
all_16S <- raw_16S_OTU %>%
  select_if(is.numeric) %>%
  rowSums()
sum(all_16S)

## Extract OTU & barcodes for left_joining
OTU_Table <-
  raw_16S_OTU %>%
  select(ID, Seq)

## Filtering Step 1. Remove low-frequency artefacts (read counts less than 10) ----
### Convert read counts within each sample/OTU less than 10 to 0
working_16S_OTU1 <- 
  raw_16S_OTU %>% 
  mutate(across(where(is.numeric),
                ~ if_else(get(cur_column()) < 10, 0, get(cur_column()))))

### Remove OTUs that now have 0 reads after Filtering Step 1
working_16S_OTU2 <-
  working_16S_OTU1 %>%
  mutate(OTU_sum = rowSums(across(where(is.numeric)))) %>%
  filter(OTU_sum != 0) # 649 OTUs (94 OTUs removed)

### Determine number of reads after this step
all_working_16S_OTU2 <- working_16S_OTU2 %>%
  select(-OTU_sum) %>%
  select_if(is.numeric) %>%
  rowSums()
sum(all_working_16S_OTU2)

## Filtering Step 2. Account for sample contamination ----
## Remove read counts within a sample that were less than 1% of total read count
## Sum up total no of reads per sample and calculate 1% of reads (sample_1)
# Transpose from <row:OTU & column:sample> to <row:sample & column:OTU>
working_16S_OTU3 <-
  working_16S_OTU2 %>%
  select(!c("Seq", "OTU_sum")) %>%
  pivot_longer(-ID) %>%
  pivot_wider(names_from = "ID", values_from = "value") %>%
  rename(ID = name)

working_16S_OTU4 <-
  working_16S_OTU3 %>%
  mutate(sample_sum = rowSums(across(where(is.numeric))),
         sample_1 = sample_sum * 0.01)

## Convert read counts within each sample/OTU that are lower than sample_1 to 0
working_16S_OTU5 <- working_16S_OTU4 %>% 
  mutate(across(where(is.numeric),
                ~ if_else(get(cur_column()) < sample_1, 0, get(cur_column()))))

## Transpose back to original dataframe layout <row:OTU & column:sample>
working_16S_OTU6 <-
  working_16S_OTU5 %>%
  select(!c("sample_sum", "sample_1")) %>%
  pivot_longer(-ID) %>%
  pivot_wider(names_from = "ID", values_from = "value") %>%
  rename(ID = name)

### Remove OTUs that now have 0 reads after Filtering Step 2
working_16S_OTU7 <-
  working_16S_OTU6 %>%
  mutate(OTU_sum = rowSums(across(where(is.numeric)))) %>%
  filter(OTU_sum != 0) # 531 OTUs (118 OTUs removed)

### Determine number of reads after this step
all_working_16S_OTU7 <- working_16S_OTU7 %>%
  select(-OTU_sum) %>%
  select_if(is.numeric) %>%
  rowSums()
sum(all_working_16S_OTU7)

## Filtering Step 3. Remove contaimnation detected in negatives and blanks ----
blank_negVSsample_16S <-  
  working_16S_OTU7 %>%
  select(-OTU_sum) %>%
  rowwise() %>%
  mutate(BN_NonZero = sum(c_across(starts_with(c("B", "N"))) != 0),
         Sample_NonZero = sum(c_across(starts_with(c("M"))) != 0)) %>%
  relocate(ID, BN_NonZero, Sample_NonZero)

blank_negVSsample_16S_final <-
  blank_negVSsample_16S %>%
  filter(!(BN_NonZero > 5 & Sample_NonZero < 5)) %>%
  left_join(OTU_Table, by = "ID") %>%
  relocate(ID, Seq)

### Determine number of reads after this step
blank_negVSsample_16S_sum <- blank_negVSsample_16S_final %>%
  select(-c("Seq", "BN_NonZero", "Sample_NonZero")) %>%
  select_if(is.numeric) %>%
  rowSums()
sum(blank_negVSsample_16S_sum)

## Save filtered 16S sequences and reads ----
write.csv(blank_negVSsample_16S_final,, "4_Post-apscale/16S_OTU_filtered.csv",
          row.names = F)

###############################################################################
# Analyse 12S OTU matrix ----
## Step 0. Check initial total number of reads for each dataset ----
## Determine total number of reads
all_12S <- raw_12S_OTU %>%
  select_if(is.numeric) %>%
  rowSums()
sum(all_12S)

## Extract OTU & barcodes for left_joining
OTU_Table <-
  raw_12S_OTU %>%
  select(ID, Seq)

## Filtering Step 1. Remove low-frequency artefacts (read counts less than 10) ----
### Convert read counts within each sample/OTU less than 10 to 0
working_12S_OTU1 <- 
  raw_12S_OTU %>% 
  mutate(across(where(is.numeric),
                ~ if_else(get(cur_column()) < 10, 0, get(cur_column()))))

### Remove OTUs that now have 0 reads after Filtering Step 1
working_12S_OTU2 <-
  working_12S_OTU1 %>%
  mutate(OTU_sum = rowSums(across(where(is.numeric)))) %>%
  filter(OTU_sum != 0) # 6972 OTUs (1906 OTUs removed)

### Determine number of reads after this step
all_working_12S_OTU2 <- working_12S_OTU2 %>%
  select(-OTU_sum) %>%
  select_if(is.numeric) %>%
  rowSums()
sum(all_working_12S_OTU2)

## Filtering Step 2. Account for sample contamination ----
## Remove read counts within a sample that were less than 1% of total read count
## Sum up total no of reads per sample and calculate 1% of reads (sample_1)
# Transpose from <row:OTU & column:sample> to <row:sample & column:OTU>
working_12S_OTU3 <-
  working_12S_OTU2 %>%
  select(!c("Seq", "OTU_sum")) %>%
  pivot_longer(-ID) %>%
  pivot_wider(names_from = "ID", values_from = "value") %>%
  rename(ID = name)

working_12S_OTU4 <-
  working_12S_OTU3 %>%
  mutate(sample_sum = rowSums(across(where(is.numeric))),
         sample_1 = sample_sum * 0.01)

## Convert read counts within each sample/OTU that are lower than sample_1 to 0
working_12S_OTU5 <- working_12S_OTU4 %>% 
  mutate(across(where(is.numeric),
                ~ if_else(get(cur_column()) < sample_1, 0, get(cur_column()))))

## Transpose back to original dataframe layout <row:OTU & column:sample>
working_12S_OTU6 <-
  working_12S_OTU5 %>%
  select(!c("sample_sum", "sample_1")) %>%
  pivot_longer(-ID) %>%
  pivot_wider(names_from = "ID", values_from = "value") %>%
  rename(ID = name)

### Remove OTUs that now have 0 reads after Filtering Step 2
working_12S_OTU7 <-
  working_12S_OTU6 %>%
  mutate(OTU_sum = rowSums(across(where(is.numeric)))) %>%
  filter(OTU_sum != 0) # 3895 OTUs (3077 OTUs removed)

### Determine number of reads after this step
all_working_12S_OTU7 <- working_12S_OTU7 %>%
  select(-OTU_sum) %>%
  select_if(is.numeric) %>%
  rowSums()
sum(all_working_12S_OTU7)

## Filtering Step 3. Remove contaimnation detected in negatives and blanks ----
blank_negVSsample_12S <-  
  working_12S_OTU7 %>%
  select(-OTU_sum) %>%
  rowwise() %>%
  mutate(BN_NonZero = sum(c_across(starts_with(c("B", "N"))) != 0),
         Sample_NonZero = sum(c_across(starts_with(c("M"))) != 0)) %>%
  relocate(ID, BN_NonZero, Sample_NonZero)

blank_negVSsample_12S_final <-
  blank_negVSsample_12S %>%
  filter(!(BN_NonZero > 5 & Sample_NonZero < 5)) %>%
  left_join(OTU_Table, by = "ID") %>%
  relocate(ID, Seq)

### Determine number of reads after this step
blank_negVSsample_12S_sum <- blank_negVSsample_12S_final %>%
  select(-c("Seq", "BN_NonZero", "Sample_NonZero")) %>%
  select_if(is.numeric) %>%
  rowSums()
sum(blank_negVSsample_12S_sum)

## Save filtered 12S sequences and reads ----
write.csv(blank_negVSsample_12S_final,, "4_Post-apscale/12S_OTU_filtered.csv",
          row.names = F)