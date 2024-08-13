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

# Quality filtering for 16S OTU matrix ----
## Determine total number of reads
all_16S<- raw_16S_OTU %>%
  select_if(is.numeric) %>%
  rowSums()
sum(all_16S)

## Select OTUs with sequences & with samples
seq_16S_OTU <- raw_16S_OTU %>%
  select("ID", "Seq") %>% t() %>%
  as.data.frame() %>%
  rownames_to_column() %>%
  row_to_names(1)
samples_16S_OTU <- raw_16S_OTU %>% select(starts_with(c("ID", "M")))

## Filtering Step 1. Remove contamination detected in negatives and blanks  ----
## Find maximum read count (maxcon) in negative and blanks columns & merge with samples
maxcon_16S_OTU <- raw_16S_OTU %>% select(starts_with(c("B", "N"))) %>%
  rowwise() %>%
  mutate(maxcon = max(c_across(B10C_1:Negative8_3_2))) %>%
  select("maxcon")

working_16S_OTU1 <- cbind(maxcon_16S_OTU, samples_16S_OTU)

## Convert read counts within each sample/OTU that are lower than maxcon to 0
working_16S_OTU2 <- working_16S_OTU1 %>% 
  mutate(across(where(is.numeric),
                ~ if_else(get(cur_column()) < maxcon, 0, get(cur_column()))))

### Determine number of reads after this step
all_working_16S_OTU2 <- working_16S_OTU2 %>%
  select(-"maxcon") %>%
  select_if(is.numeric) %>%
  rowSums()
sum(all_working_16S_OTU2)

## Filtering Step 2. Account for sample contamination ----
## Remove read counts within a sample that were less than 1% of total read count
## Sum up total no of reads per sample and calculate 1% of reads (sample_1)
working_16S_OTU3 <- working_16S_OTU2 %>% select(-"maxcon") %>%
  pivot_longer(-ID) %>%
  pivot_wider(name, names_from = "ID", values_from = "value") %>%
  rename(ID = name)

sample_1_16S_OTU <- working_16S_OTU3 %>%
  select(starts_with(c("OTU"))) %>%
  rowwise() %>%
  mutate(sample_sum = sum(c_across(OTU_1:OTU_995)),
         sample_1 = sample_sum * 0.01) %>%
  select("sample_1")

working_16S_OTU4 <- cbind(sample_1_16S_OTU, working_16S_OTU3)

## Convert read counts within each sample/OTU that are lower than sample_1 to 0
working_16S_OTU5 <- working_16S_OTU4 %>% 
  mutate(across(where(is.numeric),
                ~ if_else(get(cur_column()) < sample_1, 0, get(cur_column()))))

### Determine number of reads after this step
all_working_16S_OTU5 <- working_16S_OTU5 %>%
  select(-"sample_1") %>%
  select_if(is.numeric) %>%
  rowSums()
sum(all_working_16S_OTU5)

## Filtering Step 3. Remove low-frequency artefacts (read counts less than 10) ----
## Convert read counts within each sample/OTU less than 10 to 0
working_16S_OTU6 <- working_16S_OTU5 %>% select(-"sample_1") %>%
  mutate(across(where(is.numeric),
                ~ if_else(get(cur_column()) < 10, 0, get(cur_column()))))

### Determine number of reads after this step
all_working_16S_OTU6 <- working_16S_OTU6 %>%
  select_if(is.numeric) %>%
  rowSums()
sum(all_working_16S_OTU6)

## Save filtered 16S sequences and reads ----
final_16S_OTU <- rbind(seq_16S_OTU, working_16S_OTU6)
write.csv(final_16S_OTU, "4_Post-apscale/16S_OTU_filtered.csv",
          row.names = F)

# Quality filtering for 12S OTU matrix ----
## Determine total number of reads
all_12S<- raw_12S_OTU %>%
  select_if(is.numeric) %>%
  rowSums()
sum(all_12S)

## Select OTUs with sequences & with samples
seq_12S_OTU <- raw_12S_OTU %>%
  select("ID", "Seq") %>% t() %>%
  as.data.frame() %>%
  rownames_to_column() %>%
  row_to_names(1)
samples_12S_OTU <- raw_12S_OTU %>% select(starts_with(c("ID", "M")))

## Filtering Step 1. Remove contamination detected in negatives and blanks  ----
## Find maximum read count (maxcon) in negative and blanks columns & merge with samples
maxcon_12S_OTU <- raw_12S_OTU %>% select(starts_with(c("B", "N"))) %>%
  rowwise() %>%
  mutate(maxcon = max(c_across(B10C_1:Negative_P8_3))) %>%
  select("maxcon")

working_12S_OTU1 <- cbind(maxcon_12S_OTU, samples_12S_OTU)

## Convert read counts within each sample/OTU that are lower than maxcon to 0
working_12S_OTU2 <- working_12S_OTU1 %>% 
  mutate(across(where(is.numeric),
                ~ if_else(get(cur_column()) < maxcon, 0, get(cur_column()))))

### Determine number of reads after this step
all_working_12S_OTU2 <- working_12S_OTU2 %>%
  select(-"maxcon") %>%
  select_if(is.numeric) %>%
  rowSums()
sum(all_working_12S_OTU2)

## Filtering Step 2. Account for sample contamination ----
## Remove read counts within a sample that were less than 1% of total read count
## Sum up total no of reads per sample and calculate 1% of reads (sample_1)
working_12S_OTU3 <- working_12S_OTU2 %>% select(-"maxcon") %>%
  pivot_longer(-ID) %>%
  pivot_wider(name, names_from = "ID", values_from = "value") %>%
  rename(ID = name)

sample_1_12S_OTU <- working_12S_OTU3 %>%
  select(starts_with(c("OTU"))) %>%
  rowwise() %>%
  mutate(sample_sum = sum(c_across(OTU_1:OTU_9147)),
         sample_1 = sample_sum * 0.01) %>%
  select("sample_1")

working_12S_OTU4 <- cbind(sample_1_12S_OTU, working_12S_OTU3)

## Convert read counts within each sample/OTU that are lower than sample_1 to 0
working_12S_OTU5 <- working_12S_OTU4 %>% 
  mutate(across(where(is.numeric),
                ~ if_else(get(cur_column()) < sample_1, 0, get(cur_column()))))

### Determine number of reads after this step
all_working_12S_OTU5 <- working_12S_OTU5 %>%
  select(-"sample_1") %>%
  select_if(is.numeric) %>%
  rowSums()
sum(all_working_12S_OTU5)

## Filtering Step 3. Remove low-frequency artefacts (read counts less than 10) ----
## Convert read counts within each sample/OTU less than 10 to 0
working_12S_OTU6 <- working_12S_OTU5 %>% select(-"sample_1") %>%
  mutate(across(where(is.numeric),
                ~ if_else(get(cur_column()) < 10, 0, get(cur_column()))))

### Determine number of reads after this step
all_working_12S_OTU6 <- working_12S_OTU6 %>%
  select_if(is.numeric) %>%
  rowSums()
sum(all_working_12S_OTU6)

## Save filtered 12S sequences and reads ----
final_12S_OTU <- rbind(seq_12S_OTU, working_12S_OTU6)
write.csv(final_12S_OTU, "4_Post-apscale/12S_OTU_filtered.csv",
          row.names = F)
