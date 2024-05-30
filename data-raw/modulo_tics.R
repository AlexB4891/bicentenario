library(tidyverse)
library(survey)
library(srvyr)

# Cargar el modulo tics de cada año de la encuesta de empresas ENESEM


modulo_tics <- read_tsv("C:/Users/alex_ergostats/OneDrive/Documentos/ergostats_research/uncertainty_paper/bases/procesadas/modulo_tics_indicador.txt")

tabla_svy <- as_survey_design(.data = modulo_tics,
                              ids = id_empresa,
                              probs = f_exp)


tabla_consol <- tabla_svy %>%
  dplyr::mutate(personal_tics = tic2_5_pers_ocup_internet_h + tic2_5_pers_ocup_internet_m +
                  tic4_1_1_pers_ocup_usa_disp_h + tic4_1_1_pers_ocup_usa_disp_m +
                  tic6_1_1_pers_ocup_especialista_h + tic6_1_1_pers_ocup_especialista_m) %>%
  dplyr::group_by(anio_fiscal, des_sector, provincia) %>%
  dplyr::summarise(indicador = srvyr::survey_mean(indicador_z, na.rm = TRUE),
                   inversion = srvyr::survey_mean(tic1_2, na.rm = TRUE),
                   personal = srvyr::survey_mean(personal_tics, na.rm = TRUE),
                   ventas = srvyr::survey_mean(tic3_1_1_ventas, na.rm = TRUE),
                   n = srvyr::survey_total( na.rm = TRUE)) %>%
  dplyr::mutate(across(c(inversion,  ventas), ~round(.x, 2)/1000))

modulo_tics <- tabla_consol

rm(tabla_svy, tabla_consol)

## code to prepare `modulo_tics` dataset goes here

usethis::use_data(modulo_tics, overwrite = TRUE)


