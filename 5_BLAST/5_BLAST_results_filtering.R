####### DNA Metabarcoding of dung beetle gut contents
####### Author: Xin Rui Ong
####### 5. BLAST results filtering

# Setup ----
library(tidyverse)
library(reshape2)

# Read data ----
blast_16S_OTU <- read.csv("5_BLAST/16S_OTU_seq_filtered_results.csv",
                  header = T)
blast_12S_OTU <- read.csv("5_BLAST/12S_OTU_seq_filtered_results_all.csv",
                          header = T)

# Filter BLAST results ----
## Criteria 1. Taxa = Phylum Chordata (select Eukaryota records first)
## Criteria 2. Query length at least 80 (i.e. > 79)
## Criteria 3. E-value less than 1e-10
## Retain matches with highest percentage identity (pident), longest query length and lowest E-value

## Filter 16S OTU BLAST results ----
## Obtain BLAST scores for all assigned taxonomies in each OTU
filtered_16S_blast_scores <- blast_16S_OTU %>%
  # Filter criterias 1 to 3
  filter(sskingdoms == "Eukaryota" & evalue <1e-10 & length > 79) %>%
  group_by(qseid) %>%
  # Select lowest e-value
  filter(evalue == min(evalue)) %>%
  group_by(qseid) %>%
  # Select longest query length
  filter(length == max(length)) %>%
  group_by(qseid) %>%
  # Select highest percentage identity
  filter(pident == max(pident)) %>%
  group_by(qseid, sscinames) %>%
  # Select unique OTUs and assigned taxonomy
  slice(1)

## For each OTU, identify the assigned taxonomy with highest number of BLAST matches
filtered_16S_OTU_tophit <- blast_16S_OTU %>%
  # Filter criterias 1 to 3
  filter(sskingdoms == "Eukaryota" & evalue <1e-10 & length > 79) %>%
  group_by(qseid) %>%
  # Select lowest e-value
  filter(evalue == min(evalue)) %>%
  group_by(qseid) %>%
  # Select longest query length
  filter(length == max(length)) %>%
  group_by(qseid) %>%
  # Select highest percentage identity
  group_by(qseid, sscinames) %>%
  # Tally number of BLAST matches for each assigned taxonomy in each OTU
  tally() %>%
  group_by(qseid) %>%
  # Select taxonomy with highest number of BLAST matches
  filter(n == max(n))

## Filter 12S OTU BLAST results ----
## Obtain BLAST scores for all assigned taxonomies in each OTU
filtered_12S_blast_scores <- blast_12S_OTU %>%
  # Filter criterias 1 to 3
  filter(sskingdoms == "Eukaryota" & evalue <1e-10 & length > 79) %>%
  group_by(qseid) %>%
  # Select lowest e-value
  filter(evalue == min(evalue)) %>%
  group_by(qseid) %>%
  # Select longest query length
  filter(length == max(length)) %>%
  group_by(qseid) %>%
  # Select highest percentage identity
  filter(pident == max(pident)) %>%
  group_by(qseid, sscinames) %>%
  # Select unique OTUs and assigned taxonomy
  slice(1)

## For each OTU, identify the assigned taxonomy with highest number of BLAST matches
filtered_12S_OTU_tophit <- blast_12S_OTU %>%
  # Filter criterias 1 to 3
  filter(sskingdoms == "Eukaryota" & evalue <1e-10 & length > 79) %>%
  group_by(qseid) %>%
  # Select lowest e-value
  filter(evalue == min(evalue)) %>%
  group_by(qseid) %>%
  # Select longest query length
  filter(length == max(length)) %>%
  group_by(qseid) %>%
  # Select highest percentage identity
  group_by(qseid, sscinames) %>%
  # Tally number of BLAST matches for each assigned taxonomy in each OTU
  tally() %>%
  group_by(qseid) %>%
  # Select taxonomy with highest number of BLAST matches
  filter(n == max(n))

# Save filtered results ----
write.csv(filtered_16S_blast_scores,
          "5_BLAST/16S_OTU_all_blast_scores.csv")
write.csv(filtered_16S_OTU_tophit,
          "5_BLAST/16S_OTU_assigned_taxonomy_tophit.csv")

write.csv(filtered_12S_blast_scores,
          "5_BLAST/12S_OTU_all_blast_scores.csv")
write.csv(filtered_12S_OTU_tophit,
          "5_BLAST/12S_OTU_assigned_taxonomy_tophit.csv")

