#
# This is a Shiny web application. You can run the application by clicking
# the 'Run App' button above.
#
# Find out more about building applications with Shiny here:
#
#    http://shiny.rstudio.com/
#

library(shiny)
library(shinydashboard)

#rsconnect::setAccountInfo(name='saulovaldiviaeae', token='52C45170341412FA3445DBD0EA715CC9', secret='v6zVepgk6qapBJ9euRBIWrzDDhTq4ScndkHyIdRd')

# Define UI for application that draws a histogram
ui <- dashboardPage(
    dashboardHeader(title = 'Basic Dashboard'),
    dashboardSidebar(
        sidebarMenu(
            menuItem("Dashboard", tabName = "dashboard", icon = icon("dashboard"),
                     menuSubItem('SubItem', tabName = 'mySubItem')),
            menuItem("Widgets", tabName = "widgets", icon = icon("th"))
        )
    ),
    dashboardBody(
        tabItems(
            tabItem(tabName = 'mySubItem',
                fluidRow(style='border:3px solid black',
                    column(6, style = 'border:3px solid orange',
                        fluidRow(
                            column(5, offset = 1, style = 'border:3px solid blue',
                                   selectInput('selector', 'mySelect', choices = c(1,2,3))),
                            column(6, style = 'border:3px solid white')
                        )
                    ),
                    column(6, style = 'border:3px solid green'
                        
                    )
                ),
                fluidRow(style='border:3px solid black',
                         column(4, style = 'border:3px solid orange'
                                
                         ),
                         column(4, style = 'border:3px solid green'
                                
                         ),
                         column(4, style = 'border:3px solid red'
                                
                         )
                )
            )
        )
    )
)

# Define server logic required to draw a histogram
server <- function(input, output) {

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
