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
library(shinyWidgets)
library(quantmod) 
library(plotly)

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
                    includeCSS('www/html/css/style.css'),
                    fluidRow(column(4,
                                    box(status = "primary", width = 13,
                                            pickerInput(
                                                inputId = "Id085",
                                                label = "Lista de Titulos", 
                                                choices = c('AMD', 'INTC'),
                                                options = list(size = 5)
                                            ),
                                        ),
                                    box(title = 'Stock Information', status = "warning", width = 13,
                                        textOutput('stockName'),
                                        textOutput('stockId'),
                                        htmlOutput('stockPrice'),
                                        br(),
                                        htmlOutput('stockPrices')
                                    ),
                                    box(title = 'Portfolio Information', status = "success", width = 13,
                                        htmlOutput('pTest')
                                    )
                             ),
                             column(8,
                                    box(
                                        title = "Market Price", status = "primary", solidHeader = TRUE,
                                        collapsible = TRUE,
                                        width = 20,
                                        fluidRow(
                                          column(2),
                                          column(8,
                                                 dateRangeInput("dates", "Rango de Fechas", min('2020-01-01'), max('2022-01-01'))
                                                 ),
                                          column(2)
                                        ),
                                        plotlyOutput("plot", height = 250)
                                    ),
                                    box(
                                        title = "Transactions", status = "primary", solidHeader = TRUE,
                                        collapsible = TRUE,
                                        width = 20,
                                        dataTableOutput("table")
                                    )
                             )
                    )
            ),
            tabItem(tabName = 'widgets',
                    fluidRow(column(
                        4,
                        fluidRow(
                            column(
                                12,
                                infoBox(
                                    "Account Value",
                                    paste0("$", '148,522'),
                                    icon = icon('globe'),
                                    width = 10,
                                    color = 'olive',
                                    fill = TRUE
                                )
                            ),
                            column(
                                12,
                                infoBox(
                                    "Total Cost",
                                    paste0("$", '122,876'),
                                    icon = icon('wallet'),
                                    width = 10,
                                    color = 'blue',
                                    fill = TRUE
                                )
                            ),
                            column(
                                12,
                                infoBox(
                                    "Gains",
                                    paste0("$", "25,646"),
                                    icon = icon('money-bill'),
                                    width = 10,
                                    color = 'green',
                                    fill = TRUE
                                )
                            ),
                            column(
                                12,
                                infoBox(
                                    "Shared Owned",
                                    '1,341',
                                    icon = icon('list-alt'),
                                    width = 10,
                                    color = 'navy',
                                    fill = TRUE
                                )
                            )
                        )
                    ),
                    column(
                        8,
                        box(
                            status = 'danger',
                            solidHeader = TRUE,
                            width = 12 ,
                            collapsible = FALSE,
                            collapsed = FALSE,
                            tabBox(
                                id = 'tabset1',
                                height = "250px",
                                tabPanel('Distribucion', textOutput("moncher")),
                                tabPanel('Magic', textOutput('lol')),
                                tabPanel('Desempeno', plotOutput("bar"))
                            )
                        )
                    )))
        )
    )
)

# Define server logic required to draw a histogram
server <- function(input, output, session) {

    output$plot <- renderPlotly({
        
        
        AMD <- getSymbols(input$Id085,
                          from = "2016/12/31",
                          to = "2018/12/31",
                          periodicity = "daily",
                          auto.assign = FALSE)
        index(AMD)
        
        df <- data.frame(Date=index(AMD), coredata(AMD))
        
        names(df) <- c('Date', 'Open', 'High', 'Low', 'Close', 'Volume', 'Adjusted')
        
        fig <- df %>% plot_ly(x = ~Date, type="candlestick",
                              open = ~Open, close = ~Close,
                              high = ~High, low = ~Low)
        
        fig <- fig %>% layout(xaxis = list(rangeslider = list(visible = F)))
        
        fig
    })
    
    output$table <- renderDataTable({
        ts <- read.csv("~/DataScience/EAE/Visualization2/Clase1/StockTest1/data/Transactions.csv")
        
        ts <- ts %>% dplyr::filter(Security == input$Id085)
        
        ts
    })
    
    output$stockName <- renderText({
        'Coca-Cola Co.'
    })
    output$stockId <- renderText({
        '(KO)'
    })
    output$stockPrice <- renderUI({
        tags$div(
            "50",
            #tags$img(src = "https://upload.wikimedia.org/wikipedia/commons/3/36/Up_green_arrow.png", width = "30px", height = "30px")
            tags$img(src = "https://upload.wikimedia.org/wikipedia/commons/b/b0/Down_red_arrow.png", width = "30px", height = "30px")
        )
    })
    output$stockPrices <- renderUI({
        AAPL <- getSymbols("AAPL",
                           from = "2016/12/31",
                           to = "2018/12/31",
                           periodicity = "daily",
                           auto.assign = FALSE)
        
        names(AAPL)[names(AAPL) == "AAPL.Open"] <- "Open"
        names(AAPL)[names(AAPL) == "AAPL.Close"] <- "Close"
        names(AAPL)[names(AAPL) == "AAPL.High"] <- "High"
        names(AAPL)[names(AAPL) == "AAPL.Low"] <- "Low"
        names(AAPL)[names(AAPL) == "AAPL.Volume"] <- "Volume"
        names(AAPL)[names(AAPL) == "AAPL.Adjusted"] <- "Adjusted"
        
        #AAPL[1,c("Open","Close","High", "Low", "Adjusted")]
        
        tags$table(
            tags$tr(
                tags$th("Open"),
                tags$th("Close"),
                tags$th("High"),
                tags$th("Low")
            ),
            tags$tr(
                tags$td(AAPL[1, "Open"]),
                tags$td(AAPL[1, "Close"]),
                tags$td(AAPL[1, "High"]),
                tags$td(AAPL[1, "Low"])
            )
        )
    })
    
    output$pTest <- renderUI({
        tags$table(
            tags$tr(
                tags$th("Shares Owned:"),
                tags$td("340")
            ),
            tags$tr(
                tags$th("Total Cost:"),
                tags$td("1230$")
            ),
            tags$tr(
                tags$th("Total Gain:"),
                tags$td("500$")
            ),
            tags$tr(
                tags$th("Average Share Cost:"),
                tags$td("60$")
            )
        )
    })
    
    output$moncher <- renderText({
        'Moncher!!!!'
    })
    
    output$lol <- renderText({
        'Lol!!!!'
    })
    
    output$bar <- renderPlot({
        ggplot(iris, aes(x = Sepal.Width)) + geom_histogram()
    })
    
    output$table <- renderDataTable({
        iris
    })
}

#https://www.marketwatch.com/investing/stock/ko
#https://finance.yahoo.com/quote/KO/

# Run the application 
shinyApp(ui = ui, server = server)
