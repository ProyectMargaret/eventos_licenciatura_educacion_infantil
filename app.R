library(shiny)
library(shinydashboard)
library(tidyverse)
library(DT)
library(readr)
library(googlesheets4)

  valueFunc = function() {
    # Leer los datos del archivo CSV y realizar las transformaciones necesarias
    file1 <- "https://docs.google.com/spreadsheets/d/17_zntQUfFJ9UZFnqu1dyGoJqQHvl8D6iSRdH0N4X0os/export?format=csv&gid=0"
    data1 <- read_csv(file1) |> 
      mutate(enlace = str_remove(enlace, ".*file/d/"),
             enlace = str_remove(enlace, "/view?.*"),
             enlace = str_c("https://drive.google.com/uc?id=", enlace, "&export=download&authuser=0"),
             enlace = str_c("<a href=", enlace, ">Download</a>")) |> 
      select(nombre, cedula, enlace, certificado)
    
    file2 <- "https://docs.google.com/spreadsheets/d/17_zntQUfFJ9UZFnqu1dyGoJqQHvl8D6iSRdH0N4X0os/export?format=csv&gid=959430914"
    
    data2 <- read_csv(file2) |>
      mutate(enlace = str_remove(enlace, ".*file/d/"),
             enlace = str_remove(enlace, "/view?.*"),
             enlace = str_c("https://drive.google.com/uc?id=", enlace, "&export=download&authuser=0"),
             enlace = str_c("<a href=", enlace, ">Download</a>")) |>
      select(nombre, cedula, enlace, certificado)
    
    rbind(data1, data2)
  }

ui <- dashboardPage(skin = "yellow",
                    dashboardHeader(title = "Vicerrectoría de Investigaciones", titleWidth = 350,
                                    dropdownMenu(type = "notifications", icon = shiny::icon("code"),
                                                 badgeStatus = "info", headerText = "Desarrolladores",
                                                 tags$li(a(href = "https://github.com/srobledog",
                                                           target = "_blank",
                                                           tagAppendAttributes(icon("github")),
                                                           "Sebastian Robledo")),
                                                 tags$li(a(href = "https://github.com/bryanariasq02",
                                                           target = "_blank",
                                                           tagAppendAttributes(icon("github")),
                                                           "Bryan Arias")),
                                                 tags$li(a(href = "https://github.com/camilogs1",
                                                           target = "_blank",
                                                           tagAppendAttributes(icon("github")),
                                                           "Camilo García"))
                                    )
                    ),
                    dashboardSidebar(
                      sidebarMenu(
                        menuItemOutput("Certificados"),
                        menuItem("Proyecto Margaret", icon = icon("microscope"),
                                 href = "https://ucatolicaluisamigo-investigaciones.shinyapps.io/margaret/")
                      )
                    ),
                    dashboardBody(style = "background-color: #ffffff",
                                  fluidPage(
                                    fluidRow(column(4, align = "left", offset = 1, 
                                                    a(href = "https://www.funlam.edu.co/",
                                                      img(src = "banner.jpeg", height = 200, width = 500), 
                                                      target = "_blank")),
                                             column(4, align = "center", offset = 1, 
                                                    a(href = "https://www.funlam.edu.co/modules/centroinvestigaciones/", 
                                                      img(src = "logo.jpg", height = 150, width = 200),
                                                      target = "_blank"))),
                                    fluidRow(
                                      column(8, align = "center", offset = 2,
                                             textInput("txt", "Ingrese Número de Identificación"),
                                             actionButton("button", "Buscar")
                                      ),
                                      dataTableOutput('salida'),
                                      hr()
                                    ) 
                                  )    
                    )
)

server <- function(input, output, session) {
  
  output$Certificados <- renderMenu({
    menuItem("Certificados", icon = icon("book-open"))
  })
  
  dato <- eventReactive(input$button,
                        (input$txt),
                        ignoreNULL = FALSE, ignoreInit = FALSE
  )
  
  output$salida <- renderDT({
    valueFunc() %>%
      filter(cedula == dato()) %>%
      datatable(escape = FALSE,
                options = list(dom = 't'),
                colnames = c("Nombres y Apellidos", "Número de identificación", "Certificado", "Tipo"))
  })
}

shinyApp(ui, server)
