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

# Define UI for application that draws a histogram
ui <- fluidPage(

    # Application title
    titlePanel("Practica 1"),

    # Sidebar with a slider input for number of bins 
    sidebarLayout(
        sidebarPanel(
            helpText("Pulsa para usar el dataset faithful. Por defecto se usara MPG"),
            checkboxInput('useFaithful', 'Usar Faithful', FALSE),
            helpText("La opcion variable solo se usara cuando estemos usando el dataset MPG"),
            selectInput('mpgColumn', 
                        'Variable de MPG', 
                        list('displ' = 'displ', 
                             'cyl' = 'cyl',
                             'cty' = 'cty',
                             'hwy' = 'hwy'))
        ),

        # Show a plot of the generated distribution
        mainPanel(
           plotOutput("distPlot"),
           textOutput("texto")
        )
    )
)

# Define server logic required to draw a histogram
server <- function(input, output) {

    output$distPlot <- renderPlot({
        p<- ggplot(mpg, aes_string(x=input$mpgColumn)) + 
            geom_histogram(color="black", fill="white", bins=20)
        
        if(input$useFaithful){
            p<- ggplot(faithful, aes(x=waiting)) + 
                geom_histogram(color="black", fill="white", bins=20)
        }
        
        p
    })
    
    output$texto <- renderText({
        t = 'Estamos usando el dataset '
        if(input$useFaithful){
            t = paste(t, 'Faithful')
        }
        else{
            t = paste(t, 'MPG')
        }
        
        t
    })
}

# Run the application 
shinyApp(ui = ui, server = server)
