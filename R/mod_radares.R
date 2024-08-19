#' radares UI Function
#'
#' @description A shiny Module.
#'
#' @param id,input,output,session Internal parameters for {shiny}.
#'
#' @noRd
#'
#' @import shiny purrr dplyr ggplot2 ggradar
mod_radares_ui <- function(id){
  ns <- NS(id)
  tagList(
    # Poner en una sola fila los tres plots con grid
    div(
      class = "ui grid",
      div(
        class = "five wide column",
        plotOutput(ns("plot_1"))
      ),
      div(
        class = "five wide column",
        plotOutput(ns("plot_2"))
      ),
      div(
        class = "five wide column",
        plotOutput(ns("plot_3"))
      )
    )
  )
}

#' radares Server Functions
#'
#' @noRd
mod_radares_server <- function(id, anio, sector){
  moduleServer( id, function(input, output, session){
    ns <- session$ns

    datos <- reactive({
      results <- generar_radares(anio = anio(),sector = sector())

      results <- results %>%
        map(select, group,
            `Prácticas de gestión` = tasa_gestion,
            `Inversión en TICS` = inversion,
            `Retorno de compras` = mercado,
            `Cultura de uso` = personal_ratio ,
            `Calidad del uso` = tasa_uso) %>%
        map(~.x %>% rename_with(.cols = everything(), ~str_replace(.x, " ", "\n")) )

      plot_result <- list(plot_1 =results[c("slice_max",
                                            "slice_min",
                                            "filter_manabi")] %>%
                            reduce(bind_rows),
                          plot_2 = results[c("filter_manabi",
                                             "filter_pichincha",
                                             "filter_guayas")] %>%
                            reduce(bind_rows),
                          plot_3 = results[c("filter_manabi",
                                             "filter_nacional")] %>%
                            reduce(bind_rows)) %>%
        map( ~{

          colores <- .x %>%
            select(group) %>%
            mutate(color = if_else(group == "MANABÍ",
                                   "#0c9010", NA_character_))

          colores_res <- c("#C70039","#b7bbb7")

          faltan <- colores %>%
            filter(is.na(color))

          faltan <- faltan %>%
            mutate(color = colores_res[1:nrow(faltan)])

          colores <- colores %>%
            filter(!is.na(color)) %>%
            bind_rows(faltan)

          colores<- set_names(x = colores$color,nm = colores$group)

          ggradar(.x,
                      group.point.size = 2,
                      group.colours = colores,
                      group.line.width = 1.5,
                      fill             = TRUE,
                      fill.alpha       = 0.25,
                      grid.label.size  = 0,
                      axis.label.size = 3) +
               theme(legend.position = "bottom",
                     text = element_text(hjust = 0.5))+  # Coloca la leyenda en la parte inferior
               guides(color = guide_legend(nrow = 3))

          })



      return(plot_result)
    })


    output$plot_1 <- renderPlot({
      datos()$plot_1
    })

    output$plot_2 <- renderPlot({
      datos()$plot_2
    })

    output$plot_3 <- renderPlot({
      datos()$plot_3

    })

  })
}

## To be copied in the UI
# mod_radares_ui("radares_1")

## To be copied in the server
# mod_radares_server("radares_1")
