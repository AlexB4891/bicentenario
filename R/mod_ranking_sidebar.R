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
    tags$head(
      tags$style(HTML("
        .sidebar-input { width: 100%; }
        .sidebar-link { margin-bottom: 5px; }
      "))
    ),
    h2("Índice de Adopción de TICS"),
    h3("Caso aplicado a la provincia de Manabí"),
    h4("Autores:"),br(),
    HTML("<b>Alex Bajaña</b>  (OBS Business School)<br><br>"),
    HTML("<b>Kathia Pinzón</b>  (Escuela Politécnica Nacional)<br><br>"),
    HTML("<b>Paúl Yungán</b>  (TEC de Monterrey)<br><br>"),
    div(
      class = "sidebar-input",
      shiny.semantic::slider_input(
      input_id   = ns("anio"),
      step = 1,
      value = 2021,min = 2018,max = 2021
    )),
    shiny.semantic::selectInput(
      inputId = ns("sector"),
      label = "Selecciona un sector productivo:",
      choices = c("Global","Comercio","Construcción","Manufactura","Minería","Servicios"),
      width = "100%",
      selected = "Global"
    ),
    br(),
    shiny.semantic::multiple_radio(
      input_id = ns("metrica"),
      label = "Selecciona una forma de medida:",
      choices = c("Media", "Mediana"),
      choices_value = c("Media", "Mediana")
    ),
    br(),
    HTML("El índice de adopción de TICS es un indicador que mide el grado de adopción de
          las tecnologías de la información y comunicación en las empresas. <br><br>"),
    div(class = "sidebar-link",
      tags$a(href = "https://www.ecuadorencifras.gob.ec/encuesta-estructural-empresarial-2021/",
             target = "_blank", "Encuesta Estructural Empresarial")
    ),
    div(class = "sidebar-link",
      tags$a(href = "https://www.pactomundial.org/ods/9-industria-innovacion-e-infraestructura/",
             target = "_blank", "Objetivo ODS sobre Innovación")
    ),
    div(class = "sidebar-link",
      tags$a(href = "https://www.arcotel.gob.ec/wp-content/uploads/2022/08/Agenda-transformacion-digital-2022-2025.pdf", target = "_blank", "Agenda 4.0")
    ),
    shiny.semantic::action_button(input_id = ns("btn"), label = "Ficha metodológica")

  )
}

#' ranking_sidebar Server Functions
#'
#' @noRd
mod_ranking_sidebar_server <- function(id){
  moduleServer( id, function(input, output, session){
    ns <- session$ns

     return(reactive({
      list(
        anio = input$anio,
        sector = input$sector,
        metric = input$metrica
      )
    }))

  })
}

## To be copied in the UI
# mod_ranking_sidebar_ui("ranking_sidebar_1")

## To be copied in the server
# mod_ranking_sidebar_server("ranking_sidebar_1")
