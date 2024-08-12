## code to prepare `shapes` dataset goes here

library(tidyverse)
library(sf)

shapes <- read_rds(file = "C:/Users/alex_ergostats/OneDrive/Documentos/ergostats_research/uncertainty_paper/bases/provincias_corregidas.rds")

shapes <- shapes %>%
  sf::st_simplify(dTolerance = 20)


usethis::use_data(shapes, overwrite = TRUE)
