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
            numericInput('inputNumerico', 'Mi input numerico', min=10, max=150, step = 1, value = 50),
            selectInput('inputSelect', 'Selector', choices = list('1', '2', '3')),
            actionButton('actualizar', 'Actualizar'),
            uiOutput('myUI')
        ),

        # Show a plot of the generated distribution
        mainPanel(
           plotOutput("distPlot")
        )
    )
)

# Define server logic required to draw a histogram
server <- function(input, output, session) {
    
    output$myUI <- renderUI({
        tagList(
            radioButtons('rbtn', NULL, choices = c(1,2,3)),
            selectInput('selector2', 's2', choices=c(12,13,14))   
        )
    })
    
    observeEvent(input$actualizar, {
        #updateNumericInput(session, 'inputNumerico', label = 'Nuevo Label')
        updateSelectInput(session, 'inputSelect', choices = list('5', '6', '7'))
    })

    output$distPlot <- renderPlot({
        # generate bins based on input$bins from ui.R
        x    <- faithful[, 2]
        bins <- seq(min(x), max(x), length.out = input$bins + 1)

        # draw the histogram with the specified number of bins
        hist(x, breaks = bins, col = 'darkgray', border = 'white')
    })
}

# Run the application 
shinyApp(ui = ui, server = server)
