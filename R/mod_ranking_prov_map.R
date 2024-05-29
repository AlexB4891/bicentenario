#' ranking_prov_map UI Function
#'
#' @description A shiny Module.
#'
#' @param id,input,output,session Internal parameters for {shiny}.
#'
#' @noRd 
#'
#' @importFrom shiny NS tagList 
mod_ranking_prov_map_ui <- function(id){
  ns <- NS(id)
  tagList(
 
  )
}
    
#' ranking_prov_map Server Functions
#'
#' @noRd 
mod_ranking_prov_map_server <- function(id){
  moduleServer( id, function(input, output, session){
    ns <- session$ns
 
  })
}
    
## To be copied in the UI
# mod_ranking_prov_map_ui("ranking_prov_map_1")
    
## To be copied in the server
# mod_ranking_prov_map_server("ranking_prov_map_1")
