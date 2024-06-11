## code to prepare `elastici` dataset goes here
library(tidyverse)
elastici <- read_tsv("C:/Users/alex_ergostats/OneDrive/Documentos/ergostats_research/uncertainty_paper/bases/procesadas/elasticidades_app.txt")

usethis::use_data(elastici, overwrite = TRUE)
