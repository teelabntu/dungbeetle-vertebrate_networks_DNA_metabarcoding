####### DNA Metabarcoding of dung beetle gut contents
####### Author: Xin Rui Ong
####### 5. BLAST results filtering

# Setup ----
library(tidyverse)
library(reshape2)

# Read data ----
blast_16S_OTU <- read.csv("5_BLAST/16S_OTU_HitTable.csv",
                  header = T)
blast_12S_OTU <- read.csv("5_BLAST/12S_OTU_ALL_HitTable.csv",
                          header = T)
glimpse(blast_16S_OTU)
glimpse(blast_12S_OTU)

## Criteria 1. Query length at least 80 (i.e. > 79)
## Criteria 2. E-value less than 1e-10
## Retain matches with highest percentage identity (pident), longest query length and lowest E-value

## For each OTU, filter based on criteria 1 & 2 & retain highest pident, long ----
filtered_16S_OTU_filtered <- blast_16S_OTU %>%
  # Filter criteria 1 & 2
  filter(evalue <1e-10 & length > 79) %>%
  group_by(qseid) %>%
  # Select lowest e-value
  filter(evalue == min(evalue)) %>%
  group_by(qseid) %>%
  # Select longest query length
  filter(length == max(length)) %>%
  group_by(qseid) %>%
  # Select highest percentage identity
  filter(pident == max(pident)) %>%
  group_by(qseid, sseqid) %>%
  # Tally number of BLAST matches for each assigned taxonomy in each OTU
  tally()

filtered_12S_OTU_filtered <- blast_12S_OTU %>%
  # Filter criteria 1 & 2
  filter(evalue <1e-10 & length > 79) %>%
  group_by(qseid) %>%
  # Select lowest e-value
  filter(evalue == min(evalue)) %>%
  group_by(qseid) %>%
  # Select longest query length
  filter(length == max(length)) %>%
  group_by(qseid) %>%
  # Select highest percentage identity
  filter(pident == max(pident)) %>%
  group_by(qseid, sseqid) %>%
  # Tally number of BLAST matches for each assigned taxonomy in each OTU
  tally()

## Obtain Query length,	Percentage identity (%),	e-value &	bitscore
stats_16S <- blast_16S_OTU %>%
  # Filter criteria 1 & 2
  filter(evalue <1e-10 & length > 79) %>%
  group_by(qseid) %>%
  # Select lowest e-value
  filter(evalue == min(evalue)) %>%
  group_by(qseid) %>%
  # Select longest query length
  filter(length == max(length)) %>%
  group_by(qseid) %>%
  # Select highest percentage identity
  filter(pident == max(pident)) %>%
  group_by(qseid) %>%
  slice(1)

stats_12S <- blast_12S_OTU %>%
  # Filter criteria 1 & 2
  filter(evalue <1e-10 & length > 79) %>%
  group_by(qseid) %>%
  # Select lowest e-value
  filter(evalue == min(evalue)) %>%
  group_by(qseid) %>%
  # Select longest query length
  filter(length == max(length)) %>%
  group_by(qseid) %>%
  # Select highest percentage identity
  filter(pident == max(pident)) %>%
  group_by(qseid) %>%
  slice(1)

## Retrieve csv of unique OTUs for taxonomy retrieval
unique_16S_OTU <- unique(filtered_16S_OTU_tophit$sseqid)
unique_12S_OTU <- unique(filtered_12S_OTU_tophit$sseqid)

# Save filtered results ----
write.csv(filtered_16S_OTU_tophit,
          "5_BLAST/16S_OTU_HitTable_filtered.csv")
write.csv(filtered_12S_OTU_tophit,
          "5_BLAST/12S_OTU_HitTable_filtered.csv")

# Save sseqid as text to retrieve scientific and common names via entrez
writeLines(unique_16S_OTU,
           "5_BLAST/16S_OTU_unique.txt")
writeLines(unique_12S_OTU,
           "5_BLAST/12S_OTU_unique.txt")