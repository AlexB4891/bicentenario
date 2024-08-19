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
              p("
El indicador ha sido construido utilizando un Análisis Factorial Múltiple (AFM) que integra cinco dimensiones clave, reflejando así la naturaleza multidimensional del fenómeno que se estudia. Cada una de estas dimensiones representa un componente esencial del indicador global. Al desagregarlo, no solo obtenemos una visión comparativa más clara entre las empresas de diferentes provincias, sino que también revelamos sus fortalezas y áreas de mejora específicas, ofreciendo una herramienta poderosa para la toma de decisiones estratégicas y el desarrollo regional.")
            )
          ),
          div(
            class = "ui grid",
            div(
              class = "sixteen wide column",
              mod_radares_ui("radares_1")
            )
          ),
          div(
            class = "sixteen wide column",
          p(strong("1. Prácticas de Gestión:"), "Esta dimensión refleja la adopción de tecnologías de la información y la comunicación (TICs) en la gestión empresarial. Aquí se consideran diez prácticas clave que representan cómo las empresas utilizan las TICs para optimizar sus procesos de negocio. Desde la automatización de tareas administrativas hasta la implementación de sistemas avanzados de gestión de recursos, estas prácticas son fundamentales para mantener una operación eficiente y competitiva en un entorno empresarial moderno."),

          p(strong("2. Inversión en TICs:"), "La inversión en tecnologías es un factor crítico para determinar la capacidad de una empresa para innovar y mantenerse relevante. En este gráfico, se mide a través de un puntaje que va del 1 al 20, basado en la posición de la empresa dentro de grupos porcentuales de inversión (quintiles). Cuanto mayor sea la puntuación, mayor es la inversión relativa de la empresa en comparación con sus pares, destacando su compromiso con la modernización tecnológica."),

          p(strong("3. Retorno de Compras:"), "El retorno de compras es un indicador de la eficiencia comercial, calculado como la proporción entre ventas y compras. Este ratio revela cuán efectivamente una empresa convierte sus inversiones en inventario en ingresos. Un retorno alto sugiere una operación comercial ágil y bien gestionada, donde las compras se transforman rápidamente en ventas, impulsando la rentabilidad."),

          p(strong("4. Cultura de Uso:"), "Esta dimensión captura la penetración de especialistas en TICs dentro de la plantilla laboral de la empresa. Un mayor porcentaje de expertos en tecnologías en relación con el total de empleados indica una cultura organizacional que valora y depende del conocimiento técnico para impulsar la innovación y la eficiencia operativa, lo que fortalece la capacidad de adaptación y crecimiento en un mercado digital."),

          p(strong("5. Calidad del Uso:"), "Medir la calidad del uso de las TICs implica evaluar hasta qué punto las empresas están implementando prácticas que maximicen el valor de estas tecnologías. Aquí, se consideran 51 criterios diferentes, cada uno representando un aspecto crucial de la aplicación efectiva de las TICs. El porcentaje que las empresas cumplen de estos criterios indica su nivel de madurez tecnológica, proporcionando una visión clara de su capacidad para utilizar la tecnología de manera óptima.")
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
