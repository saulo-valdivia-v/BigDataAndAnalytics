
# Define server logic required to draw a histogram
shinyServer(function(input, output) {
  output$moncher <- renderText({
    'Moncher!!!!'
  })
  
  output$lol <- renderText({
    'Lol!!!!'
  })
  
  output$bar <- renderPlot({
    ggplot(iris, aes(x=Sepal.Width)) + geom_histogram()
  })
  
  output$table <- renderDataTable({
    iris
  })
  
})