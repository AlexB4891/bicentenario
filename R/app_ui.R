#' The application User-Interface
#'
#' @param request Internal parameter for `{shiny}`.
#'     DO NOT REMOVE.
#' @import shiny shiny.semantic shinydashboard
#' @noRd

app_ui <- function(request) {
  shinyUI(
    semanticPage(
      tags$head(
        tags$style(type="text/css", "text {font-family: sans-serif}"),
        tags$link(rel = "stylesheet", type = "text/css", id = "bootstrapCSS",
                  href = "https://maxcdn.bootstrapcdn.com/bootstrap/3.3.7/css/bootstrap.min.css"),
        tags$script(src = "https://maxcdn.bootstrapcdn.com/bootstrap/3.3.7/js/bootstrap.min.js")
      ),
      title = "Mi aplicación",
      suppressDependencies("bootstrap"),
      div(
        class = "ui grid",
     div(
  class = "five wide column",
  tags$img(src = "img/bicentenario.png", height = "100px")
),
div(
  class = "five wide column",
  tags$img(src = "img/prefectura.png", height = "100px")
),
div(
  class = "six wide column",
  tags$img(src = "img/ergos.png", height = "100px")
)
      ),
      sidebar_layout(
        sidebar_panel(
          style = "width: 300px;",
          mod_ranking_sidebar_ui("ranking_sidebar_1")
        ),
        main_panel(
          style = "height: calc(100vh - 70px); overflow: auto;",
          div(
            class = "ui grid",
            div(
              class = "ten wide column",
              mod_ranking_prov_map_ui("ranking_prov_map_1")
            ),
            div(
              class = "six wide column",
              mod_ranking_prov_tables_ui("ranking_prov_tables_1")
            )
          )
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
