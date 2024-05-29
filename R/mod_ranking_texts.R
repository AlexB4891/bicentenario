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
 
  )
}
    
#' ranking_texts Server Functions
#'
#' @noRd 
mod_ranking_texts_server <- function(id){
  moduleServer( id, function(input, output, session){
    ns <- session$ns
 
  })
}
    
## To be copied in the UI
# mod_ranking_texts_ui("ranking_texts_1")
    
## To be copied in the server
# mod_ranking_texts_server("ranking_texts_1")
