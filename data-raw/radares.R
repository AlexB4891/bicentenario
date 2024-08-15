## code to prepare `radares` dataset goes here

library(readxl)
library(tidyverse)

data_ <- read_csv2("C:/Users/alex_ergostats/OneDrive/Documentos/ergostats_research/uncertainty_paper/bases/diccionarios/diccionario_mfa.csv")

data_2 <- read_excel("C:/Users/alex_ergostats/OneDrive/Documentos/ergostats_research/uncertainty_paper/bases/diccionarios/diccionario_clasif.xlsx",skip = 1)

modulo_tics <- read_tsv("C:/Users/alex_ergostats/OneDrive/Documentos/ergostats_research/uncertainty_paper/bases/procesadas/modulo_tics_indicador.txt")


data_ %>%
  left_join(data_2) %>%
  count(grupo)


lista_gupos <- data_ %>%
  left_join(data_2) %>%
  filter(!is.na(grupo)) %>%
  split(.$grupo)

# Gestión:
# - Cuantas de las 10 formas de uso para la gestión se tiene por empresa
# - Agregado promedio para las provincias


gestion_var <- lista_gupos %>%
  pluck("Gestion", "codigo_de_la_variable")


gesition_completo <- modulo_tics %>%
  select(id_empresa,
         des_sector,
         anio_fiscal,
         provincia,
         all_of(gestion_var)) %>%
  mutate(across(all_of(gestion_var), ~as.numeric(.x == "SI"))) %>%
  pivot_longer(cols = all_of(gestion_var),names_to = "var",values_to = "val") %>%
  group_by(id_empresa,des_sector, anio_fiscal, provincia) %>%
  summarise(gestion = sum(val,na.rm = T)) %>%
  ungroup() %>%
  mutate(tasa_gestion = gestion/10)

gestion_provincial <- gesition_completo %>%
  group_by(des_sector,anio_fiscal,provincia) %>%
  summarise(tasa_gestion = mean(tasa_gestion,na.rm = T),
            n = n_distinct(id_empresa))


gestion_nacional <- gestion_provincial %>%
  ungroup() %>%
  group_by(provincia,anio_fiscal) %>%
  summarise(tasa_gestion = weighted.mean(tasa_gestion,w = n,na.rm = T))

# Inversión:
# - El percentil al que pertenece la empresa
# - Agregado de estos percentiles pro provincias

inversion_var <- lista_gupos %>%
  pluck("Inversión")

# La variable de inversión es numérica y se llama tic1_2

inversion_completo <-
  modulo_tics %>%
  select(id_empresa,
         des_sector,
         anio_fiscal,
         provincia,
         tic1_2) %>%
  split(list(.$des_sector, .$anio_fiscal)) %>%
  map_dfr(mutate,
      inversion = cut(tic1_2,
                      breaks = quantile(tic1_2,
                                        probs = seq(0,1,0.05),
                                        na.rm =T),
                      na.rm =T ),
      inversion_int = as.integer(inversion))

inversion_provincial <- inversion_completo %>%
  group_by(des_sector,anio_fiscal,provincia) %>%
  summarise(inversion = mean(inversion_int,na.rm = T),
            n = n_distinct(id_empresa))

invertion_nacional <- inversion_provincial %>%
  ungroup() %>%
  group_by(provincia,anio_fiscal) %>%
  summarise(inversion = weighted.mean(inversion,w = n,na.rm = T))
                                                                                                                                                                                                                                                                                                                                                                                                                                                                                            # Mercado:
# - Valor de ventas/compras
# - Se agrega y luefo se calcula la división a nivel de provincias

mercado_var <- lista_gupos %>%
  pluck("Mercado","codigo_de_la_variable")

mercado_completo <- modulo_tics %>%
  select(id_empresa,
         des_sector,
         anio_fiscal,
         provincia,
         all_of(mercado_var)) %>%
  pivot_longer(cols = all_of(mercado_var),names_to = "var",values_to = "val") %>%
  filter(var %in% c("tic3_1_1_ventas","tic3_2_1_compras")) %>%
  group_by(id_empresa,des_sector,anio_fiscal,provincia) %>%
  summarise(mercado = reduce(val,`/`)) %>%
  ungroup()

mercado_provincial <- mercado_completo %>%
  group_by(des_sector,anio_fiscal,provincia) %>%
  summarise(mercado = mean(mercado,na.rm = T),
            n = n_distinct(id_empresa))

mercado_nacional <- mercado_provincial %>%
  # ungroup() %>%
  group_by(provincia,anio_fiscal) %>%
  summarise(mercado = weighted.mean(mercado,w = n,na.rm = T))

# Personal TICS:
# - Personal en TICS vs Personal total
# - Promedio de provincias

personal_var <- lista_gupos %>%
  pluck("Personal TIC","codigo_de_la_variable")

# Uso TIC
# - Cuantas de las 51 formas de uso tiene por empresa
# - Promedio para las empresas de una misma provincia


usethis::use_data(radares, overwrite = TRUE)
