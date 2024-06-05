#' ranking_prov_tables UI Function
#'
#' @description A shiny Module.
#'
#' @param id,input,output,session Internal parameters for {shiny}.
#'
#' @noRd
#'
#' @importFrom shiny NS tagList
mod_ranking_prov_tables_ui <- function(id){
  ns <- NS(id)
  tagList(
    tags$div(
      style = "width:100%; height:100%; overflow-x: scroll'",
      gt::gt_output(ns("tabla_prov"))
    )
  )
}

#' ranking_prov_tables Server Functions
#'
#' @noRd
mod_ranking_prov_tables_server <- function(id,tabla_filtrada){
  moduleServer( id, function(input, output, session){
    ns <- session$ns

    output$tabla_prov <- gt::render_gt({

      etiquqetas <- c("indicador" = "Indicador de uso de TIC",
                      "inversion" = "Inversión en TIC (Miles USD)",
                      "personal" = "Personal en TIC",
                      "ventas" = "Ventas en línea (Miles USD)",
                      "n" = "Número de empresas")


      ranking_func(tabla_filtrada(),
                   labels = etiquqetas)



    })

  })
}

## To be copied in the UI
# mod_ranking_prov_tables_ui("ranking_prov_tables_1")

## To be copied in the server
# mod_ranking_prov_tables_server("ranking_prov_tables_1")
