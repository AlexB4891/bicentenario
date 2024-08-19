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
        tags$style( "
 #smallbox {
            color: #3D3D3D;
            background-color: white;
            padding: 10px;
            border-radius: 10px;
            height: 100%;
          }
          #bigbox {
            color: #3D3D3D;
            background-color: #F5F5F5;
            padding: 10px;
            border-radius: 10px;
            margin: 10px;
            display: flex;
            align-items: flex-start;
          }
          .flex-container {
            display: flex;
            align-items: flex-start;
          }
")
      ),
      title = "Mi aplicación",
      sidebar_layout(
        sidebar_panel(
          # style = "width: 300px;",
          mod_ranking_sidebar_ui("ranking_sidebar_1"),
          div(class = "sidebar-content",
          mod_modal_ui("modal_1"))
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
          # style = "height: calc(100vh - 70px); overflow: auto;",
          div(class = "ui grid",
              div(
                class = "eight wide column",
                  div(class = "ui raised segment",
                      div(
                        a(class="ui green ribbon label", "Ecuador y las TICS"),
                        p("¡Bienvenidos a nuestra aplicación! Este mapa interactivo ilustra la distribución geográfica del
                          índice de adopción de Tecnologías de la Información y la Comunicación (TIC) en Ecuador.
                          Utilizando una paleta de colores, el mapa revela qué tan intensivo es el uso promedio de las TIC en
                          cada provincia. Cada empresa dentro de una provincia tiene su propio nivel de adopción, pero
                          aquí presentamos un indicador agregado que permite comparar el comportamiento general entre
                          las distintas provincias del país. Nuestro objetivo es ofrecer una visión clara y
                          comprensible de cómo se están utilizando las TIC en todo Ecuador, facilitando el análisis y la
                          toma de decisiones informadas.")
                      ))),
              div(
                class = "eight wide column",
                div(class = "ui raised segment",
                    div(
                      a(class="ui red ribbon label", "¿Comó funciona?"),
                      p("Nuestro mapa interactivo se basa en el ranking de adopción de TIC's en las provincias de Ecuador, ilustrado en esta tabla. El índice de uso de TIC's, mostrado en un gradiente de colores, destaca la intensidad del uso promedio de estas tecnologías en cada provincia. La tabla clasifica las provincias según su índice de adopción de TIC's y proporciona variables clave como inversión en TIC, personal en TIC, ventas en línea y número de empresas. Estas variables se relacionan directamente con el índice, ofreciendo una visión integral y comparativa del uso de TIC's, y permitiendo un análisis estratégico del desarrollo tecnológico en todo el país.")
                    ))
              )

              ),
          div(
            id = "bigbox",
            class = "ui grid flex-container",
            div(
              id = "smallbox",
              class = "eight wide column",
              mod_ranking_prov_map_ui("ranking_prov_map_1")
            ),
            div(
              id = "smallbox",
              class = "eight wide column",
              mod_ranking_prov_tables_ui("ranking_prov_tables_1")
            )
          ),
          div(
            class = "ui grid",
            div(
              class = "sixteen wide column",
              mod_radares_ui("radares_1")
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
