#
# This is the user-interface definition of a Shiny web application. You can
# run the application by clicking 'Run App' above.
#
# Find out more about building applications with Shiny here:
#
#    http://shiny.rstudio.com/
#

library(shiny)
library(shinydashboard)
library(tidyverse)
library(shinycssloaders)
library(shinyWidgets)
library(dplyr)
library(DT)

# Define UI for application that draws a histogram
shinyUI(dashboardPage(skin = "green",
                      
                      dashboardHeader(title="Visualizacion de pozos en Cuenca Neuquina"),
                      
                      dashboardSidebar(
                          sidebarMenu(
                              menuItem('Informacion Economica',tabName = 'economico',icon = icon("money",class="fas fa-hand-holding-usd"))
                          )),
                      
                      dashboardBody(
                          tabItems(
                              tabItem(tabName = "economico",
                                      fluidRow(
                                          column(
                                              4,
                                              box(width = 15, status = "success", title='Variables Independientes',solidHeader = TRUE,
                                                  br(),
                                                  column(4,
                                                         box(
                                                           width = 33, solidHeader = FALSE, status = "success",
                                                         textInput('precio_OIL','OIL'))
                                                  ),
                                                  column(4,
                                                         box(
                                                           width = 33, solidHeader = FALSE, status = "success",
                                                         textInput('precio_GAS','GAS'))
                                                  ),
                                                  column(4,
                                                         box(
                                                           width = 33, solidHeader = FALSE, status = "success",
                                                         textInput('precio_LPG','LPG'))
                                                  ),
                                                  fluidRow(
                                                    column(4,
                                                           box(
                                                             width = 40, solidHeader = FALSE, status = "success",
                                                             textInput('regalia','Regalias'))
                                                           ),
                                                    column(4,
                                                           box(
                                                             width = 40, solidHeader = FALSE, status = "success",
                                                             textInput('IIBB_Oil','IIBB_Oil'))
                                                          ),
                                                    column(4,
                                                           box(
                                                             width = 40, solidHeader = FALSE, status = "success",
                                                             textInput('IIBB_Gas','IIBB_Gas'))
                                                    )
                                                           
                                                      
                                                    )
                                                  ,
                                                  fluidRow(
                                                      column(12,
                                                             br(),
                                                             #tags$style(HTML(".js-irs-2 .irs-single, .js-irs-2 .irs-bar-edge, .js-irs-2 .irs-bar {background: green}")),
                                                             sliderInput('lifting','Lifting Cost', min = 0, max = 10, value = 0.65, step = 0.5)
                                                      )
                                                  ),
                                                  br(),
                                                  fluidRow(
                                                    column(6,
                                                           box(
                                                             width = 33, solidHeader = FALSE, status = "success",
                                                             textInput('IIGG_2020','IIGG_2020'))
                                                      
                                                    ),
                                                    column(6,
                                                           box(
                                                             width = 33, solidHeader = FALSE, status = "success",
                                                             textInput('ITF','ITF'))
                                                           
                                                    )
                                                    
                                                  ),
                                                  br(),
                                                  textInput('capex','CAPEX'),
                                                  br(),
                                                  br(),
                                                  textInput('desc','Tasa de Descuento'),
                                                  submitButton(text = "Applicar Cambios")
                                              )),
                                          column(8,
                                                 verbatimTextOutput('calc0'), 
                                                 
                                                 box(width = 15, title = 'Resultados Economicos', solidHeader = TRUE, status = 'success',
                                                     column(
                                                         4,
                                                         box(
                                                             width = 15, title = 'VAN', solidHeader = TRUE, status = "primary",
                                                             verbatimTextOutput('calc1')
                                                         ),
                                                         br(),
                                                         br(),
                                                         box(
                                                             width = 15, title = 'TIR', solidHeader = TRUE, status = "primary",
                                                             verbatimTextOutput('calc2')
                                                         ),
                                                         br(),
                                                         br(),
                                                         box(
                                                             width = 15, title = 'VAN_IA', solidHeader = TRUE, status = "primary",
                                                             verbatimTextOutput('calc4')
                                                         )
                                                     ),
                                                     column(
                                                         8,
                                                         box(
                                                             width=15, title = "Flujo de Caja acumulado esperado", status = "primary", solidHeader = TRUE,
                                                             dataTableOutput('acumulada'))
                                                     ))
                                          )
                                      ),
                                      fluidRow(
                                          #column(6,
                                          #      plotOutput('fijo')
                                          #),
                                          #column(12,
                                                 #plotlyOutput('acum'))
                                      )
                              )
                          )
                      )
)
)
