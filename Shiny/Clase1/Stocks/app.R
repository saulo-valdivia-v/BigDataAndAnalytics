#
# This is a Shiny web application. You can run the application by clicking
# the 'Run App' button above.
#
# Find out more about building applications with Shiny here:
#
#    http://shiny.rstudio.com/
#

library(shiny)
library(quantmod)

# Define UI for application that draws a histogram
ui <- fluidPage(

    # Application title
    titlePanel("Old Faithful Geyser Data"),

    # Sidebar with a slider input for number of bins 
    sidebarLayout(
        sidebarPanel(
            sliderInput("bins",
                        "Number of bins:",
                        min = 1,
                        max = 50,
                        value = 30),
            helpText('Selecciona un stock que analizar'),
            textInput('symb', 'Simbolo', 'SPY'),
            dateRangeInput('dates', 'Fechas', start = '2013-01-01', end = Sys.Date()),
            checkboxInput('adjust', 'Ajustar por Inflacion', FALSE),
            checkboxInput('log', 'Usar escala logaritmica', FALSE)
        ),

        # Show a plot of the generated distribution
        mainPanel(
           plotOutput("distPlot")
        )
    )
)

# Define server logic required to draw a histogram
server <- function(input, output) {
    
    source('helpers/ajuste_inflacion.R')
    #read.csv('data/....csv')
    
    getData <- reactive({
        data <- quantmod::getSymbols(input$symb, from=input$dates[1], to=input$dates[2], auto.assign = F)
        data
    })
    
    getAdjustedData <- reactive({
        if(!input$adjust){
            return(getData())
        }
        adjust(getData())
    })

    output$distPlot <- renderPlot({
        data <- getAdjustedData()
        
        chartSeries(data, type='line', log.scale = input$log, TA=NULL)
    })
}

# Run the application 
shinyApp(ui = ui, server = server)
