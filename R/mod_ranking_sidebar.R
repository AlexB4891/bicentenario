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
      tags$style(HTML('
        .sidebar-input { width: 100%; }
        .sidebar-link { margin-bottom: 5px; }
        .sidebar-content { margin-left: 20px;
                           width: 90%; }
        h2 {
            background-color: green;
            color: white;
            padding: 5px 10px;
            position: relative;
        }

        h2:before {
            content: "";
            position: absolute;
            bottom: -10px;
            left: 0;
            right: 0;
            height: 10px;
            background-color: darkgreen;
        }
              '))
    ),
    div(class = "sidebar-content",
    h2("Indice de adopción de Tecnologías de la Información y Comunicación (TICS)"),
    h3("Caso aplicado a la provincia de Manabí"),
    p("Nuestra aplicación le permite explorar el índice de adopción de TIC's en Ecuador de manera detallada y personalizada. Puede seleccionar el año de análisis para observar cómo ha evolucionado la adopción de TIC's a lo largo del tiempo.  "),
    div(
      class = "sidebar-input",
      shiny.semantic::slider_input(
      input_id   = ns("anio"),
      step = 1,
      value = 2021,min = 2018,max = 2021
    )),
    p("También puede elegir el sector productivo de su interés para obtener una visión más específica sobre cómo las distintas industrias están adoptando estas tecnologías."),
    shiny.semantic::selectInput(
      inputId = ns("sector"),
      label = "Selecciona un sector productivo:",
      choices = c("Global","Comercio","Construcción","Manufactura","Minería","Servicios"),
      width = "100%",
      selected = "Global"
    ),
    br(),

    p("Además, tiene la opción de seleccionar entre la métrica de media o mediana, lo cual le permitirá comparar la adopción de TIC's según la medida estadística que prefiera."),
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
    br(),
    p("Para una comprensión más profunda de la metodología utilizada en la creación de este índice, puede acceder a la ficha metodológica a través del botón que encontrará a continuación."),
    br()

    )
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
