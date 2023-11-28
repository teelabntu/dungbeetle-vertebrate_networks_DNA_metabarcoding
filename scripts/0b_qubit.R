####### DB Networks
####### Author: Xin Rui Ong
####### Qubit results

# Setup ----
library(tidyverse)
library(gghalves)
library(ggthemes)
windowsFonts(Roboto=windowsFont("Roboto Condensed")) # Plot font setup :)

qubit <- read.csv("data/metabarcoding/qubit.csv", 
                 header=T, fileEncoding="UTF-8-BOM")

# Plot ----
colnames(qubit)

qubit$gut <- factor(qubit$gut,
                    levels = c("Full",
                               "Partially full",
                               "Empty (with specks)",
                               "Empty"))

qubit %>%
  ggplot() +
  geom_point(aes(x = species, y = qubit,
                 colour = gut),
             size = 2,
             alpha = .9,
             position = position_jitterdodge(dodge.width = 0.4,
                                             jitter.width = 0.4)) +
  scale_colour_tableau() +
  labs(x = "",
       y = "DNA concentration (ng/ul)",
       colour = "Gut Fullness") +
  theme_minimal() + 
  theme(text = element_text(family = "Roboto",
                            size = 14),
        legend.position = "bottom") +
  coord_flip()

qubit %>%
  ggplot() +
  geom_point(aes(x = gut, y = qubit,
                 colour = gut),
             size = 2,
             alpha = .9,
             position = position_jitterdodge(dodge.width = 0.4,
                                             jitter.width = 0.4)) +
  scale_colour_tableau() +
  labs(x = "",
       y = "DNA concentration (ng/ul)",
       colour = "") +
  theme_minimal() + 
  theme(text = element_text(family = "Roboto",
                            size = 18),
        legend.position = "none")
