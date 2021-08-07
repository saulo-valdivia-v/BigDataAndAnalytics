#
# This is a Shiny web application. You can run the application by clicking
# the 'Run App' button above.
#
# Find out more about building applications with Shiny here:
#
#    http://shiny.rstudio.com/
#

library(shiny)
library(dplyr)

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
            uiOutput('myUI')
        ),

        # Show a plot of the generated distribution
        mainPanel(
           plotOutput("distPlot")
        )
    )
)

# Define server logic required to draw a histogram
server <- function(input, output) {
    
    output$myUI <- renderUI({
        
        df <- data.frame(
            Country = c('Spain', 'France', 'Germany', 'Italy', 'Portugal'),
            Population = c(35000000, 46000000, 10000000, 78000000, 25500000)
        )
        
        df_filtrado <- df %>% dplyr::filter(Population > 26000000)
        
        selectInput('selector2', 's2', choices=df_filtrado$Country)   
    })
    
    getData <- reactive({
        normal = rnorm(100)
        normal
    })

    output$distPlot <- renderPlot({
        data <- getData()
        hist(data)
    })
}

# Run the application 
shinyApp(ui = ui, server = server)
