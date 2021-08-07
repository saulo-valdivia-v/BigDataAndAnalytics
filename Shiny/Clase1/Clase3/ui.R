#
# This is the user-interface definition of a Shiny web application. You can
# run the application by clicking 'Run App' above.
#
# Find out more about building applications with Shiny here:
#
#    http://shiny.rstudio.com/
#

library(shiny)

# Define UI for application that draws a histogram
shinyUI(fluidPage(

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
            radioButtons('distribucion',
                         'Distribucion',
                         list('Uniforme'='unif', 'Normal'='norm')),
            textInput('size', 'Tamano de la Muestra', 10),
            actionButton('generar', 'Generar'),
            checkboxInput('custom', 'Custom Checkbox'),
            conditionalPanel("input.custom",
                             textInput('customText', 'Muestra Custom', 99)),
        ),

        # Show a plot of the generated distribution
        mainPanel(
            verbatimTextOutput('salida'),
            #plotOutput('grafica'),
            conditionalPanel("input.generar != 0",
                             plotOutput("grafica")),
            conditionalPanel("input.generar != 0 && input.size > 15 && input.size < 30",
                             verbatimTextOutput('salida2'))
        )
    )
))
