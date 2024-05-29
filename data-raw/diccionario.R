library(tidyverse)

## code to prepare `diccionario` dataset goes here

diccionario <- read_rds("C:/Users/alex_ergostats/OneDrive/Documentos/ergostats_research/uncertainty_paper/bases/diccionarios/provincias.rds")

usethis::use_data(diccionario, overwrite = TRUE)
