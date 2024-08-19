## code to prepare `radares` dataset goes here

library(readxl)
library(tidyverse)

data_ <- read_csv2("C:/Users/alex_ergostats/OneDrive/Documentos/ergostats_research/uncertainty_paper/bases/diccionarios/diccionario_mfa.csv")

data_2 <- read_excel("C:/Users/alex_ergostats/OneDrive/Documentos/ergostats_research/uncertainty_paper/bases/diccionarios/diccionario_clasif.xlsx",skip = 1)

modulo_tics <- read_tsv("C:/Users/alex_ergostats/OneDrive/Documentos/ergostats_research/uncertainty_paper/bases/procesadas/modulo_tics_indicador.txt")

base_tratada <- read_rds("C:/Users/alex_ergostats/OneDrive/Documentos/ergostats_research/uncertainty_paper/bases/procesadas/base_trabajo.rds")

codificacion <- readxl::read_excel("C:/Users/alex_ergostats/Documents/geo_stats_2024_nb/data/CODIFICACIÓN_2022.xlsx")

# data(modulo_tics)

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

factores <- modulo_tics %>%
  select(id_empresa,
         des_sector,
         anio_fiscal,
         provincia,
         f_exp)

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
  left_join(factores) %>%
  group_by(des_sector,anio_fiscal,provincia) %>%
  summarise(tasa_gestion = mean(tasa_gestion,na.rm = T),
            n = sum(f_exp))


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
  left_join(factores) %>%
  group_by(des_sector,anio_fiscal,provincia) %>%
  summarise(inversion = mean(inversion_int,na.rm = T),
            n = sum(f_exp)) %>%
  mutate(inversion = if_else(is.na(inversion)|is.nan(inversion),0,inversion))

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
  mutate(val = replace_na(val, 0)) %>%
  filter(var %in% c("tic3_1_1_ventas","tic3_2_1_compras")) %>%
  arrange(id_empresa,des_sector,anio_fiscal,provincia,var) %>%
  group_by(id_empresa,des_sector,anio_fiscal,provincia) %>%
  summarise(mercado = reduce(val,`/`)) %>%
  ungroup() %>%
  mutate(mercado = if_else(is.na(mercado)|is.nan(mercado) | is.infinite(mercado),0,mercado))

mercado_provincial <- mercado_completo %>%
  left_join(factores) %>%
  group_by(des_sector,anio_fiscal,provincia) %>%
  summarise(mercado = mean(mercado,na.rm = T),
            n = sum(f_exp))

mercado_nacional <- mercado_provincial %>%
  # ungroup() %>%
  group_by(provincia,anio_fiscal) %>%
  summarise(mercado = weighted.mean(mercado,w = n,na.rm = T))

# Personal TICS:
# - Personal en TICS vs Personal total
# - Promedio de provincias

personal_var <- lista_gupos %>%
  pluck("Personal TIC") %>%
  filter(tipo_variable != "Categórica") %>%
  pull(codigo_de_la_variable)

personal_total <- base_tratada %>%
  select(id_empresa,anio_fiscal,
         pers_ocup_h,pers_ocup_m) %>%
  mutate(pers_ocup = pers_ocup_h + pers_ocup_m,
         across(c(id_empresa,anio_fiscal),~as.numeric(.x)))

personal_tics <- modulo_tics %>%
  rowwise() %>%
  mutate(personal_tics = sum(across(c(tic6_1_1_pers_ocup_especialista_h,
                                      tic6_1_1_pers_ocup_especialista_m)),na.rm = T)) %>%
  left_join(personal_total)

personal_tics <- personal_tics %>%
  select(id_empresa, anio_fiscal, personal_tics, pers_ocup, des_sector, cod_sector, provincia) %>%
  mutate(across(c(personal_tics,pers_ocup),
                ~replace_na(.x,0)),
         personal_ratio = case_when(
           pers_ocup == 0 ~ 0,
           is.na(pers_ocup) | is.na(personal_tics) ~ 0,
           is.na(pers_ocup) & is.na(personal_tics) ~ 0,
           TRUE ~ personal_tics/pers_ocup)) %>%
  filter(personal_ratio > 0)

personal_provincial <- personal_tics %>%
  left_join(factores) %>%
  group_by(des_sector,anio_fiscal,provincia) %>%
  summarise(personal_ratio = mean(personal_ratio,na.rm = T),
            n = sum(f_exp))

personal_nacional <- personal_provincial %>%
  ungroup() %>%
  group_by(provincia,anio_fiscal) %>%
  summarise(personal_ratio = weighted.mean(personal_ratio,w = n,na.rm = T))

# Uso TIC
# - Cuantas de las 51 formas de uso tiene por empresa
# - Promedio para las empresas de una misma provincia

uso_var <- lista_gupos %>%
  pluck("Uso TIC") %>%
  filter(tipo_variable == "Categórica") %>%
  pull(codigo_de_la_variable)

uso_completo <- modulo_tics %>%
  select(id_empresa,
         des_sector,
         anio_fiscal,
         provincia,
         all_of(uso_var)) %>%
  mutate(across(all_of(uso_var), ~as.numeric(.x %in% c("SI","Si")))) %>%
  pivot_longer(cols = all_of(uso_var),names_to = "var",values_to = "val") %>%
  group_by(id_empresa,des_sector,anio_fiscal,provincia) %>%
  summarise(uso = sum(val,na.rm = T)) %>%
  ungroup() %>%
  mutate(tasa_uso = uso/51)

uso_provincial <- uso_completo %>%
  left_join(factores) %>%
  group_by(des_sector,anio_fiscal,provincia) %>%
  summarise(tasa_uso = mean(tasa_uso,na.rm = T),
            n = sum(f_exp))

uso_nacional <- uso_provincial %>%
  ungroup() %>%
  group_by(provincia,anio_fiscal) %>%
  summarise(tasa_uso = weighted.mean(tasa_uso,w = n,na.rm = T))

dimensiones_provinciales <- list("Gesion" = gestion_provincial,
                     "Inversion" = inversion_provincial,
                     "Mercado" = mercado_provincial,
                     "Personal" = personal_provincial,
                     "Uso" = uso_provincial) %>%
  map(~.x %>%
         select(-n)) %>%
  reduce(full_join)

dimensiones_nacionales <- list("Gesion" = gestion_nacional,
                   "Inversion" = invertion_nacional,
                   "Mercado" = mercado_nacional,
                   "Personal" = personal_nacional,
                   "Uso" = uso_nacional) %>%
  # map(~.x %>%
  #       select(-n)) %>%
  reduce(full_join)


dimensiones_nacionales <- dimensiones_nacionales %>%
  mutate(across(where(is.numeric), replace_na,0))

dimensiones_provinciales <- dimensiones_provinciales %>%
  mutate(across(where(is.numeric), replace_na,0))

codificacion <- codificacion %>%
  mutate(DPA_DESPRO = as.factor(DPA_DESPRO)) %>%
  select(DPA_PROVIN, DPA_DESPRO) %>%
  distinct()

usethis::use_data(codificacion, overwrite = TRUE)
usethis::use_data(dimensiones_provinciales, overwrite = TRUE)
usethis::use_data(dimensiones_nacionales, overwrite = TRUE)
