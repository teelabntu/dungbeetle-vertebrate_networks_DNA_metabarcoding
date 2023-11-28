####### DB Networks
####### Author: Xin Rui Ong
####### BLAST results filtering & Sample combining

# Setup ----
library(tidyverse)
library(reshape2)

# Read data
blast <- read.csv("data/metabarcoding/N976WE75013-Alignment-HitTable.csv",
                  header = T)
str(blast)

# Filter out hits with percentage identity < 90, bitscore > 99
# Sort by highest bitscore and lowest evalue
# select top 3 hits with highest bit score

filtered <- blast %>% filter(pident > 89.99,
                 bitscore > 99,
                 evalue < 1e-10) %>%
  arrange(desc(bitscore),
          evalue) %>%
  group_by(ID) %>%
  slice(1:3)

# Save filtered dataset
write.csv(filtered,
          "data/metabarcoding/N976WE75013-Alignment-HitTable_filtered.csv")

## Combining sample replicates ----
sample <- read.csv("data/metabarcoding/16S_samples.csv",
                   header = T)
str(sample)

combined <- sample %>%
  group_by(ID2) %>%
  summarise_each(funs(sum), -ID)

write.csv(combined, "data/metabarcoding/16S_samples_combined.csv")




