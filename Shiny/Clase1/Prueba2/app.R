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
library(plotly)

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
            selectInput("variable1",
                        "Que variable quieres",
                        list('Miles per Gallon' = 'mpg', 
                             'Displacement' = 'disp')),
            selectInput("facet",
                        "Variable Facet",
                        list('cyl', 
                             'gear')),
            checkboxInput("facetsCheck",
                        "Incluir Facets",
                        FALSE),
            checkboxGroupInput("multiCheck",
                        "Selecciona una opcion",
                        list('color', 
                             'size'))
        ),

        # Show a plot of the generated distribution
        mainPanel(
           #plotOutput("distPlot")
            plotlyOutput("distPlot"),
            plotlyOutput("distPlot2"),
            plotlyOutput("distPlot3")
        )
    )
)

# Define server logic required to draw a histogram
server <- function(input, output) {

    observe({
        print(input$variable1)
    })
    
    #output$distPlot <- renderPlot({
    output$distPlot <- renderPlotly({
        #p<- ggplot(faithful, aes(x=waiting)) + 
        #    geom_histogram(color="black", fill="white", bins = input$bins)
        #p
    
        #p<- ggplot(mtcars) + 
        #    geom_point(aes_string(input$variable1, 'hp'), color="black", fill="white")
        #p
        
        ggplotly(ggplot(mtcars) + geom_point(aes_string(input$variable1, 'hp')))
    })
    
    output$distPlot2 <- renderPlotly({
        ggplotly(ggplot(mtcars) + 
                     geom_point(aes_string(input$variable1, 'hp')) + 
                     facet_wrap(as.formula(paste0('~', input$facet))))
    })
    
    output$distPlot3 <- renderPlotly({
        p = ggplot(mtcars) + geom_point(aes_string(input$variable1, 'hp'))
        
        if(input$facetsCheck){
            p = p + facet_wrap(as.formula(paste0('~', input$facet)))
        }
        
        ggplotly(p)
    })
}

# Run the application 
shinyApp(ui = ui, server = server)
