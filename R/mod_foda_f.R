#' foda_f UI Function
#'
#' @description A shiny Module.
#'
#' @param id,input,output,session Internal parameters for {shiny}.
#'
#' @noRd
#'
#' @importFrom shiny NS tagList
mod_foda_f_ui <- function(id){
  ns <- NS(id)
  tagList(
    uiOutput(ns("boxes"))
  )
}

#' foda_f Server Functions
#'
#' @noRd
mod_foda_f_server <- function(id,anio,sector){
  moduleServer( id, function(input, output, session){
    ns <- session$ns

    data(elastici)

    output$boxes <- renderUI({

      tabla <- elastici %>%
        filter(anio_fiscal == anio(), des_sector == sector())

      # browser()

      shiny.semantic::cards(
        shiny.semantic::card(
          title = "Inversión en TICS",
          description = str_c("Valor:",tabla %>% pull(log_inversion)),
          extra_content = div("Esta es la segunda línea de texto de la caja 1.")
        ),
        shiny.semantic::card(
          title = "Título de la caja 2",
          description = "Esta es la primera línea de texto de la caja 2.",
          extra_content = div("Esta es la segunda línea de texto de la caja 2.")
        )
      )
    })


  })
}

## To be copied in the UI
# mod_foda_f_ui("foda_f_1")

## To be copied in the server
# mod_foda_f_server("foda_f_1")
