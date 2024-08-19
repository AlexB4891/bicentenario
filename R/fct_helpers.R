#' helpers
#'
#' @description A fct function
#'
#' @return The return value, if any, from executing the function.
#'
#' @noRd
map_histogram <- function(table_province,
                          # year,
                          # industry,
                          shape,
                          diccionario,
                          title,
                          subtitle){

  # table_province <- dplyr::filter(table_design, anio_fiscal == year, des_sector == industry) %>%
  #   dplyr::group_by(provincia) %>%
  #   dplyr::summarise(promedio = srvyr::survey_mean(indicador_z, na.rm = TRUE),
  #                     n = srvyr::survey_total( na.rm = TRUE))

  table_province <- table_province  %>%
    dplyr::left_join(diccionario)

  datos_map <- dplyr::left_join(shape,
                                table_province, by = c("DPA_PROVIN" = "provincia")) %>%
    dplyr::mutate(tooltip = paste0("Provincia: ", DPA_DESPRO, "<br>",
                                   "Porcentaje: ", round(promedio,4)*100, "<br>",
                                   "Empreas:" , n), label = NA_character_)

  mapa <- ggplot2::ggplot(data = datos_map) +
    ggiraph::geom_sf_interactive(
      aes(fill = promedio,tooltip = tooltip,data_id = DPA_DESPRO),
      color = 'gray',
      size = 0.3
    ) +
    ggplot2::guides(fill = ggplot2::guide_colorbar(title = "Promedio")) +
    ggplot2::scale_fill_viridis_c() +
    ggplot2::theme(axis.text = ggplot2::element_blank(),
                   strip.text = ggplot2::element_text(family = 'Anton',
                                                      size = 10)) +
    ggplot2::labs(title = title, subtitle = subtitle) +
    ggplot2::theme_minimal() +
    ggplot2::theme(
      plot.title = ggplot2::element_text(family = 'Anton', size = 20),
      plot.subtitle = ggplot2::element_text(family = 'Anton'),

      legend.position = 'bottom',
      strip.text = ggplot2::element_text(
        family = 'Anton',
        face = 'bold',
        size = 9,
        color = 'black'
      ),
      strip.background = ggplot2::element_rect(fill = 'white')
    )


  tabla_barras <- datos_map %>%
    dplyr::mutate(
      DPA_DESPRO1 = forcats::as_factor(DPA_DESPRO),
      DPA_DESPRO1 = forcats::fct_reorder(.f = DPA_DESPRO1, .x = promedio))

  tabla_manabi <- dplyr::filter(tabla_barras, DPA_DESPRO1 == "MANABI")

  # browser()

 barras <- tabla_barras %>%
    dplyr::arrange(desc(promedio)) %>%
    tibble::rowid_to_column(var = "orden") %>%
    dplyr::mutate(tooltip2 = paste0("Provincia: ", DPA_DESPRO, "<br>",
                                    "Porcentaje: ", round(promedio,4)*100, "<br>",
                                    "Empreas:" , n, "<br>",
                                    "Puesto: #",orden)) %>%
    ggplot2::ggplot() +
    ggiraph::geom_bar_interactive(
      aes(x = DPA_DESPRO1, y = promedio, fill = DPA_DESPRO1, tooltip = tooltip,data_id = DPA_DESPRO),
      stat = "identity",
      color = 'gray',
      size = 0.3
    ) +
    ggplot2::geom_point(data = tabla_manabi, aes(x = DPA_DESPRO1,y = promedio ),vjust = -10,shape = 25, color = "darkblue", fill = "darkblue",size = 3) +
    ggplot2::guides(fill = ggplot2::guide_colorbar(title = "Promedio")) +
    ggplot2::scale_fill_viridis_d() +
    ggplot2::theme_void() +
    ggplot2::theme(
      axis.text = ggplot2::element_blank())

  p <- mapa +
    patchwork::inset_element(barras,
                             left = 0,
                             bottom = 0,
                             right = 0.5,
                             top = 0.6)

  ggiraph::girafe(
    ggobj = p,
    options = list(
      ggiraph::opts_hover(css = ""),
      ggiraph::opts_hover_inv(css = "opacity:0.1;"),
      ggiraph::opts_sizing(rescale = TRUE)
    )
  )
}



# Tabla en gt -------------------------------------------------------------

ranking_func <- function(tabla_provincia, labels) {

  # Ordenar y agregar columna de ranking
  tabla_provincia <- tabla_provincia %>%
    dplyr::arrange(desc(indicador)) %>%
    tibble::rowid_to_column(var = "Ranking")

  # browser()

  # Seleccionar y renombrar columnas
  tabla_provincia <- tabla_provincia %>%
    dplyr::ungroup() %>%
    dplyr::select(Ranking, provincia_label, indicador,n) %>%
    dplyr::rename_with(.cols = everything(),~ labels )

  # Crear tabla interactiva con DT
  ranking <- DT::datatable(
    tabla_provincia,
    options = list(
      pageLength = 15,
      autoWidth = TRUE,
      dom = 'Bfrtip',
      buttons = c('copy', 'csv', 'excel', 'pdf', 'print')
    )
  )

  # Formatear columnas numéricas y de moneda
  ranking <- ranking %>%
    DT::formatRound(columns = 'Indicador', digits = 3) %>%
    DT::formatRound(columns = 'Empresas', digits = 0)


  # Aplicar formato condicional a la columna indicador
  ranking <- ranking %>%
    DT::formatStyle(
      'Indicador',
      backgroundColor = DT::styleInterval(
        seq(0, max(tabla_provincia$Indicador), length.out = nrow(tabla_provincia)-1),
        viridis::viridis(nrow(tabla_provincia))
      )
    ) %>%
    DT::formatStyle(
      'Provincia',
      target = 'row',
      backgroundColor = DT::styleEqual(
        "Manabí",
        '#0c9010'  # El color que deseas para resaltar el valor
      )
    )

  return(ranking)

}



#' Generar datos para radares
#'
#' @param tabla
#' @param anio
#' @param sector
#' @param filtro
#'
#' @return
#' @export
#'
#' @examples
#' @ImportFrom dplyr filter mutate select left_join ungroup across rename group_by summarise
#' @ImportFrom scales rescale
#' @ImportFrom stringr str_pad str_c
#' @ImportFrom purrr map
#' @ImportFrom tidyr replace_na
generar_radares <- function(anio, sector, filtro = NULL){

  data("modulo_tics")
  data("codificacion")

  if(sector == "Global"){
    data("dimensiones_nacionales")

    tabla <- dimensiones_nacionales

    # rm(dimensiones_nacionales)

    tabla <- tabla %>%
      dplyr::filter(anio_fiscal == anio) %>%
      dplyr::mutate(provincia = stringr::str_pad(provincia, width = 2, pad = "0"),
             des_sector = "Global")


    indicador <- modulo_tics %>%
      dplyr::select(anio_fiscal,provincia, indicador,des_sector, n) %>%
      dplyr::filter(anio_fiscal == anio, des_sector == "Global")

  }else{
    data("dimensiones_provinciales")

    tabla <-  dimensiones_provinciales

    # rm(dimensiones_provinciales)

    tabla <- tabla %>%
      dplyr::filter(anio_fiscal == anio,
             des_sector == sector) %>%
      dplyr::mutate(provincia = stringr::str_pad(provincia, width = 2, pad = "0"))


    indicador <- modulo_tics %>%
      dplyr::select(anio_fiscal,provincia, indicador,des_sector, n) %>%
      dplyr::filter(anio_fiscal == anio, des_sector == sector)
  }

  # browser()

  tabla <- tabla %>%
    dplyr::left_join(codificacion,
              by = c("provincia" = "DPA_PROVIN")) %>%
    dplyr::left_join(indicador,
              by = c("provincia", "des_sector","anio_fiscal")) %>%
    dplyr::ungroup() %>%
    dplyr::mutate(dplyr::across(c(tasa_gestion,
                    inversion,
                    mercado,
                    personal_ratio,
                    tasa_uso), scales::rescale, to = c(0, 1)),
                  dplyr::across(c(tasa_gestion,
                    inversion,
                    mercado,
                    personal_ratio,
                    tasa_uso),
                    tidyr::replace_na, 0)) %>%
    dplyr::rename(group = DPA_DESPRO)

  funciones <- list(slice_max = function(tabla){
    tabla %>%
      dplyr::slice_max(indicador) %>%
      dplyr::mutate(group = stringr::str_c("Max: ", group))
  },
  slice_min = function(tabla){
    tabla %>%
      dplyr::slice_min(indicador) %>%
      dplyr::mutate(group = stringr::str_c("Min: ", group))
  },
  filter_nacional = function(tabla){
    tabla %>%
      dplyr::ungroup() %>%
      dplyr::group_by(des_sector) %>%
      dplyr::summarise(dplyr::across(c(tasa_gestion,
                         inversion,
                         mercado,
                         personal_ratio,
                         tasa_uso),
                       ~weighted.mean(.x, n, na.rm = TRUE))) %>%
      dplyr::rename(group = des_sector)
  },
  filter_pichincha = function(tabla){
    tabla %>%
      dplyr::filter(group == "PICHINCHA")
  },
  filter_guayas = function(tabla){
    tabla %>%
      dplyr::filter(group == "GUAYAS")
  },
  filter_manabi = function(tabla){
    tabla %>%
      dplyr::filter(group == "MANABÍ")
  }
  # ,
  # filter_adicional = function(tabla){
  #   if(!is.null(filtro)){
  #     tabla %>%
  #       dplyr::filter(group == filtro)
  # }else{
  #   return(NULL)
  # }
  # }
  )



  results <- purrr::map(funciones, ~.x(tabla))

  return(results)

}

# generar_radares(2020,"Comercio",filtro = "AZUAY")

