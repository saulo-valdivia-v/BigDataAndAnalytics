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
            sliderInput("gusto",
                        "Cuanto te gusta R? :",
                        min = 1,
                        max = 10,
                        value = 5),
            textInput("textInput",
                      "TextInput",
                      "value"),
            numericInput("numero",
                      "Input numerico",
                      5),
            selectInput("selector1",
                         "Elige una opcion",
                         list('Spain', 'France', 'Germany'))
        ),

        # Show a plot of the generated distribution
        mainPanel(
           #plotOutput("distPlot"),
           textOutput("miTexto"),
           textOutput("miTexto2")
        )
    )
)

# Define server logic required to draw a histogram
server <- function(input, output) {

    output$distPlot <- renderPlot({
        # generate bins based on input$bins from ui.R
        x    <- faithful[, 2]
        bins <- seq(min(x), max(x), length.out = input$gusto + 1)

        # draw the histogram with the specified number of bins
        #hist(x, breaks = bins, col = 'darkgray', border = 'white')
    })
    
    output$miTexto <- renderText({
        paste('Del 1 al 10, R me gusta :', input$gusto)
    })
    
    output$miTexto2 <- renderText({
        t = ''
        if(input$selector1 == 'Spain'){
            t = paste('La capital de ', input$selector1,' es Madrid')
        }
        else {
            if(input$selector1 == 'France'){
                t = paste('La capital de ', input$selector1,' es Paris')
            }
            else{
                t = paste('La capital de ', input$selector1,' es Berlin')
            }
        }
        
        t
    })
}

# Run the application 
shinyApp(ui = ui, server = server)
