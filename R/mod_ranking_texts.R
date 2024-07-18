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
        .cajas {
          margin-top: -300px !important;
        }
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

      texto_1 <- str_c(round(tabla_elast()$log_inversion, digits = 3),"%")
      texto_2 <- str_c(round(tabla_elast()$log_dispositivos , digits = 3),"%")
      # texto_3 <- str_c(round(tabla_elast()$log_inversion, digits = 3),"%")
      # texto_4 <- str_c(round(tabla_elast()$log_personal, digits = 3),"%")

      div(class = "ui two column grid",
          div(class = "column",
              div(class = "ui raised segment",

                  addPopup(
                    fui_el$label(id = "help_label", class = "small circular", "?"),
                    "Porcentaje de incremento que tiene el indicador cuando la inversión incrementa en 1%",
                    inverted = TRUE
                  ),

                  h2("Inversión en TICS"),
                  h3(texto_1),

              )
          ),
          div(class = "column",
              div(class = "ui raised segment",
                  addPopup(
                    fui_el$label(id = "help_label_2", class = "small circular", "?"),
                    "Porcentaje de incremento que tiene el indicador cuando la inversión incrementa en 1%",
                    inverted = TRUE
                  ),
                  h2("Uso de dispositovs"),
                  h3(texto_2)
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
