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

# Define UI for application that draws a histogram
ui <- dashboardPage(
    dashboardHeader(title = 'Ejemplo Slide'),
    dashboardSidebar(
        menuItem('Dashboard', tabName = 'dashboard')
    ),
    dashboardBody(
        tabItems(
            tabItem(tabName = 'dashboard',
                    fluidRow(
                             column(6,
                                    box(title = 'Mi Contenedor', status = 'primary', solidHeader = TRUE, width = 12, collapsible = TRUE, collapsed = FALSE,
                                        sliderInput('mySlider', 'Slider', min = 0, max = 100, value = 40),
                                        selectInput('selector', 'selector', choices = c(1,2,3)),
                                        plotOutput('plot')
                                        
                                    )
                             ),
                             column(6,
                                    box(title = 'Mi Contenedor2', status = 'danger', solidHeader = TRUE, width = 12, collapsible = TRUE, collapsed = FALSE,
                                        checkboxGroupInput('checkboxGroup', 'Selecciona', choices = c('Opcion1', 'Opcion2', 'Opcion3'), inline = TRUE),
                                        dataTableOutput("table")
                                    )
                             )
                    ),
                    fluidRow(
                        column(4, dateInput('dt', 'Fecha', value = '2013-01-01')),
                        column(4, radioButtons('radio', 'Selecciona', choices = c(1,2,3), inline = TRUE)),
                        column(4, selectInput('selector2', 'selector2', choices = c(1,2,3)))
                    )
            )
            
        )
    )
)

# Define server logic required to draw a histogram
server <- function(input, output) {

    output$plot <- renderPlot({
        # generate bins based on input$bins from ui.R
        

        # draw the histogram with the specified number of bins
        hist(rnorm(10), col = 'darkgray', border = 'white')
    })
    
    output$table <- renderDataTable({
        mtcars
    })
}

# Run the application 
shinyApp(ui = ui, server = server)
