library(tidyverse)
library(survey)
library(srvyr)

# Cargar el modulo tics de cada año de la encuesta de empresas ENESEM


modulo_tics <- read_tsv("C:/Users/alex_ergostats/OneDrive/Documentos/ergostats_research/uncertainty_paper/bases/procesadas/modulo_tics_indicador.txt")

modulo_tics <- modulo_tics %>%
  mutate(across(c(tic1_2, tic3_1_1_ventas,tic2_5_pers_ocup_internet_h,tic2_5_pers_ocup_internet_m,
                  tic4_1_1_pers_ocup_usa_disp_h,tic4_1_1_pers_ocup_usa_disp_m,
                  tic6_1_1_pers_ocup_especialista_h,tic6_1_1_pers_ocup_especialista_m),
                 ~replace_na(., 0)))

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

modulo_tics <- modulo_tics %>%
  split(.$provincia) %>%
  map(~.x %>%
        ungroup() %>%
        select(anio_fiscal, des_sector,   provincia, indicador,inversion,n, personal,ventas) %>%
        mutate(peso = inversion/sum(inversion, na.rm = TRUE),
               valor  = indicador*peso,
               valor2 = inversion*peso,
               valor3 = personal*peso,
               valor4 = ventas*peso

               ) %>%
        group_by(anio_fiscal, provincia) %>%
        summarise(indicador = sum(valor,na.rm = TRUE),
                  inversion = sum(valor2,na.rm = TRUE),
                  personal = sum(valor3,na.rm = TRUE),
                  ventas = sum(valor4,na.rm = TRUE),
                  n = sum(n))
        ) %>%
  reduce(bind_rows) %>%
  mutate(des_sector = "Global") %>%
  bind_rows(modulo_tics)


### Por mediana

tabla_consol_alt <- tabla_svy %>%
  dplyr::mutate(personal_tics = tic2_5_pers_ocup_internet_h + tic2_5_pers_ocup_internet_m +
                  tic4_1_1_pers_ocup_usa_disp_h + tic4_1_1_pers_ocup_usa_disp_m +
                  tic6_1_1_pers_ocup_especialista_h + tic6_1_1_pers_ocup_especialista_m) %>%
  # filter(complete.cases(tic1_2, tic3_1_1_ventas,personal_tics)) %>%
  dplyr::group_by(anio_fiscal, des_sector, provincia) %>%
  dplyr::summarise(indicador = srvyr::survey_median(indicador_z, na.rm = TRUE),
                   inversion = srvyr::survey_median(tic1_2, na.rm = TRUE),
                   personal = srvyr::survey_median(personal_tics, na.rm = TRUE),
                   ventas = srvyr::survey_median(tic3_1_1_ventas, na.rm = TRUE),
                   n = srvyr::survey_total( na.rm = TRUE)) %>%
  dplyr::mutate(across(c(inversion,  ventas), ~round(.x, 2)/1000))

modulo_tics_alt <- tabla_consol_alt

modulo_tics_alt <- modulo_tics %>%
  split(.$provincia) %>%
  map(~.x %>%
        ungroup() %>%
        select(anio_fiscal, des_sector,   provincia, indicador,inversion,n, personal,ventas) %>%
        mutate(peso = inversion/sum(inversion, na.rm = TRUE),
               valor  = indicador*peso,
               valor2 = inversion*peso,
               valor3 = personal*peso,
               valor4 = ventas*peso

        ) %>%
        group_by(anio_fiscal, provincia) %>%
        summarise(indicador = sum(valor,na.rm = TRUE),
                  inversion = sum(valor2,na.rm = TRUE),
                  personal = sum(valor3,na.rm = TRUE),
                  ventas = sum(valor4,na.rm = TRUE),
                  n = sum(n))
  ) %>%
  reduce(bind_rows) %>%
  mutate(des_sector = "Global") %>%
  bind_rows(modulo_tics_alt)


rm(tabla_svy, tabla_consol, tabla_consol_alt)

## code to prepare `modulo_tics` dataset goes here

usethis::use_data(modulo_tics, overwrite = TRUE)
usethis::use_data(modulo_tics_alt, overwrite = TRUE)


