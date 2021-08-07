library(shiny)
library(shinydashboard)
library(plotly)
library(readxl)
library(dplyr)
library(ggplot2)

dataP <- read.csv("Positions.csv")

shinyUI(dashboardPage(
    dashboardHeader(title = "RobinGood"),
    dashboardSidebar(
        menuItem('Inicio', tabName = 'intro', icon = icon('home')),
        menuItem('Portafolio', tabName = 'info', icon = icon('chart-line')),
        menuItem('Info por Accion', tabName = 'stock', icon = icon('chart-bar')),
        menuItem('contáctanos', tabName = 'about', icon = icon('question'))
    ),
    dashboardBody(
        tabItems(
            tabItem(tabName = 'info',
                    fluidRow(
                        column(4,
                               fluidRow(
                                   column(12,
                                          infoBox("Account Value", paste0("$",'148,522'), icon = icon('globe'), width = 10, color = 'olive', fill=TRUE)
                                   ),
                                   column(12,
                                          infoBox("Total Cost", paste0("$",'122,876'), icon = icon('wallet'), width = 10, color = 'blue', fill=TRUE)
                                   ),
                                   column(12,
                                          infoBox("Gains",paste0("$","25,646"), icon = icon('money-bill'), width = 10, color = 'green', fill=TRUE)
                                   ),
                                   # column(12,
                                   #        infoBoxOutput("gainsBox")
                                   #        ),
                                   column(12,
                                          infoBox("Shared Owned", '1,341', icon = icon('list-alt'), width = 10, color = 'navy', fill=TRUE) 
                                   )
                               )
                               #radioButtons('radio', 'Selecciona', choices = c(1,2,3), inline = TRUE),
                        ),
                        column(8,
                               box(status = 'danger', solidHeader = TRUE, width =12 , collapsible = FALSE, collapsed = FALSE,
                                   tabBox(
                                       id='tabset1',height = "250px",
                                       tabPanel('Distribucion',textOutput("moncher")),
                                       tabPanel('Magic', textOutput('lol')),
                                       tabPanel('Desempeno',plotOutput("bar"))
                                   )
                               )
                        )
                    )
                    
            ),
                tabItem(
                    tabName = 'stock',
                    fluidRow(
                        column(4,
                               selectInput('stocks','Stocks', choices = unique(dataP$Tickers)),
                               fluidRow(
                                   column(12,
                                          box())
                               ),
                               fluidRow(
                                   column(12,
                                          box())
                               )
                        ),
                        column(8,
                               box(
                                   dateRangeInput('tiempo','Periodo', start = "2019-10-31", end = "2021-1-23"),
                                   actionButton('update','Generar'),
                                   fluidRow(
                                       column(12,
                                              plotOutput('plot')
                                       ),
                                       fluidRow(
                                           column(12,
                                                  box('Datatable',
                                                      dataTableOutput('table'))
                                           )
                                       )
                                   )
                                   
                               )
                        )
                        
                    )
                )
            
            )
        
        #column(4,
        #    actionButton('dist','Distribucion')
        #    ),
        #column(4,
        #    actionButton('perf','Desempeno')
        #       )
        
        
    )
))