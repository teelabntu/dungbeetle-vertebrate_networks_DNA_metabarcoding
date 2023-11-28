####### DB Networks
####### Author: Xin Rui Ong
####### OTU Raw Reads Filtering

# Setup ----
library(tidyverse)

# Read data
raw <- read.csv("data/metabarcoding/16SOTU_raw.csv", header = T)

# Find maximum read count in blanks and negative columns
max_con <- raw %>% select(starts_with(c("ID", "B", "N"))) %>%
  rowwise() %>%
  mutate(max_con = max(c_across(B10C_1:Negative8_3_2))) %>%
  select("ID", "max_con")


