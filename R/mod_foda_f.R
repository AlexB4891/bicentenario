#' foda_f UI Function
#'
#' @description A shiny Module.
#'
#' @param id,input,output,session Internal parameters for {shiny}.
#'
#' @noRd 
#'
#' @importFrom shiny NS tagList 
mod_foda_f_ui <- function(id){
  ns <- NS(id)
  tagList(
 
  )
}
    
#' foda_f Server Functions
#'
#' @noRd 
mod_foda_f_server <- function(id){
  moduleServer( id, function(input, output, session){
    ns <- session$ns
 
  })
}
    
## To be copied in the UI
# mod_foda_f_ui("foda_f_1")
    
## To be copied in the server
# mod_foda_f_server("foda_f_1")
