#
# This is the server logic of a Shiny web application. You can run the
# application by clicking 'Run App' above.
#
# Find out more about building applications with Shiny here:
#
#    http://shiny.rstudio.com/
#

library(shiny)

# Define server logic required to draw a histogram
shinyServer(function(input, output) {

    output$grafica <- renderPlot({
        
        input$generar
        
        tamanio = isolate(input$size)
        distro = isolate(input$distribucion)
        
        normal <- rnorm(tamanio)
        
        if(distro=='unif'){
            normal <- runif(tamanio)    
        }
        
        hist(normal, col = 'darkgray', border = 'white')

    })

    output$salida <- renderText({
        paste('Tamano = ', input$size, ' Boton = ', input$distribucion)
    })
    
    output$salida2 <- renderText({
        'Panel Test'
    })
})
