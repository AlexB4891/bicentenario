## code to prepare `shapes` dataset goes here

library(tidyverse)

shapes <- read_rds("C:/Users/alex_ergostats/OneDrive/Documentos/ergostats_research/uncertainty_paper/bases/provincias_corregidas.rds")

usethis::use_data(shapes, overwrite = TRUE)
