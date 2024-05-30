#' ranking_sidebar UI Function
#'
#' @description A shiny Module.
#'
#' @param id,input,output,session Internal parameters for {shiny}.
#'
#' @noRd
#'
#' @importFrom shiny NS tagList
#' @import shiny shinyWidgets
mod_ranking_sidebar_ui <- function(id){
  ns <- NS(id)
  tagList(
    h2("Índice de Adopción de TICS"),br(),
    h3("Caso aplicado a la provincia de Mananbí"),br(),
    h4("Autores:"),br(),
    HTML("<b>Alex Bajaña</b>  (OBS Business School)"),br(),
    HTML("<b>Kathia Pinzón</b>  (Escuela Politécnica Nacional)"),
    HTML("<b>Paúl Yungán</b>  (TEC de Monterrey)"),br(),
    p("El índice de adopción de TICS es un indicador que mide el grado de adopción de las tecnologías de la información y comunicación en las empresas."),br(),
    radioGroupButtons(
      inputId = ns("anio"),
      label = "Selecciona un año",
      choices = c("2018", "2019", "2020", "2021")
    ),
    virtualSelectInput(
      inputId = ns("sector"),
      label = "Selecciona un sector productivo:",
      choices = c( "Comercio","Construcción","Manufactura","Minería","Servicios"),
      width = "100%",
      dropboxWrapper = "body"
    ),
    radioGroupButtons(
      inputId = ns("metrica"),
      label = "Selecciona una forma de medida:",
      choices = c("Media", "Mediana")
    ),
    p("El índice está construido en base a la Encuesta Estructural Empresarial (ENEMSE )del Instituto Nacional de Estadística y Censos (INEC).")

  )
}

#' ranking_sidebar Server Functions
#'
#' @noRd
mod_ranking_sidebar_server <- function(id){
  moduleServer( id, function(input, output, session){
    ns <- session$ns

  })
}

## To be copied in the UI
# mod_ranking_sidebar_ui("ranking_sidebar_1")

## To be copied in the server
# mod_ranking_sidebar_server("ranking_sidebar_1")