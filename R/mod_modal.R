#' modal UI Function
#'
#' @description A shiny Module.
#'
#' @param id,input,output,session Internal parameters for {shiny}.
#'
#' @noRd
#'
#' @import shiny
mod_modal_ui <- function(id){
  ns <- NS(id)
  tagList(
    actionButton(inputId = ns("ficha"), label = "Ficha metodológica")
  )
}

#' modal Server Functions
#'
#' @noRd
mod_modal_server <- function(id){
  moduleServer( id, function(input, output, session){


    myModal <- function() {
      ns <- session$ns
      modalDialog(actionButton(ns("closeModalBtn"), "Close Modal"))
    }

    # open modal on button click
    observeEvent(input$ficha,
                 ignoreNULL = FALSE,   # Show modal on start up
                 showModal(myModal())
    )

    # close modal on button click
    observeEvent(input$closeModalBtn, {
      removeModal()
    })

  })
}

## To be copied in the UI
# mod_modal_ui("modal_1")

## To be copied in the server
# mod_modal_server("modal_1")
