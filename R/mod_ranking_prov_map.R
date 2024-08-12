#' ranking_prov_map UI Function
#'
#' @description A shiny Module.
#'
#' @param id,input,output,session Internal parameters for {shiny}.
#'
#' @noRd
#'
#' @import shiny dplyr ggplot2 ggiraph stringr magrittr fomantic.plus
mod_ranking_prov_map_ui <- function(id){
  ns <- NS(id)
  tagList(
    tags$div(
      style = "width:100%; height:100%;",
    ggiraph::girafeOutput(ns("mapa"))
    )
  )
}

#' ranking_prov_map Server Functions
#'
#' @noRd
mod_ranking_prov_map_server <- function(id,anio,sector,metric){
  moduleServer( id, function(input, output, session){
    ns <- session$ns

    data("modulo_tics")
    data("modulo_tics_alt")
    data("diccionario")
    data("shapes")

    # Central fuente de datos:

    objetos_app <- reactiveValues(
      tabla_original = modulo_tics,
      diccionario = diccionario,
      shapes = shapes
      # ,
      # tabla_filtrada = NULL
    )


    observeEvent(metric(), {

      if(metric() == "Mediana"){
        objetos_app$tabla_original <- modulo_tics_alt
      } else {
        objetos_app$tabla_original <- modulo_tics
      }

    })


    tabla_filtrada <- reactive({

      objetos_app$tabla_original %>%
        dplyr::mutate(provincia = stringr::str_pad(width = 2,provincia,pad = "0")) %>%
        dplyr::filter(anio_fiscal == anio(),
               des_sector == sector()) %>%
        dplyr::left_join(diccionario)

    })

    output$mapa <- ggiraph::renderGirafe({


      text_title <- stringr::str_c("Indice de Adopción de TICS ", anio())
      text_subtitle <- stringr::str_c("Sector productivo: ", sector())

      map_histogram(tabla_filtrada()  %>%
                      rename(promedio = indicador),
                    objetos_app$shapes,
                    objetos_app$diccionario,
                    text_title,
                    text_subtitle)

    })


    return(tabla_filtrada)

  })
}

## To be copied in the UI
# mod_ranking_prov_map_ui("ranking_prov_map_1")

## To be copied in the server
# mod_ranking_prov_map_server("ranking_prov_map_1")
