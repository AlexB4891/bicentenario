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
        tags$style(type="text/css", "text {font-family: sans-serif}")
      ),
      title = "Mi aplicación",
      sidebar_layout(
        sidebar_panel(
          style = "width: 300px;",
          mod_ranking_sidebar_ui("ranking_sidebar_1"),
          mod_modal_ui("modal_1")
        ),
        main_panel(
          div(
            class = "ui grid",
            div(
              class = "five wide column",
              tags$img(src = 'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcSdAtExJwW0cPeqAcLWa1LKSUYkT0R965rbAg&s',
                       style = 'height: 100px;')
            ),
            div(
              class = "five wide column",
              tags$img(src = "https://www.manabi.gob.ec/wp-content/uploads/2020/04/logogris2.png", height = "100px")
            ),
            div(
              class = "six wide column",
              tags$img(src = "https://github.com/AlexB4891/bicentenario/blob/ficha/inst/app/img/ergos.png?raw=true", height = "100px")
            )
          ),
          style = "height: calc(100vh - 70px); overflow: auto;",
          div(
            class = "ui grid",
            div(
              class = "eight wide column",
              mod_ranking_prov_map_ui("ranking_prov_map_1")
            ),
            div(
              class = "eight wide column",
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
  add_resource_path(
    "img",
    app_sys("app/img")
  )

  tags$head(
    favicon(),
    bundle_resources(
      path = app_sys("app/www"),
      app_title = "bicentenario"
    ),
    bundle_resources(
      path = app_sys("app/img"),
      app_title = "bicentenario"
    )
    # Add here other external resources
    # for example, you can add shinyalert::useShinyalert()
  )
}
