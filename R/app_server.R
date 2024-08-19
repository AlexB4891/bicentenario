#' The application server-side
#'
#' @param input,output,session Internal parameters for {shiny}.
#'     DO NOT REMOVE.
#' @import shiny
#' @noRd
app_server <- function(input, output, session) {
  # Your application server logic

  inputs_side <- mod_ranking_sidebar_server("ranking_sidebar_1")

  anio_side <- reactive(inputs_side()$anio)
  sector_side <- reactive(inputs_side()$sector)
  metri_side <- reactive(inputs_side()$metric)

  tabla_filter <- mod_ranking_prov_map_server("ranking_prov_map_1",anio = anio_side,sector = sector_side,metric = metri_side)

  # mod_ranking_texts_server("ranking_texts_1",anio = anio_side,sector = sector_side)

  mod_ranking_prov_tables_server("ranking_prov_tables_1",
                                 tabla_filtrada = tabla_filter)

  mod_modal_server("modal_1")

  mod_radares_server("radares_1",anio = anio_side,sector = sector_side)
}
