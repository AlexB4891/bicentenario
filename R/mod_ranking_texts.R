#' ranking_texts UI Function
#'
#' @description A shiny Module.
#'
#' @param id,input,output,session Internal parameters for {shiny}.
#'
#' @noRd
#'
#' @importFrom shiny NS tagList
mod_ranking_texts_ui <- function(id){
  ns <- NS(id)
  tagList(
     tags$head(
       tags$style(HTML("
       .header-container {
  display: flex;
  justify-content: space-between;
  align-items: center;
}
    #     .cajas {
    #       margin-top: -300px !important;
    #     }
     "))
    ),
    div(class = "cajas",uiOutput(ns("cajas"))
        )


  )
}

#' ranking_texts Server Functions
#'
#' @noRd
mod_ranking_texts_server <- function(id,anio,sector){
  moduleServer( id, function(input, output, session){
    ns <- session$ns

    data("elasticidades")


    tabla_elast <- reactive({

      elasticidades %>%
        filter(anio_fiscal == anio(),
               des_sector == sector())

    })

    output$cajas <- renderUI({

      texto_1 <- str_c("Para incrementar un 1% del indicador la inversión en TICS debe incrementar en ",round(1/tabla_elast()$log_inversion, digits = 3),"%")
      texto_2 <- str_c("Los contratos de especialistas en TICS debe crecer en ", round(1/tabla_elast()$log_personal , digits = 3),"% para incrementar en 1% el indicador")
      # texto_3 <- str_c(round(tabla_elast()$log_inversion, digits = 3),"%")
      # texto_4 <- str_c(round(tabla_elast()$log_personal, digits = 3),"%")

      div(class = "ui two column grid",
          div(class = "column",
              div(class = "ui raised segment",
                  div(class = "header-container",
                  h3("Inversión en TICS"),
                  addPopup(
                    fui_el$label(id = "help_label", class = "small circular", "?"),
                    "La inversión en TICs, respaldada por organismos como el Banco Mundial y la OCDE, implica no solo la modernización de infraestructuras tecnológicas, sino también el impulso a la productividad, la inclusión digital y la competitividad global de las economías.",
                    inverted = TRUE
                  ),
                  ),
                  p(texto_1)

              )
          ),
          div(class = "column",
              div(class = "ui raised segment",
                  div(class = "header-container",
                  h3("Especialistas en TICS"),
                  addPopup(
                    fui_el$label(id = "help_label_2", class = "small circular", "?"),
                    "Los trabajadores en el sector de las TICs son esenciales, ya que su conocimiento y habilidades impulsan la innovación, garantizan el funcionamiento eficiente de sistemas críticos, y facilitan la transformación digital en todos los sectores, fortaleciendo así la economía y la competitividad a nivel global.",
                    inverted = TRUE
                  )),
                  p(texto_2)
              )
          )
          # ,
          # div(class = "column",
          #     div(class = "ui raised segment",
          #         h2("Título 3"),
          #         h4("Subtítulo 3"),
          #         div(class = "ui huge text",
          #             "20% ", span(class = "ui emoticon", "🌧️")
          #         )
          #     )
          # ),
          # div(class = "column",
          #     div(class = "ui raised segment",
          #         h2("Título 4"),
          #         h4("Subtítulo 4"),
          #         div(class = "ui huge text",
          #             "90% ", span(class = "ui emoticon", "🌞")
          #         )
          #     )
          # )
      )


    })

  })
}

## To be copied in the UI
# mod_ranking_texts_ui("ranking_texts_1")

## To be copied in the server
# mod_ranking_texts_server("ranking_texts_1")
