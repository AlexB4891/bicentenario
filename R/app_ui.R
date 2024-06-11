#' The application User-Interface
#'
#' @param request Internal parameter for `{shiny}`.
#'     DO NOT REMOVE.
#' @import shiny shiny.semantic shinydashboard bs4Dash
#' @noRd

app_ui <- function(request) {
  shinyUI(

    bs4DashPage(
      title = "Mi aplicación",
      header = bs4DashNavbar(
        title = "Mi aplicación"
      ),
      sidebar = bs4DashSidebar(
        width = "300px",
        sidebarMenu(
          mod_ranking_sidebar_ui("ranking_sidebar_1"),
          mod_modal_ui("modal_1")
        )
      ),
      body = bs4DashBody(
        tags$head(
          tags$style(type = "text/css", "text {font-family: sans-serif}")
        ),
        fluidRow(
          column(
            width = 5,
            tags$img(src = "img/bicentenario.png", height = "100px")
          ),
          column(
            width = 5,
            tags$img(src = "img/prefectura.png", height = "100px")
          ),
          column(
            width = 6,
            tags$img(src = "img/ergos.png", height = "100px")
          )
        ),
        fluidRow(
          column(
            width = 10,
            mod_ranking_prov_map_ui("ranking_prov_map_1"),
            mod_foda_f_ui("foda_f_1")
          ),
          column(
            width = 6,
            mod_ranking_prov_tables_ui("ranking_prov_tables_1")
          )
        )
      ),
      controlbar = bs4DashControlbar(),
      footer = bs4DashFooter()
    )


)}
#' Add external Resources to the Application
#'
#' This function is internally used to add external
#' resources inside the Shiny application.
#'
#' @import shiny
#' @importFrom golem add_resource_path activate_js favicon bundle_resources
#' @noRd
golem_add_external_resources <- function() {
  add_resource_path(
    "www",
    app_sys("app/www")
  )

  add_resource_path(
    "img",
    app_sys("app/img")
  )
  tags$head(
    favicon(),
    bundle_resources(
      path = app_sys("app/www"),
      app_title = "bicentenario"
    )
    # Add here other external resources
    # for example, you can add shinyalert::useShinyalert()
  )
}
