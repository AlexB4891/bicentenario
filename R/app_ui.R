#' The application User-Interface
#'
#' @param request Internal parameter for `{shiny}`.
#'     DO NOT REMOVE.
#' @import shiny shiny.semantic
#' @noRd
app_ui <- function(request) {
  tagList(
    # Leave this function for adding external resources
    golem_add_external_resources(),
    # Your application UI logic
    fluidPage(
      titlePanel(
        shiny::fluidRow(
          shiny::column(4, shiny::img(src = "www/bicentenario.png", height = "100px")),
          shiny::column(4, shiny::img(src = "www/prefectura.png", height = "100px")),
          shiny::column(4, shiny::img(src = "www/ergos.png", height = "100px"))
        )
      ),
      sidebarLayout(
        sidebarPanel(
          mod_ranking_sidebar_ui("ranking_sidebar_1")
        ),
        main_panel(
          mod_ranking_prov_map_ui("ranking_prov_map_1")
          # Add here the UI for the main body
          # For example, you can add a tabsetPanel
          # with multiple tabs
        )

    )
  )
  )
}

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
