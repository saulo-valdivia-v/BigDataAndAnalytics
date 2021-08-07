shinyServer(function(input, output) {
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
    
    
    
    output$plot <- renderPlotly({
        
        AMD <- getSymbols(input$Id085,
                          from = input$dates[1],
                          to = input$dates[2],
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
    
    observe({
        print(input$dates[1])
    })
    
    output$table <- renderDataTable({
        ts <- read.csv("data/Transactions.csv")
        ts$Date <- as.Date(ts$Date, "%m/%d/%Y")
        
        ts <- ts %>% dplyr::filter(Security == input$Id085 & Date > input$dates[1] & Date < input$dates[2])
        
        ts
    })
    
    output$stockName <- renderText({
        ps <- read.csv("data/Positions.csv")
        ps <- ps %>% dplyr::filter(Tickers == input$Id085)
        
        test <- unique(ps['TickerName'])
        M <- unlist(ps['TickerName'])
        M
        #'Coca-Cola Co.'
    })
    output$stockId <- renderText({
        paste('(', input$Id085, ')')
        #'(KO)'
    })
    output$stockPrice <- renderUI({
        metrics <- yahooQF(c("Last Trade (Price Only)",
                             "Change","Change in Percent",
                             "Open", "Days High", "Days Low", "Volume"))
        symbols <- c(input$Id085)
        Target_Price_1yr <- getQuote(paste(symbols, sep="", collapse=";"), src = "yahoo", what=metrics)
        
        arrowUrl <- "https://upload.wikimedia.org/wikipedia/commons/b/b0/Down_red_arrow.png"
        
        if (Target_Price_1yr['Last'] > Target_Price_1yr['Open']) {
            arrowUrl <- "https://upload.wikimedia.org/wikipedia/commons/3/36/Up_green_arrow.png"
        }
        
        tags$div(
            Target_Price_1yr['Last'],
            tags$img(src = arrowUrl, width = "30px", height = "30px")
        )
    })
    output$stockPrices <- renderUI({
        metrics <- yahooQF(c("Last Trade (Price Only)",
                             "Change","Change in Percent",
                             "Open", "Days High", "Days Low", "Volume"))
        symbols <- c(input$Id085)
        Target_Price_1yr <- getQuote(paste(symbols, sep="", collapse=";"), src = "yahoo", what=metrics)
        
        tags$table(
            tags$tr(
                tags$th("Open"),
                tags$th("Close"),
                tags$th("High"),
                tags$th("Low")
            ),
            tags$tr(
                tags$td(Target_Price_1yr['Open']),
                tags$td(Target_Price_1yr['Last']),
                tags$td(Target_Price_1yr['High']),
                tags$td(Target_Price_1yr['Low'])
            )
        )
    })
    
    output$pTest <- renderUI({
        ps <- read.csv("data/Positions.csv")
        
        ps <- ps %>% dplyr::filter(Tickers == input$Id085)
        
        
        tags$table(
            tags$tr(
                tags$th("Shares Owned:"),
                tags$td(ps['Shares'])
            ),
            tags$tr(
                tags$th("Total Cost:"),
                tags$td(paste(round(ps['Cost'], 2), '$'))
            ),
            tags$tr(
                tags$th("Total Value:"),
                tags$td(paste(round(ps['Value'], 2), '$'))
            ),
            tags$tr(
                tags$th("Total Gain:"),
                tags$td(paste(round(ps['Gain...1'], 2), '$'))
            )
        )
    })
})