#https://plotly.com/r/candlestick-charts/

library(quantmod) 
library(plotly)
library(dplyr)

AAPL <- getSymbols("AAPL",
                   from = "2016/12/31",
                   to = "2018/12/31",
                   periodicity = "daily",
                   auto.assign = FALSE)

AAPL[1, "Open"]

names(AAPL)[names(AAPL) == "AAPL.Open"] <- "Open"

select(AAPL, AAPL.Open, AAPL.Close, AAPL.Volume)
AAPL[1,c("AAPL.Open","AAPL.Close","AAPL.High", "AAPL.Low")]

myStocks <-lapply(c("AAPL", "GOOG"), function(x) {getSymbols(x, 
                                                             from = "2016/12/31", 
                                                             to = "2018/12/31",
                                                             periodicity = "monthly",
                                                             auto.assign=FALSE)} )
names(myStocks) <- c("AAPL", "GOOG")

head(myStocks$AAPL)
head(myStocks$GOOG)

index(myStocks$AAPL)
coredata(myStocks$AAPL)

df <- data.frame(Date=index(myStocks$AAPL), coredata(myStocks$AAPL))

df <- tail(df, 30)

fig <- df %>% plot_ly(x = ~Date, type="candlestick",
                      open = ~AAPL.Open, close = ~AAPL.Close,
                      high = ~AAPL.High, low = ~AAPL.Low)

fig <- fig %>% layout(title = "Basic Candlestick Chart",
                      xaxis = list(rangeslider = list(visible = F)))

fig

AMD <- getSymbols("INTC",
                   from = "2016/12/31",
                   to = "2018/12/31",
                   periodicity = "daily",
                   auto.assign = FALSE)
index(AMD)

df <- data.frame(Date=index(AMD), coredata(AMD))
df

names(df) <- c('Date', 'Open', 'High', 'Low', 'Close', 'Volume', 'Adjusted')

fig <- df %>% plot_ly(x = ~Date, type="candlestick",
                      open = ~Open, close = ~Close,
                      high = ~High, low = ~Low)

fig <- fig %>% layout(title = "Basic Candlestick Chart",
                      xaxis = list(rangeslider = list(visible = F)))

fig


ts <- read.csv("~/DataScience/EAE/Visualization2/Clase1/StockTest1/data/Transactions.csv")

head(ts)

ts <- ts %>% dplyr::filter(Security == 'AMD')
ts
