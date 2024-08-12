## code to prepare `elasticidades` dataset goes here

library(tidyverse)
library(survey)
library(srvyr)

elasticidades <- read_tsv("C:/Users/alex_ergostats/OneDrive/Documentos/ergostats_research/uncertainty_paper/bases/procesadas/elasticidades_app.txt")

usethis::use_data(elasticidades, overwrite = TRUE)
