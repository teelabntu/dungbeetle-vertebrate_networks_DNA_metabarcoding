####### DB Networks
####### Author: Xin Rui Ong
####### QPCR plots

# Setup ----
library(tidyverse)
library(gghalves)
library(ggthemes)
windowsFonts(Roboto=windowsFont("Roboto Condensed")) # Plot font setup :)

qpcr <- read.csv("data/qpcr/final_run_results.csv", 
               header=T, fileEncoding="UTF-8-BOM")

# Plot ----
colnames(qpcr)
qpcr2 <- na.omit(qpcr) # 16 rows removed
qpcr2$set_time_n <- as.factor(qpcr2$set_time)

qpcr2$gut <- factor(qpcr2$gut,
                   levels = c("Full",
                              "Partially full",
                              "Empty (with specks)",
                              "Empty"))

qpcr2 %>%
    ggplot() +
    geom_boxplot(aes(x = set_time_n, y = log_dna_c_n,
                     colour = storage, fill = storage),
                 width = 0.3, outlier.shape = NA, alpha = 0.7, 
                 position = position_dodge(0.5) ) +
    gghalves::geom_half_point(aes(x = set_time_n, y = log_dna_c_n,
                                  colour = storage,shape = gut),
                              side = "r",
                              range_scale = 0.2) +
  scale_fill_tableau() +
  scale_colour_tableau() +
  labs(x = "Set Time (h)",
       y = "Log (DNA Copy Number)",
       colour = "Storage",
       fill = "Storage",
       shape = "Gut Fullness") +
  theme_minimal() + 
  theme(text = element_text(family = "Roboto",
                            size = 14))

qpcr2 %>%
    ggplot() +
      geom_point(aes(x = set_time_n, y = log_dna_c_n,
                     colour = gut,
                     shape = storage),
                      size = 2,
                      alpha = .9,
                 position = position_jitterdodge(dodge.width = 0.3,
                                                 jitter.width = 0.15)) +
      scale_fill_tableau() +
      scale_colour_tableau() +
      labs(x = "Set Time (h)",
          y = "Log (DNA Copy Number)",
          colour = "Gut Fullness",
          shape = "Storage") +
      theme_minimal() + 
      theme(text = element_text(family = "Roboto",
                                size = 14))

qpcr2 %>%
  ggplot() +
  geom_point(aes(x = gut, y = log_dna_c_n),
             size = 1.3,
             alpha = .9) +
  scale_fill_tableau() +
  scale_colour_tableau() +
  labs(x = "Gut Fullness",
       y = "Log (DNA Copy Number)") +
  theme_minimal() + 
  theme(text = element_text(family = "Roboto",
                            size = 14))

qpcr %>%
  ggplot() +
  geom_boxplot(aes(x = gut, y = cq,
                   fill = gut),
               width = 0.2,
               outlier.shape = NA,
               alpha = 0.9, 
               position = position_dodge(0.3)) +
  geom_point(aes(x = gut, y = cq,
                 colour = gut),
             size = 1.3,
             alpha = .9,
             position = position_jitterdodge(dodge.width = 0.85,
                                             jitter.width = 0.1)) +
  scale_fill_tableau() +
  scale_colour_tableau() +
  labs(x = "Set Time",
       y = "Cq Value") +
  theme_minimal() + 
  theme(legend.position = "none",
        text = element_text(family = "Roboto",
                            size = 14))
