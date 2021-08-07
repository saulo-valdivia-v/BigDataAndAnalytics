#
# This is a Shiny web application. You can run the application by clicking
# the 'Run App' button above.
#
# Find out more about building applications with Shiny here:
#
#    http://shiny.rstudio.com/
#

library(shiny)

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
            textInput('miTexto', 'Introduce Texto'),
            actionButton('boton', 'Boton'),
            actionButton('boton2', 'Boton2'),
            actionButton('uniform', 'Uniform'),
            actionButton('normal', 'Normal')
        ),

        # Show a plot of the generated distribution
        mainPanel(
           plotOutput("distPlot"),
           textOutput('resultado')
        )
    )
)

# Define server logic required to draw a histogram
server <- function(input, output) {

    values <- reactiveValues() # values <- list() lista de valores reactivos
    
    #observeEvent(input$miTexto, {
    observeEvent(input$boton, {
        #values$texto <- input$miTexto
        values$texto <- 'Se ha pulsado 1'
    })
    
    observeEvent(input$boton2, {
        values$texto <- 'Se ha pulsado 2'
    })
    
    output$resultado <- renderText({
        values$texto
    })
    
    observeEvent(input$uniform, {
        values$plotData <- runif(20)
    })
    
    observeEvent(input$normal, {
        values$plotData <- rnorm(20)
    })
    
    output$distPlot <- renderPlot({
        if(!is.null(values$plotData)){
            hist(values$plotData, col = 'darkgray', border = 'white')   
        }
    })

}

# Run the application 
shinyApp(ui = ui, server = server)
