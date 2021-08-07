
library(shiny)
library(shinydashboard)
library(tidyverse)
library(shinycssloaders)
library(shinyWidgets)
library(dplyr)
library(DT)

# Define UI for application that draws a histogram
shinyUI(dashboardPage(
    
    dashboardHeader(title="Visualizacion de pozos en Cuenca Neuquina"),
    
    dashboardSidebar(
        sidebarMenu(
            menuItem('Informacion Economica',tabName = 'economico',icon = icon("money",class="fas fa-hand-holding-usd"))
        )),
    
    dashboardBody(
        tabItems(
            tabItem(tabName = "economico",
                    fluidRow(column(
                        12,
                        box(
                            width = 15, title = "Inputs", status = "primary", solidHeader = TRUE,
                            dataTableOutput('acumulada')
                        )
                    )
            )
        )
    )
)
))