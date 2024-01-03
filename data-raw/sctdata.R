library(scRNAseq)
library(janitor)
library(dplyr)

sce.seger <- SegerstolpePancreasData()
colskeep = c("individual", "disease", "cell type", "sex", "age","body mass index")

# Filter out 4 donors to simplify data and
# to highlight increase of ductal cells in disease
sctdata <- colData(sce.seger)[, colskeep] %>%
  data.frame() %>% clean_names() %>%
  rename(donor = individual, celltype = cell_type) %>%
  mutate(celltype = gsub(" cell", "", celltype)) %>%
  filter(!donor %in% c("AZ", "HP1506401", "HP1509101", "HP1504101T2D"))

donor_map <- setNames(c("C1", "D1", "C2", "C3", "D2", "D3"), unique(sctdata$donor))
sctdata$sample = donor_map[sctdata$donor]

usethis::use_data(sctdata, overwrite = TRUE)
