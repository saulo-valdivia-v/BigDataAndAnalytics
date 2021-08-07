#
# This is a Shiny web application. You can run the application by clicking
# the 'Run App' button above.
#
# Find out more about building applications with Shiny here:
#
#    http://shiny.rstudio.com/
#

library(shiny)
library(ggplot2)
library(dplyr)
library(DT)

# Define UI for application that draws a histogram
ui <- fluidPage(

    # Application title
    titlePanel("Practica 2"),

    sidebarLayout(
        sidebarPanel(
            conditionalPanel("input.tabs == 'Grafica'", uiOutput('sunspotsTab')),
            conditionalPanel("input.tabs == 'Tabla'", uiOutput('biostatsTab'))
        ),

        mainPanel(
           tabsetPanel(id = 'tabs',
                       tabPanel("Grafica", plotOutput("plot")), 
                       tabPanel("Tabla", dataTableOutput("table"))
           )
        )
    )
)

# Define server logic required to draw a histogram
server <- function(input, output, session) {
    
    getSunspotsData <- reactive({
        sData <- read.csv('sunspots.csv')
        sData$Month <- as.Date(sData$Month, "%Y-%m-%d")
        sData
    })
    
    getBioData <- reactive({
        bioData <- read.csv('biostats.csv')
        bioData
    })
    
    output$sunspotsTab <- renderUI({
        sData <- getSunspotsData()
        
        tagList(dateRangeInput("dates", "Fechas", min(sData$Month), max(sData$Month)),
                actionButton('updateSunspotsTab', 'Actualizar'))
    })
    
    output$biostatsTab <- renderUI({
        bioData <- getBioData()
        
        tagList(selectInput('sex', 'Sexo', choices=unique(bioData$Sex)),
                numericInput('age', 'Edad', value = as.integer(median(bioData$Age)), min = min(bioData$Age), max = max(bioData$Age)),
                numericInput('height', 'Altura', value = as.integer(median(bioData$Height..in.)), min = min(bioData$Height..in.), max = max(bioData$Height..in.)))
    })

    observeEvent(input$updateSunspotsTab, {
        updateDateRangeInput(session, 'dates', start=input$dates[1], end=input$dates[2])
    })
    
    output$plot <- renderPlot({
        input$updateSunspotsTab
        
        sData <- getSunspotsData()
        isolate({
            minDate <- input$dates[1]
            maxDate <- input$dates[2]
        })
        
        sData <- sData %>% dplyr::filter(Month > minDate & Month < maxDate)
        p <- ggplot(sData, aes(x=Month, y=Sunspots)) + geom_line()
        p
    })
    
    output$table <- renderDataTable({
        bioData <- getBioData()
        
        bioData <- bioData %>% dplyr::filter(Sex == input$sex & Age >= input$age & Height..in. >= input$height)
        bioData
    })
}

# Run the application 
shinyApp(ui = ui, server = server)
