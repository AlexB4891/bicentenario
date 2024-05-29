#' helpers
#'
#' @description A fct function
#'
#' @return The return value, if any, from executing the function.
#'
#' @noRd
map_histogram <- function(table_design,
                          year,
                          industry,
                          shape,
                          diccionario,
                          title,
                          subtitle){

  table_province <- dplyr::filter(table_design, anio_fiscal == year, des_sector == industry) %>%
    dplyr::group_by(provincia) %>%
    dplyr::summarise(promedio = srvyr::survey_mean(indicador_z, na.rm = TRUE),
                      n = srvyr::survey_total( na.rm = TRUE)) %>%
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
    ) +
    ggplot2::theme_minimal()


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
    ggplot2::geom_point(data = tabla_manabi, aes(x = DPA_DESPRO1,y = promedio ),vjust = -5,shape = 25, color = "darkblue", fill = "darkblue") +
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
      ggiraph::opts_sizing(rescale = FALSE)
    ),
    height_svg = 5,
    width_svg = 9
  )
}
