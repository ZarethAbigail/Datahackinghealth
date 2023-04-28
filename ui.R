# Librerias ---------------------------------------------------------------

library(shiny)
library(shinydashboard)
library(tidyverse)       # Para manejo de datos
library(DT)              # Para tablas
library(plotly)          # Para graficas interactivas
library(shinyalert)
library(shinyWidgets)

# ui ----------------------------------------------------------------------

ui <- dashboardPage(skin = "purple",

# Header ------------------------------------------------------------------
                    
dashboardHeader(title = "Medigap",
                dropdownMenu(type = "messages",
                             messageItem(from = "Inicio",
                                         message = "Consulta nuestra web",
                                         icon = icon("home"),
                                         href = "https://www.google.com",
                                         ),
                             messageItem(from = "Contactanos",
                                         message = "Da click para contactarnos",
                                         icon("envelope", lib = "glyphicon"),
                                         href = "https://www.gmail.com",
                                         )
                             )
   ),
                    
# Sidebar -----------------------------------------------------------------
                    
dashboardSidebar(sidebarMenu(
  menuItem("¿Qué es Medigap?",    tabName = "seccion_01", icon = icon("pushpin", lib = "glyphicon")),
  menuItem("Carga de archivos",     tabName = "seccion_02", icon = icon("save", lib = "glyphicon")),
  menuItem("Estadística general",   tabName = "seccion_03", icon = icon("check", lib = "glyphicon")),
  menuItem("Correlación y gráficas",  tabName = "seccion_04", icon = icon("stats", lib ="glyphicon"))
  )
  ),
                    
# Body --------------------------------------------------------------------
                    
dashboardBody(
tags$style(HTML("
.box.box-solid.box-primary>.box-header {
  color:#fff;
  background:#605CAA
                    }

.box.box-solid.box-primary{
border-bottom-color:#605CAA;
border-left-color:#605CAA;
border-right-color:#605CAA;
border-top-color:#605CAA;
}

                                   ")),
tabItems(
  tabItem("seccion_01",
          fluidRow(
            h1("Medigap: App para hospitales", align = "center"), 
            br(),
            
            box(width = 6, solidHeader = FALSE,
                h2("¿Qué hace nuestra aplicación?", align = "left"),
                p("Nuestra aplicación, Medigap, ayuda a los hospitales a manejar sus bases de datos de una manera más sencilla y rápida. Medigap puede trabajar con cualquier base de datos y solo cargandola a la aplicación podrá obtener las estadisticas generales de ella al igual que correlaciones y gráficas.")
                ),
            
            box(width = 6, solidHeader = FALSE,
                h2("Historia de Medigap", align = "left"),
                p("Medigap fue creada y públicada en Abril de 2023 por 3 estudiantes de último semestre de preparatioria. Anette Hernández, Abigail Rodríguez y Helena Escandón crearon juntas Medigap para su tópico de Hacking Health el cual estaba relacionado con ciencia de datos y biomedicina. Desde su creación, ha ayudado a diversos hospitales en diversas áreas.")
                ),
            
            box(width = 12, title = "¿Cómo se usa Medigap?", status = "primary", solidHeader = TRUE,
                strong("Usar Medigap es muy fácil."),
                p("Únicamente debe de subir su base de datos, la cual forzosamente tiene que estar en formato csv para que podamos procesarla. Después de subirla en la parte de Carga de Archivos* solo debe de abrir el apartado de *Estadística general* para ver un pequeño resumen de su base de datos y finalmente debe de abrir *Correlaciones y gráficas* para poder visualisar sus gráficas y poder interactuar con ellas y cambiarlas a su gusto.")
                ),
            
            box(width = 6, background = "purple",
                strong("Contactanos"),
                p("Contacta a las fundadoras en caso de algún problema con la aplicación"),
                em("Anette Hernández (a01660081@tec.mx)"),
                br(),
                em("Abigail Rodríguez (a01659378@tec.mx)"),
                br(),
                em("Helena Escandón (a01659511@tec.mx)")
                ),
            )
          ),
  tabItem("seccion_02",
          fluidRow(
            h1("Carga de Archivos", align = "center"), 
            
            br(),
            
            column(width = 12,
                   
                   box(title = "Archivo de base de datos",
                       width = 4, status = "primary", solidHeader = TRUE,
                       fileInput("archivo", "Selecciona tu archivo:", accept = ".csv")
                       ),
                   box(width = 3, background = "purple", solidHeader = FALSE,
                       em("El archivo no podrá ser leído por la aplicación si no esta en formato csv")
                       ),
                   box(title = "Tabla de base de datos",
                       width = 12, status = "primary", solidHeader = TRUE,
                       fluidPage(dataTableOutput("tabla"))
                       )
                   )
            )
          ),
  
  tabItem("seccion_03",
          fluidRow(
            box(title = "Gráfica General",
                width = 8, status = "primary", solidHeader = TRUE,
                plotlyOutput("grafica_general", height = 400)
                ),
            
            column(3,
                   setSliderColor(c("#605CAA", "#605CAA"), c(1, 2)),
                   sliderInput("slider1", h3("Sliders"),
                   min = 0, max = 100, value = 50),
                   sliderInput("slider2", "",
                               min = 0, max = 100, value = c(25, 75))
                   ),
            
                               tags$style(".nav-tabs {background: #f4f4f4;}
                .nav-tabs-custom .nav-tabs li.active:hover a, .nav-tabs-custom .nav-tabs li.active a {background-color: #fff;
                                               border-color: ##605CAA;                                                      
                                               }
                .nav-tabs-custom .nav-tabs li.active {border-top-color: 
                                                      #605CAA;
                                                      }"
                                         ),
            
                   tabBox(
                     title = "Estadística general",
                     id = "tabset1", height = "250px", width = 8,
                                           tabPanel("Promedio, Moda, Mediana", textOutput("conteo_hombres"), textOutput("conteo_mujeres")),
                                           tabPanel("Min, Max, Rango", "Tab content 2"),
                                           tabPanel("Ecuación linear", "Tab content 3"),
                     ),
                   )
            ),
  
  tabItem("seccion_04",
          fluidRow(
            box(title = "Correlación",
                width = 9, status = "primary", solidHeader = TRUE,
                plotlyOutput("grafica_c", height = 500)
                ),
            
            box(title = "Selector de variables",
                width = 3, status = "primary", solidHeader = TRUE,
                selectInput("variable_x", "Selecciona la variable x",
                            c("Altura del paciente" = "Altura",
                              "Peso del paciente" = "Peso",
                              "Tiempo de respuesta" = "Minutos",
                              "Examen de glucosa" = "Examen 1",
                              "Examen del corazón" = "Examen 2",
                              "Examen de pulmoanes" = "Examen 3")),
                selectInput("variable_y", "Selecciona la variable y",
                            c("Altura del paciente" = "Altura",
                              "Peso del paciente" = "Peso",
                              "Tiempo de respuesta" = "Minutos",
                              "Examen de glucosa" = "Examen 1",
                              "Examen del corazón" = "Examen 2",
                              "Examen de pulmoanes" = "Examen 3"))
                ),
            )
          )
  )
)
)
                    
