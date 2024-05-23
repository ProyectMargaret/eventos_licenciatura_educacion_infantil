library(shiny)
library(shinydashboard)
library(tidyverse)
library(here)
library(DT)
library(readxl)
library(googlesheets4)

# Deshabilitar la autenticación si el archivo es público
gs4_deauth()

# source(here("data","files.R"))

# URL del Google Sheets
sheet_url <- "https://docs.google.com/spreadsheets/d/1RlqYP8SEnJAQR00BHeyjovjB4Bm6PduT77ApeaekzwM/edit?hl=en&forcehl=1#gid=0"

# data <- read_csv(file1) |> 
#  mutate(enlace = str_remove(enlace, ".*file/d/"),
#         enlace = str_remove(enlace, "/view?.*"),
#         enlace = str_c("https://drive.google.com/uc?id=",enlace,"&export=download&authuser=0"),
#         enlace= str_c("<a href=",
#                       enlace,
#                       ">Download</a>")) |> 
#  select(nombre,cedula,enlace,certificado)

# data2 <- read_csv(file2) |>
# mutate(enlace = str_remove(enlace, ".*file/d/"),
#         enlace = str_remove(enlace, "/view?.*"),
#         enlace = str_c("https://drive.google.com/uc?id=",enlace,"&export=download&authuser=0"),
#         enlace= str_c("<a href=",
#                       enlace,
#                       ">Download</a>"),
#         certificado = "IV Encuentro Nacional de Semilleros de Investigación") |>
#  select(nombre, cedula,enlace,certificado)

# data <- rbind(data1, data2)

# Leer los datos desde Google Sheets
data <- read_sheet(sheet_url) %>%
  mutate(enlace = str_remove(enlace, ".*file/d/"),
         enlace = str_remove(enlace, "/view?.*"),
         enlace = str_c("https://drive.google.com/uc?id=", enlace, "&export=download"),
         enlace = str_c("<a href=\"", enlace, "\">Download</a>")) %>%
  select(nombre, cedula, enlace, certificado)

# ui <- dashboardPage(skin = "yellow",
  #                  dashboardHeader(title = "Vicerrectoría de Investigaciones", titleWidth = 350,
   #                                 dropdownMenu(type = "notifications", icon = shiny::icon("code"),
    #                                             badgeStatus = "info", headerText = "Desarrolladores",
     #                                            tags$li(a(href = "https://github.com/srobledog",
      #                                                     target = "_blank",
       #                                                    tagAppendAttributes(icon("github")),
        #                                                   "Sebastian Robledo")),
         #                                        tags$li(a(href = "https://github.com/bryanariasq02",
          #                                                 target = "_blank",
           #                                                tagAppendAttributes(icon("github")),
            #                                               "Bryan Arias")),
             #                                    tags$li(a(href = "https://github.com/camilogs1",
              #                                             target = "_blank",
               #                                            tagAppendAttributes(icon("github")),
                #                                           "Camilo García"))
                 #                   )
                  #  ),
#dashboardSidebar(
 # sidebarMenu(
  #  menuItemOutput("Certificados"),
   # menuItem("Proyecto Margaret", icon = icon("microscope"),
    #         href = "https://ucatolicaluisamigo-investigaciones.shinyapps.io/margaret/")
  #)
#),
#dashboardBody(style = "background-color: #ffffff",
              
 #             fluidPage(
  #              fluidRow(column(4, align="left", offset = 1, 
   #                             a(href="https://www.funlam.edu.co/",
    #                              img(src="banner.jpeg", height=200, width=500), 
     #                             target="_blank")),
      #                   column(4, align="center", offset = 1, 
       #                         a(href="https://www.funlam.edu.co/modules/centroinvestigaciones/", 
        #                          img(src="logo.jpg", height=100, width=100),
         #                         target="_blank"))),
          #      fluidRow(
           #       column(8, align="center", offset = 2,
            #             textInput("txt", "Ingrese Número de Identificación"),
             #            actionButton("button", "Buscar")
              #    ),
               #   dataTableOutput('salida'),
                #  hr()
                #) 
             # )    
#)
#)

#server <- function(input, output) {
  
 # output$Certificados <- renderMenu({
  #  menuItem("Certificados", icon = icon("book-open"))
  #})
  
  #dato <- eventReactive(input$button,
   #                     (input$txt),
    #                    ignoreNULL = FALSE,ignoreInit = FALSE
 # )
  
  #output$salida <- renderDT({
   # data |> filter(cedula == dato()) |> 
    #  datatable(escape = FALSE,
     #           options = list(dom = 't'),
      #          colnames = c("Nombres y Apellidos", "Número de identificación", "Certificado", "Tipo"))
  #})
#}

#shinyApp(ui, server)

# Definir la interfaz de usuario
ui <- dashboardPage(
  skin = "yellow",
  dashboardHeader(
    title = "Vicerrectoría de Investigaciones", titleWidth = 350,
    dropdownMenu(type = "notifications", icon = shiny::icon("code"),
                 badgeStatus = "info", headerText = "Desarrolladores",
                 tags$li(a(href = "https://github.com/srobledog", target = "_blank",
                           tagAppendAttributes(icon("github")), "Sebastian Robledo")),
                 tags$li(a(href = "https://github.com/bryanariasq02", target = "_blank",
                           tagAppendAttributes(icon("github")), "Bryan Arias")),
                 tags$li(a(href = "https://github.com/camilogs1", target = "_blank",
                           tagAppendAttributes(icon("github")), "Camilo García"))
    )
  ),
  dashboardSidebar(
    sidebarMenu(
      menuItem("Certificados", icon = icon("book-open"))
      # Comentado el menú "Proyecto Margaret"
      # menuItem("Proyecto Margaret", icon = icon("microscope"),
      #          href = "https://ucatolicaluisamigo-investigaciones.shinyapps.io/margaret/")
    )
  ),
  dashboardBody(
    style = "background-color: #ffffff",
    fluidPage(
      fluidRow(
        column(4, align = "left", offset = 1,
               a(href = "https://www.funlam.edu.co/",
                 img(src = "banner.jpeg", height = 200, width = 500),
                 target = "_blank")),
        column(4, align = "center", offset = 1,
               a(href = "https://www.funlam.edu.co/modules/centroinvestigaciones/",
                 img(src = "logo.jpg", height = 100, width = 100),
                 target = "_blank"))
      ),
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

# Definir la lógica del servidor
server <- function(input, output) {
  
  output$Certificados <- renderMenu({
    menuItem("Certificados", icon = icon("book-open"))
  })
  
  dato <- eventReactive(input$button, {
    input$txt
  }, ignoreNULL = FALSE, ignoreInit = FALSE)
  
  output$salida <- renderDT({
    data %>% filter(cedula == dato()) %>%
      datatable(escape = FALSE, options = list(dom = 't'),
                colnames = c("Nombres y Apellidos", "Número de identificación", "Certificado", "Enlace"))
  })
}

# Ejecutar la aplicación Shiny
shinyApp(ui, server)
