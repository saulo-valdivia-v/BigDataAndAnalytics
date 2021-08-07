shinyServer(function(input, output) {
    
    getStockPortfolioData <- reactive({
        ps <- cbind(dataPositions)
        ps <- ps %>% dplyr::filter(Tickers == input$stockPicker)
        
        ps['Cost'] <- round(ps['Cost'], 2)
        ps['Value'] <- round(ps['Value'], 2)
        ps['Gain...1'] <- round(ps['Gain...1'], 2)
        
        ps
    })
    
    getStockTransactionsData <- reactive({
        input$generar
        
        inicio_periodo = isolate(input$dates[1])
        fin_periodo = isolate(input$dates[2])
        
        ts <- cbind(dataTransactions)
        ts <- ts %>% dplyr::filter(Security == input$stockPicker & Date > inicio_periodo & Date < fin_periodo)
        ts
    })
    
    getStockMetrics <- reactive({
        metrics <- yahooQF(c("Last Trade (Price Only)",
                             "Change","Change in Percent",
                             "Open", "Days High", "Days Low", "Volume"))
        symbols <- c(input$stockPicker)
        getQuote(paste(symbols, sep="", collapse=";"), src = "yahoo", what=metrics)
    })
    
    getStockMarketData <-reactive({
        input$generar
        
        inicio_periodo = isolate(input$dates[1])
        fin_periodo = isolate(input$dates[2])
        
        marketData <- getSymbols(input$stockPicker,
                          from = inicio_periodo,
                          to = fin_periodo,
                          periodicity = "daily",
                          auto.assign = FALSE)
        
        df <- data.frame(Date=index(marketData), coredata(marketData))
        
        names(df) <- c('Date', 'Open', 'High', 'Low', 'Close', 'Volume', 'Adjusted')
        df
    })
    
    # INFO TAB
    output$distributionPlot <- renderPlotly({
        plot_ly(dataPositions, labels = ~dataPositions$Tickers, values = ~dataPositions$Shares, type = "pie")
    })
    
    output$performancePlot <- renderPlotly({
        ggplot(dataPositions, aes(x=Tickers, y=Gain...1)) +
            geom_bar(stat = "identity", fill = ifelse(dataPositions$Gain...1 > 0, "seagreen4", "orangered1"))+
            ylab('Gains')+
            theme(axis.text.x = element_text(angle=80, vjust = 0.5))
    })
    
    # STOCK TAB
    output$stockName <- renderText({
        ps <- getStockPortfolioData()
        
        M <- unlist(ps['TickerName'])
        M
    })
    
    output$stockId <- renderText({
        paste('(', input$stockPicker, ')')
    })
    
    output$stockPrice <- renderUI({
        stockMetrics <- getStockMetrics()
        
        arrowUrl <- "https://upload.wikimedia.org/wikipedia/commons/b/b0/Down_red_arrow.png"
        
        if (stockMetrics['Last'] > stockMetrics['Open']) {
            arrowUrl <- "https://upload.wikimedia.org/wikipedia/commons/3/36/Up_green_arrow.png"
        }
        
        tags$div(
            stockMetrics['Last'],
            tags$img(src = arrowUrl, width = "30px", height = "30px")
        )
    })
    
    output$stockPrices <- renderUI({
        stockMetrics <- getStockMetrics()
        
        tags$table(
            tags$tr(
                tags$th("Open"),
                tags$th("Close"),
                tags$th("High"),
                tags$th("Low")
            ),
            tags$tr(
                tags$td(stockMetrics['Open']),
                tags$td(stockMetrics['Last']),
                tags$td(stockMetrics['High']),
                tags$td(stockMetrics['Low'])
            )
        )
    })
    
    output$portfolioStockDataHtml <- renderUI({
        ps <- getStockPortfolioData()
        
        tags$table(
            tags$tr(
                tags$th("Shares Owned:"),
                tags$td(ps['Shares'])
            ),
            tags$tr(
                tags$th("Total Cost:"),
                tags$td(paste(ps['Cost'], '$'))
            ),
            tags$tr(
                tags$th("Total Value:"),
                tags$td(paste(ps['Value'], '$'))
            ),
            tags$tr(
                tags$th("Total Gain:"),
                tags$td(paste(ps['Gain...1'], '$'))
            )
        )
    })
    
    output$stockMarketPlot <- renderPlotly({
        df <- getStockMarketData()
        
        fig <- df %>% plot_ly(x = ~Date, type="candlestick",
                              open = ~Open, close = ~Close,
                              high = ~High, low = ~Low)
        
        fig <- fig %>% layout(xaxis = list(rangeslider = list(visible = F)))
        fig
    })
    
    output$stockTransactionsTable <- renderDataTable({
        getStockTransactionsData()
    })
})