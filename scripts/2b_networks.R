####### DB Networks by Sites
####### Author: Xin Rui Ong
####### Network Construction

# Setup ----
library(tidyverse)
library(data.table)
library(reshape2)
library(bipartite)
library(bipartiteD3)
library(r2d3)

# bipartiteD3 for aesthetic plots ----
## Load data ----
MandaiNorth_Ground1 <- read.csv("data/metabarcoding/networks/sites/MandaiNorth_Ground.csv",
                               header = T)
MandaiWest_Ground1 <- read.csv("data/metabarcoding/networks/sites/MandaiWest_Ground.csv",
                              header = T)
MandaiWest_Canopy1 <- read.csv("data/metabarcoding/networks/sites/MandaiWest_Canopy.csv",
                              header = T)
SeletarCore_Ground1 <- read.csv("data/metabarcoding/networks/sites/SeletarCore_Ground.csv",
                               header = T)
SeletarCore_Canopy1 <- read.csv("data/metabarcoding/networks/sites/SeletarCore_Canopy.csv",
                               header = T)
PeirceCore_Ground1 <- read.csv("data/metabarcoding/networks/sites/PeirceCore_Ground.csv",
                              header = T)
PeirceCore_Canopy1 <- read.csv("data/metabarcoding/networks/sites/PeirceCore_Canopy.csv",
                              header = T)
Thomson_Ground1 <- read.csv("data/metabarcoding/networks/sites/Thomson_Ground.csv",
                           header = T)
Thomson_Canopy1 <- read.csv("data/metabarcoding/networks/sites/Thomson_Canopy.csv",
                           header = T)
Chestnut_Ground1 <- read.csv("data/metabarcoding/networks/sites/Chestnut_Ground.csv",
                            header = T)
Chestnut_Canopy1 <- read.csv("data/metabarcoding/networks/sites/Chestnut_Canopy.csv",
                            header = T)
MacRitchieCore_Ground1 <- read.csv("data/metabarcoding/networks/sites/MacRitchieCore_Ground.csv",
                                  header = T)
MacRitchieCore_Canopy1 <- read.csv("data/metabarcoding/networks/sites/MacRitchieCore_Canopy.csv",
                                  header = T)
MacRitchieEdge_Ground1 <- read.csv("data/metabarcoding/networks/sites/MacRitchieEdge_Ground.csv",
                                  header = T)
MacRitchieEdge_Canopy1 <- read.csv("data/metabarcoding/networks/sites/MacRitchieEdge_Canopy.csv",
                                  header = T)

## Format data for plotting ----
MandaiNorth_Ground_melt <- melt(MandaiNorth_Ground1, id = c("Species"))
MandaiNorth_Ground_melt <- MandaiNorth_Ground_melt %>% filter(value != 0)

MandaiWest_Ground_melt <- melt(MandaiWest_Ground1, id = c("Species"))
MandaiWest_Ground_melt <- MandaiWest_Ground_melt %>% filter(value != 0)
MandaiWest_Canopy_melt <- melt(MandaiWest_Canopy1, id = c("Species"))
MandaiWest_Canopy_melt <- MandaiWest_Canopy_melt %>% filter(value != 0)

SeletarCore_Ground_melt <- melt(SeletarCore_Ground1, id = c("Species"))
SeletarCore_Ground_melt <- SeletarCore_Ground_melt %>% filter(value != 0)
SeletarCore_Canopy_melt <- melt(SeletarCore_Canopy1, id = c("Species"))
SeletarCore_Canopy_melt <- SeletarCore_Canopy_melt %>% filter(value != 0)

PeirceCore_Ground_melt <- melt(PeirceCore_Ground1, id = c("Species"))
PeirceCore_Ground_melt <- PeirceCore_Ground_melt %>% filter(value != 0)
PeirceCore_Canopy_melt <- melt(PeirceCore_Canopy1, id = c("Species"))
PeirceCore_Canopy_melt <- PeirceCore_Canopy_melt %>% filter(value != 0)

Chestnut_Ground_melt <- melt(Chestnut_Ground1, id = c("Species"))
Chestnut_Ground_melt <- Chestnut_Ground_melt %>% filter(value != 0)
Chestnut_Canopy_melt <- melt(Chestnut_Canopy1, id = c("Species"))
Chestnut_Canopy_melt <- Chestnut_Canopy_melt %>% filter(value != 0)

Thomson_Ground_melt <- melt(Thomson_Ground1, id = c("Species"))
Thomson_Ground_melt <- Thomson_Ground_melt %>% filter(value != 0)
Thomson_Canopy_melt <- melt(Thomson_Canopy1, id = c("Species"))
Thomson_Canopy_melt <- Thomson_Canopy_melt %>% filter(value != 0)

MacRitchieCore_Ground_melt <- melt(MacRitchieCore_Ground1, id = c("Species"))
MacRitchieCore_Ground_melt <- MacRitchieCore_Ground_melt %>% filter(value != 0)
MacRitchieCore_Canopy_melt <- melt(MacRitchieCore_Canopy1, id = c("Species"))
MacRitchieCore_Canopy_melt <- MacRitchieCore_Canopy_melt %>% filter(value != 0)

MacRitchieEdge_Ground_melt <- melt(MacRitchieEdge_Ground1, id = c("Species"))
MacRitchieEdge_Ground_melt <- MacRitchieEdge_Ground_melt %>% filter(value != 0)
MacRitchieEdge_Canopy_melt <- melt(MacRitchieEdge_Canopy1, id = c("Species"))
MacRitchieEdge_Canopy_melt <- MacRitchieEdge_Canopy_melt %>% filter(value != 0)

## Settings for network plotting ----
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

## Plot networks ----
### Ground ----
MandaiNorth_Ground_melt_nw <- bipartite_D3(MandaiNorth_Ground_melt,
                          colouroption = 'manual',
                          NamedColourVector = ColourGround,
                          ColourBy = 2, SortSecondary = SortGround,
                          PrimaryLab = 'Dung Beetle',
                          SecondaryLab = 'Vertebrate',
                          SiteNames = "Mandai North (Ground)")
MandaiNorth_Ground_melt_nw

MandaiWest_Ground_melt_nw <- bipartite_D3(MandaiWest_Ground_melt,
                                           colouroption = 'manual',
                                           NamedColourVector = ColourGround,
                                           ColourBy = 2, SortSecondary = SortGround,
                                           PrimaryLab = 'Dung Beetle',
                                           SecondaryLab = 'Vertebrate',
                                           SiteNames = "Mandai West (Ground)")
MandaiWest_Ground_melt_nw

SeletarCore_Ground_melt_nw <- bipartite_D3(SeletarCore_Ground_melt,
                                          colouroption = 'manual',
                                          NamedColourVector = ColourGround,
                                          ColourBy = 2, SortSecondary = SortGround,
                                          PrimaryLab = 'Dung Beetle',
                                          SecondaryLab = 'Vertebrate',
                                          SiteNames = "Seletar Core (Ground)")
SeletarCore_Ground_melt_nw

PeirceCore_Ground_melt_nw <- bipartite_D3(PeirceCore_Ground_melt,
                                          colouroption = 'manual',
                                          NamedColourVector = ColourGround,
                                          ColourBy = 2, SortSecondary = SortGround,
                                          PrimaryLab = 'Dung Beetle',
                                          SecondaryLab = 'Vertebrate',
                                          SiteNames = "Peirce Core (Ground)")
PeirceCore_Ground_melt_nw

Thomson_Ground_melt_nw <- bipartite_D3(Thomson_Ground_melt,
                                          colouroption = 'manual',
                                          NamedColourVector = ColourGround,
                                          ColourBy = 2, SortSecondary = SortGround,
                                          PrimaryLab = 'Dung Beetle',
                                          SecondaryLab = 'Vertebrate',
                                          SiteNames = "Thomson (Ground)")
Thomson_Ground_melt_nw

Chestnut_Ground_melt_nw <- bipartite_D3(Chestnut_Ground_melt,
                                          colouroption = 'manual',
                                          NamedColourVector = ColourGround,
                                          ColourBy = 2, SortSecondary = SortGround,
                                          PrimaryLab = 'Dung Beetle',
                                          SecondaryLab = 'Vertebrate',
                                          SiteNames = "Chestnut (Ground)")
Chestnut_Ground_melt_nw

MacRitchieCore_Ground_melt_nw <- bipartite_D3(MacRitchieCore_Ground_melt,
                                        colouroption = 'manual',
                                        NamedColourVector = ColourGround,
                                        ColourBy = 2, SortSecondary = SortGround,
                                        PrimaryLab = 'Dung Beetle',
                                        SecondaryLab = 'Vertebrate',
                                        SiteNames = "MacRitchie Core (Ground)")
MacRitchieCore_Ground_melt_nw

MacRitchieEdge_Ground_melt_nw <- bipartite_D3(MacRitchieEdge_Ground_melt,
                                        colouroption = 'manual',
                                        NamedColourVector = ColourGround,
                                        ColourBy = 2, SortSecondary = SortGround,
                                        PrimaryLab = 'Dung Beetle',
                                        SecondaryLab = 'Vertebrate',
                                        SiteNames = "MacRitchie Edge (Ground)")
MacRitchieEdge_Ground_melt_nw

### Canopy ----
MandaiWest_Canopy_melt_nw <- bipartite_D3(MandaiWest_Canopy_melt,
                                          colouroption = 'manual',
                                          NamedColourVector = ColourCanopy,
                                          ColourBy = 2, SortSecondary = SortCanopy,
                                          PrimaryLab = 'Dung Beetle',
                                          SecondaryLab = 'Vertebrate',
                                          SiteNames = "Mandai West (Canopy)")
MandaiWest_Canopy_melt_nw

SeletarCore_Canopy_melt_nw <- bipartite_D3(SeletarCore_Canopy_melt,
                                           colouroption = 'manual',
                                           NamedColourVector = ColourCanopy,
                                           ColourBy = 2, SortSecondary = SortCanopy,
                                           PrimaryLab = 'Dung Beetle',
                                           SecondaryLab = 'Vertebrate',
                                           SiteNames = "Seletar Core (Canopy)")
SeletarCore_Canopy_melt_nw

PeirceCore_Canopy_melt_nw <- bipartite_D3(PeirceCore_Canopy_melt,
                                          colouroption = 'manual',
                                          NamedColourVector = ColourCanopy,
                                          ColourBy = 2, SortSecondary = SortCanopy,
                                          PrimaryLab = 'Dung Beetle',
                                          SecondaryLab = 'Vertebrate',
                                          SiteNames = "Peirce Core (Canopy)")
PeirceCore_Canopy_melt_nw

Thomson_Canopy_melt_nw <- bipartite_D3(Thomson_Canopy_melt,
                                       colouroption = 'manual',
                                       NamedColourVector = ColourCanopy,
                                       ColourBy = 2, SortSecondary = SortCanopy,
                                       PrimaryLab = 'Dung Beetle',
                                       SecondaryLab = 'Vertebrate',
                                       SiteNames = "Thomson (Canopy)")
Thomson_Canopy_melt_nw

Chestnut_Canopy_melt_nw <- bipartite_D3(Chestnut_Canopy_melt,
                                        colouroption = 'manual',
                                        NamedColourVector = ColourCanopy,
                                        ColourBy = 2, SortSecondary = SortCanopy,
                                        PrimaryLab = 'Dung Beetle',
                                        SecondaryLab = 'Vertebrate',
                                        SiteNames = "Chestnut (Canopy)")
Chestnut_Canopy_melt_nw

MacRitchieCore_Canopy_melt_nw <- bipartite_D3(MacRitchieCore_Canopy_melt,
                                              colouroption = 'manual',
                                              NamedColourVector = ColourCanopy,
                                              ColourBy = 2, SortSecondary = SortCanopy,
                                              PrimaryLab = 'Dung Beetle',
                                              SecondaryLab = 'Vertebrate',
                                              SiteNames = "MacRitchie Core (Canopy)")
MacRitchieCore_Canopy_melt_nw

MacRitchieEdge_Canopy_melt_nw <- bipartite_D3(MacRitchieEdge_Canopy_melt,
                                              colouroption = 'manual',
                                              NamedColourVector = ColourCanopy,
                                              ColourBy = 2, SortSecondary = SortCanopy,
                                              PrimaryLab = 'Dung Beetle',
                                              SecondaryLab = 'Vertebrate',
                                              SiteNames = "MacRitchie Edge (Canopy)")
MacRitchieEdge_Canopy_melt_nw

# bipartite for network indices ----
## Load data ----
MandaiNorth_Ground <- read.csv("data/metabarcoding/networks/sites/MandaiNorth_Ground.csv",
                               header = T, row.names = 1)
MandaiWest_Ground <- read.csv("data/metabarcoding/networks/sites/MandaiWest_Ground.csv",
                              header = T, row.names = 1)
MandaiWest_Canopy <- read.csv("data/metabarcoding/networks/sites/MandaiWest_Canopy.csv",
                              header = T, row.names = 1)
SeletarCore_Ground <- read.csv("data/metabarcoding/networks/sites/SeletarCore_Ground.csv",
                               header = T, row.names = 1)
SeletarCore_Canopy <- read.csv("data/metabarcoding/networks/sites/SeletarCore_Canopy.csv",
                               header = T, row.names = 1)
PeirceCore_Ground <- read.csv("data/metabarcoding/networks/sites/PeirceCore_Ground.csv",
                              header = T, row.names = 1)
PeirceCore_Canopy <- read.csv("data/metabarcoding/networks/sites/PeirceCore_Canopy.csv",
                              header = T, row.names = 1)
Thomson_Ground <- read.csv("data/metabarcoding/networks/sites/Thomson_Ground.csv",
                           header = T, row.names = 1)
Thomson_Canopy <- read.csv("data/metabarcoding/networks/sites/Thomson_Canopy.csv",
                           header = T, row.names = 1)
Chestnut_Ground <- read.csv("data/metabarcoding/networks/sites/Chestnut_Ground.csv",
                            header = T, row.names = 1)
Chestnut_Canopy <- read.csv("data/metabarcoding/networks/sites/Chestnut_Canopy.csv",
                            header = T, row.names = 1)
MacRitchieCore_Ground <- read.csv("data/metabarcoding/networks/sites/MacRitchieCore_Ground.csv",
                                  header = T, row.names = 1)
MacRitchieCore_Canopy <- read.csv("data/metabarcoding/networks/sites/MacRitchieCore_Canopy.csv",
                                  header = T, row.names = 1)
MacRitchieEdge_Ground <- read.csv("data/metabarcoding/networks/sites/MacRitchieEdge_Ground.csv",
                                  header = T, row.names = 1)
MacRitchieEdge_Canopy <- read.csv("data/metabarcoding/networks/sites/MacRitchieEdge_Canopy.csv",
                                  header = T, row.names = 1)

## Calculate network indices ----
indices_MandaiNorth_Ground <- networklevel(MandaiNorth_Ground,
                       index = c("links per species", "nestedness", "H2"))
indices_MandaiNorth_Ground <- data.frame(indices_MandaiNorth_Ground)
colnames(indices_MandaiNorth_Ground)= c("MandaiNorth_Ground")


# Creating datasets for each site & trap type (16 sites:trap) ----
## Combining sample replicates by site & trap type
sample <- read.csv("data/metabarcoding/16S_samplesBysites.csv",
                   header = T)
str(sample)

combined <- sample %>%
  group_by(Location_NW,  Ground.Canopy, Species) %>%
  summarise_each(funs(sum))
str(combined)

## Filter by site & trap type
MandaiNorth_Ground <- combined %>%
  filter(Location_NW == "Mandai North",
         Ground.Canopy == "Ground")
MandaiNorth_Ground <- MandaiNorth_Ground[,-1:-2]
                                  
MandaiNorth_Canopy <- combined %>%
  filter(Location_NW == "Mandai North",
         Ground.Canopy == "Canopy")
MandaiNorth_Canopy <- MandaiNorth_Canopy[,-1:-2] # No network

MandaiWest_Ground <- combined %>%
  filter(Location_NW == "Mandai West",
         Ground.Canopy == "Ground")
MandaiWest_Ground <- MandaiWest_Ground[,-1:-2]

MandaiWest_Canopy <- combined %>%
  filter(Location_NW == "Mandai West",
         Ground.Canopy == "Canopy")
MandaiWest_Canopy <- MandaiWest_Canopy[,-1:-2]

SeletarCore_Ground <- combined %>%
  filter(Location_NW == "Seletar Core",
         Ground.Canopy == "Ground")
SeletarCore_Ground <- SeletarCore_Ground[,-1:-2]

SeletarCore_Canopy <- combined %>%
  filter(Location_NW == "Seletar Core",
         Ground.Canopy == "Canopy")
SeletarCore_Canopy <- SeletarCore_Canopy[,-1:-2]

PeirceCore_Ground <- combined %>%
  filter(Location_NW == "Peirce Core",
         Ground.Canopy == "Ground")
PeirceCore_Ground <- PeirceCore_Ground[,-1:-2]

PeirceCore_Canopy <- combined %>%
  filter(Location_NW == "Peirce Core",
         Ground.Canopy == "Canopy")
PeirceCore_Canopy <- PeirceCore_Canopy[,-1:-2]

Chestnut_Ground <- combined %>%
  filter(Location_NW == "Chestnut",
         Ground.Canopy == "Ground")
Chestnut_Ground <- Chestnut_Ground[,-1:-2]

Chestnut_Canopy <- combined %>%
  filter(Location_NW == "Chestnut",
         Ground.Canopy == "Canopy")
Chestnut_Canopy <- Chestnut_Canopy[,-1:-2]

Thomson_Ground <- combined %>%
  filter(Location_NW == "Thomson",
         Ground.Canopy == "Ground")
Thomson_Ground <- Thomson_Ground[,-1:-2]

Thomson_Canopy <- combined %>%
  filter(Location_NW == "Thomson",
         Ground.Canopy == "Canopy")
Thomson_Canopy <- Thomson_Canopy[,-1:-2]

MacRitchieCore_Ground <- combined %>%
  filter(Location_NW == "MacRitchie Core",
         Ground.Canopy == "Ground")
MacRitchieCore_Ground <- MacRitchieCore_Ground[,-1:-2]

MacRitchieCore_Canopy <- combined %>%
  filter(Location_NW == "MacRitchie Core",
         Ground.Canopy == "Canopy")
MacRitchieCore_Canopy <- MacRitchieCore_Canopy[,-1:-2]

MacRitchieEdge_Ground <- combined %>%
  filter(Location_NW == "MacRitchie Edge",
         Ground.Canopy == "Ground")
MacRitchieEdge_Ground <- MacRitchieEdge_Ground[,-1:-2]

MacRitchieEdge_Canopy <- combined %>%
  filter(Location_NW == "MacRitchie Edge",
         Ground.Canopy == "Canopy")
MacRitchieEdge_Canopy <- MacRitchieEdge_Canopy[,-1:-2]

write.csv(MandaiNorth_Ground, "data/metabarcoding/networks/sites/MandaiNorth_Ground.csv",
          row.names = FALSE)
write.csv(MandaiNorth_Canopy, "data/metabarcoding/networks/sites/MandaiNorth_Canopy.csv",
          row.names = FALSE)
write.csv(MandaiWest_Ground, "data/metabarcoding/networks/sites/MandaiWest_Ground.csv",
          row.names = FALSE)
write.csv(MandaiWest_Canopy, "data/metabarcoding/networks/sites/MandaiWest_Canopy.csv",
          row.names = FALSE)
write.csv(SeletarCore_Ground, "data/metabarcoding/networks/sites/SeletarCore_Ground.csv",
          row.names = FALSE)
write.csv(SeletarCore_Canopy, "data/metabarcoding/networks/sites/SeletarCore_Canopy.csv",
          row.names = FALSE)
write.csv(PeirceCore_Ground, "data/metabarcoding/networks/sites/PeirceCore_Ground.csv",
          row.names = FALSE)
write.csv(PeirceCore_Canopy, "data/metabarcoding/networks/sites/PeirceCore_Canopy.csv",
          row.names = FALSE)
write.csv(Thomson_Ground, "data/metabarcoding/networks/sites/Thomson_Ground.csv",
          row.names = FALSE)
write.csv(Thomson_Canopy, "data/metabarcoding/networks/sites/Thomson_Canopy.csv",
          row.names = FALSE)
write.csv(Chestnut_Ground, "data/metabarcoding/networks/sites/Chestnut_Ground.csv",
          row.names = FALSE)
write.csv(Chestnut_Canopy, "data/metabarcoding/networks/sites/Chestnut_Canopy.csv",
          row.names = FALSE)
write.csv(MacRitchieCore_Ground, "data/metabarcoding/networks/sites/MacRitchieCore_Ground.csv",
          row.names = FALSE)
write.csv(MacRitchieCore_Canopy, "data/metabarcoding/networks/sites/MacRitchieCore_Canopy.csv",
          row.names = FALSE)
write.csv(MacRitchieEdge_Ground, "data/metabarcoding/networks/sites/MacRitchieEdge_Ground.csv",
          row.names = FALSE)
write.csv(MacRitchieEdge_Canopy, "data/metabarcoding/networks/sites/MacRitchieEdge_Canopy.csv",
          row.names = FALSE)
