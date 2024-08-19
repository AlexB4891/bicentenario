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
      DT::DTOutput(ns("tabla_prov"))
    )
  )
}

#' ranking_prov_tables Server Functions
#'
#' @noRd
mod_ranking_prov_tables_server <- function(id,tabla_filtrada){
  moduleServer( id, function(input, output, session){
    ns <- session$ns

    output$tabla_prov <- DT::renderDT({

      labels <- c("Ranking", "Provincia", "Indicador","Empresas")


      ranking_func(tabla_filtrada() ,
                   labels = labels
                   )



    })

  })
}

## To be copied in the UI
# mod_ranking_prov_tables_ui("ranking_prov_tables_1")

## To be copied in the server
# mod_ranking_prov_tables_server("ranking_prov_tables_1")
