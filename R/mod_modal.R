#' modal UI Function
#'
#' @description A shiny Module.
#'
#' @param id,input,output,session Internal parameters for {shiny}.
#'
#' @noRd
#'
#' @importFrom shiny NS tagList
mod_modal_ui <- function(id){
  ns <- NS(id)
  tagList(
    shiny.semantic::action_button(input_id = ns("btn"), label = "Ficha metodológica")
  )
}

#' modal Server Functions
#'
#' @noRd
mod_modal_server <- function(id){
  moduleServer( id, function(input, output, session){
    ns <- session$ns

    settngsModal <- function(id) {
      create_modal(
        modal(
          id = id,
          title = "Ficha Metodológica",
          header = "Indice de adopción de TICS",
          content =
            tagList(
              tags$iframe(src = "https://alexb4891.github.io/bicentenario-ficha/",
                          width="100%",
                          height = 650)
            ),
          footer = NULL,
          class = "huge"
        )
      )

    }

    # mod_ranking_sidebar_server("ranking_sidebar_1")

    observeEvent(input$btn, {

      showModal(settngsModal("simple-modal"))

      })

  })


}

## To be copied in the UI
# mod_modal_ui("modal_1")

## To be copied in the server
# mod_modal_server("modal_1")
