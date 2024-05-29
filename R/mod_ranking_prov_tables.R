#' ranking_prov_tables UI Function
#'
#' @description A shiny Module.
#'
#' @param id,input,output,session Internal parameters for {shiny}.
#'
#' @noRd 
#'
#' @importFrom shiny NS tagList 
mod_ranking_prov_tables_ui <- function(id){
  ns <- NS(id)
  tagList(
 
  )
}
    
#' ranking_prov_tables Server Functions
#'
#' @noRd 
mod_ranking_prov_tables_server <- function(id){
  moduleServer( id, function(input, output, session){
    ns <- session$ns
 
  })
}
    
## To be copied in the UI
# mod_ranking_prov_tables_ui("ranking_prov_tables_1")
    
## To be copied in the server
# mod_ranking_prov_tables_server("ranking_prov_tables_1")
