library(tidyverse)

# Cargar el modulo tics de cada año de la encuesta de empresas ENESEM


modulo_tics <- read_tsv("C:/Users/alex_ergostats/OneDrive/Documentos/ergostats_research/uncertainty_paper/bases/procesadas/modulo_tics_indicador.txt")

## code to prepare `modulo_tics` dataset goes here

usethis::use_data(modulo_tics, overwrite = TRUE)


