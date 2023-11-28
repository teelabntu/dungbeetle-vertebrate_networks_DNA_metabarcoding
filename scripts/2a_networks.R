####### DB Networks
####### Author: Xin Rui Ong
####### Network Construction

library(tidyverse)
# Read & Format Data ----
ground <- read.csv("data/metabarcoding/networks/ground.csv",
                   header = T)
canopy <- read.csv("data/metabarcoding/networks/canopy.csv",
                   header = T)
vert_names <- read.csv("data/metabarcoding/vert_species_info.csv",
                       header = T)

ground_combined <- ground %>%
  group_by(Species) %>%
  summarise_each(funs(sum)) %>%
  t() %>%
  janitor::row_to_names(row_number = 1) %>%
  as.data.frame()

canopy_combined <- canopy %>%
  group_by(Species) %>%
  summarise_each(funs(sum)) %>%
  t() %>%
  janitor::row_to_names(row_number = 1) %>%
  as.data.frame()

write.csv(ground_combined, "data/metabarcoding/networks/ground_combined.csv")
write.csv(canopy_combined, "data/metabarcoding/networks/canopy_combined.csv")

# bipartite networks ----
library(reshape2)
library(bipartite)
library(tidyverse)

## Plot bipartite networks ----
plotweb(sortweb(ground_combined3, sort.order = "dec"), 
        method="normal", arrow="down.center",
        col.interaction=c("#4F6980FF",
                          "#849DB1FF",
                          "#A2CEAAFF",
                          "#638B66FF",
                          "#BFBB60FF",
                          "#F47942FF",
                          "#FBB04EFF",
                          "#B66353FF",
                          "#D7CE9FFF",
                          "#B9AA97FF",
                          "#7E756DFF"),
        bor.col.interaction=c("#4F6980FF",
                              "#849DB1FF",
                              "#A2CEAAFF",
                              "#638B66FF",
                              "#BFBB60FF",
                              "#F47942FF",
                              "#FBB04EFF",
                              "#B66353FF",
                              "#D7CE9FFF",
                              "#B9AA97FF",
                              "#7E756DFF"),
        col.low = c("gray20"),
        bor.col.low = c("gray20"),
        col.high=c("#4F6980FF",
                   "#849DB1FF",
                   "#A2CEAAFF",
                   "#638B66FF",
                   "#BFBB60FF",
                   "#F47942FF",
                   "#FBB04EFF",
                   "#B66353FF",
                   "#D7CE9FFF",
                   "#B9AA97FF",
                   "#7E756DFF"),
        bor.col.high=c("#4F6980FF",
                       "#849DB1FF",
                       "#A2CEAAFF",
                       "#638B66FF",
                       "#BFBB60FF",
                       "#F47942FF",
                       "#FBB04EFF",
                       "#B66353FF",
                       "#D7CE9FFF",
                       "#B9AA97FF",
                       "#7E756DFF"),
        ybig=1.1,
        low.spacing=0.01,
        high.spacing=0.02,
        low.lablength = 0,
        text.rot = 90)

# bipartiteD3 ----
library(tidyverse)
library(reshape2)
library(bipartite)
library(bipartiteD3)
library(r2d3)

# Format data for bipartiteD3
ground_combined2 <- read.csv("data/metabarcoding/networks/ground_combined2.csv")
canopy_combined2 <- read.csv("data/metabarcoding/networks/canopy_combined2.csv")

ground_melt <- melt(ground_combined2, id = c("X"))
ground_melt2 <- ground_melt %>% filter(value != 0)

canopy_melt <- melt(canopy_combined2, id = c("X"))
canopy_melt2 <- canopy_melt %>% filter(value != 0)

# Settings for ground network
SortGround <- c('XROTU_02',
                'XROTU_01',
                'XROTU_04',
                'XROTU_05',
                'XROTU_03',
                'XROTU_06',
                'XROTU_07',
                'XROTU_08',
                'XROTU_09',
                'XROTU_37',
                'XROTU_12',
                'XROTU_20',
                'XROTU_27',
                'XROTU_15',
                'XROTU_18',
                'XROTU_25',
                'XROTU_28',
                'XROTU_10',
                'XROTU_16',
                'XROTU_24',
                'XROTU_14',
                'XROTU_19',
                'XROTU_21',
                'XROTU_29',
                'XROTU_36',
                'XROTU_40',
                'XROTU_11',
                'XROTU_13',
                'XROTU_17',
                'XROTU_32',
                'XROTU_23',
                'XROTU_34',
                'XROTU_39')

ColourGround <- c('XROTU_02' = '#FFCC66FF',
                  'XROTU_01' = '#FFCC99FF',
                  'XROTU_04' = '#FF9933FF',
                  'XROTU_05' = '#664466FF',
                  'XROTU_03' = '#99CCFFFF',
                  'XROTU_06' = '#9999FFFF',
                  'XROTU_07' = '#CC6699FF',
                  'XROTU_08' = '#CC6666FF',
                  'XROTU_09' = '#006699FF',
                  'XROTU_37' = '#FF9966FF',
                  'XROTU_20' = '#CC99CCFF',
                  'XROTU_27' = '#4455BBFF',
                  'XROTU_12' = '#9977AAFF',
                  'XROTU_18' = '#9999CCFF',
                  'XROTU_25' = '#6688CCFF',
                  'XROTU_28' = '#774466FF',
                  'XROTU_15' = '#DD6644FF',
                  'XROTU_34' = '#d3d3d3',
                  'XROTU_10' = '#d3d3d3',
                  'XROTU_16' = '#d3d3d3',
                  'XROTU_24' = '#d3d3d3',
                  'XROTU_19' = '#d3d3d3',
                  'XROTU_21' = '#d3d3d3',
                  'XROTU_40' = '#d3d3d3',
                  'XROTU_14' = '#d3d3d3',
                  'XROTU_36' = '#d3d3d3',
                  'XROTU_29' = '#d3d3d3',
                  'XROTU_13' = '#d3d3d3',
                  'XROTU_32' = '#d3d3d3',
                  'XROTU_17' = '#d3d3d3',
                  'XROTU_11' = '#d3d3d3',
                  'XROTU_23' = '#d3d3d3',
                  'XROTU_39' = '#d3d3d3')

SortCanopy <- c('XROTU_01',
                'XROTU_02',
                'XROTU_04',
                'XROTU_05',
                'XROTU_20',
                'XROTU_03',
                'XROTU_31',
                'XROTU_09',
                'XROTU_18',
                'XROTU_06',
                'XROTU_07',
                'XROTU_08',
                'XROTU_37',
                'XROTU_25',
                'XROTU_23',
                'XROTU_10',
                'XROTU_19',
                'XROTU_21',
                'XROTU_13',
                'XROTU_14',
                'XROTU_40',
                'XROTU_32',
                'XROTU_34',
                'XROTU_22',
                'XROTU_38')

ColourCanopy <- c('XROTU_02' = '#FFCC66FF',
                  'XROTU_01' = '#FFCC99FF',
                  'XROTU_04' = '#FF9933FF',
                  'XROTU_05' = '#664466FF',
                  'XROTU_03' = '#99CCFFFF',
                  'XROTU_06' = '#9999FFFF',
                  'XROTU_07' = '#CC6699FF',
                  'XROTU_31' = '#3366CCFF',
                  'XROTU_08' = '#CC6666FF',
                  'XROTU_09' = '#006699FF',
                  'XROTU_37' = '#FF9966FF',
                  'XROTU_20' = '#CC99CCFF',
                  'XROTU_18' = '#9999CCFF',
                  'XROTU_25' = '#6688CCFF',
                  'XROTU_34' = '#d3d3d3',
                  'XROTU_10' = '#d3d3d3',
                  'XROTU_19' = '#d3d3d3',
                  'XROTU_38' = '#d3d3d3',
                  'XROTU_22' = '#d3d3d3',
                  'XROTU_21' = '#d3d3d3',
                  'XROTU_40' = '#d3d3d3',
                  'XROTU_14' = '#d3d3d3',
                  'XROTU_13' = '#d3d3d3',
                  'XROTU_32' = '#d3d3d3',
                  'XROTU_23' = '#d3d3d3')

# Plot networks
ground_nw <- bipartite_D3(ground_melt2,
             colouroption = 'manual',
             NamedColourVector = ColourGround,
             ColourBy = 1, SortPrimary = SortGround,
             Pad = 4, MinWidth = 20,
             MainFigSize = c(1000, 1300), 
             IndivFigSize = c(800, 1200),
             IncludePerc = FALSE)
ground_nw

canopy_nw <- bipartite_D3(canopy_melt2,
             colouroption = 'manual',
             NamedColourVector = ColourCanopy,
             ColourBy = 1, SortPrimary=SortCanopy,
             Pad = 4,MinWidth = 20,
             MainFigSize = c(1000, 1300), 
             IndivFigSize = c(800, 1200),
             IncludePerc = FALSE)
canopy_nw

# Native species only ----
ground_combined3 <- read.csv("data/metabarcoding/networks/ground_combined3.csv")
canopy_combined3 <- read.csv("data/metabarcoding/networks/canopy_combined3.csv")

ground_melt <- melt(ground_combined3, id = c("X"))
ground_melt2 <- ground_melt %>% filter(value != 0)

canopy_melt <- melt(canopy_combined3, id = c("X"))
canopy_melt2 <- canopy_melt %>% filter(value != 0)

# Settings for ground network
SortGround <- c('XROTU_02',
                'XROTU_01',
                'XROTU_04',
                'XROTU_05',
                'XROTU_03',
                'XROTU_06',
                'XROTU_07',
                'XROTU_08',
                'XROTU_09',
                'XROTU_37',
                'XROTU_12',
                'XROTU_20',
                'XROTU_27',
                'XROTU_15',
                'XROTU_18',
                'XROTU_25',
                'XROTU_28')

ColourGround <- c('XROTU_02' = '#FFCC66FF',
                  'XROTU_01' = '#FFCC99FF',
                  'XROTU_04' = '#FF9933FF',
                  'XROTU_05' = '#664466FF',
                  'XROTU_03' = '#99CCFFFF',
                  'XROTU_06' = '#9999FFFF',
                  'XROTU_07' = '#CC6699FF',
                  'XROTU_08' = '#CC6666FF',
                  'XROTU_09' = '#006699FF',
                  'XROTU_37' = '#FF9966FF',
                  'XROTU_20' = '#CC99CCFF',
                  'XROTU_27' = '#4455BBFF',
                  'XROTU_12' = '#9977AAFF',
                  'XROTU_15' = '#DD6644FF',
                  'XROTU_18' = '#9999CCFF',
                  'XROTU_25' = '#6688CCFF',
                  'XROTU_28' = '#774466FF')

SortCanopy <- c('XROTU_01',
                'XROTU_02',
                'XROTU_04',
                'XROTU_05',
                'XROTU_20',
                'XROTU_03',
                'XROTU_31',
                'XROTU_09',
                'XROTU_18',
                'XROTU_06',
                'XROTU_07',
                'XROTU_08',
                'XROTU_37',
                'XROTU_25')

ColourCanopy <- c('XROTU_02' = '#FFCC66FF',
                  'XROTU_01' = '#FFCC99FF',
                  'XROTU_04' = '#FF9933FF',
                  'XROTU_05' = '#664466FF',
                  'XROTU_03' = '#99CCFFFF',
                  'XROTU_06' = '#9999FFFF',
                  'XROTU_07' = '#CC6699FF',
                  'XROTU_31' = '#3366CCFF',
                  'XROTU_08' = '#CC6666FF',
                  'XROTU_09' = '#006699FF',
                  'XROTU_37' = '#FF9966FF',
                  'XROTU_20' = '#CC99CCFF',
                  'XROTU_18' = '#9999CCFF',
                  'XROTU_25' = '#6688CCFF')

# Plot networks
ground_nw <- bipartite_D3(ground_melt2,
                          colouroption = 'manual',
                          NamedColourVector = ColourGround,
                          ColourBy = 1, SortPrimary = SortGround,
                          Pad = 4, MinWidth = 20,
                          MainFigSize = c(1000, 1100), 
                          IndivFigSize = c(800, 1000),
                          IncludePerc = FALSE)
ground_nw

canopy_nw <- bipartite_D3(canopy_melt2,
                          colouroption = 'manual',
                          NamedColourVector = ColourCanopy,
                          ColourBy = 1, SortPrimary=SortCanopy,
                          Pad = 4, MinWidth = 20,
                          MainFigSize = c(1000, 1100), 
                          IndivFigSize = c(800, 1000),
                          IncludePerc = FALSE)
canopy_nw

