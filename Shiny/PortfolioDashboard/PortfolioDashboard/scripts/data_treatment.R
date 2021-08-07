dataPositions <- read.csv("data/Positions.csv")

dataPositions['Gain...1'] <- round(dataPositions['Gain...1'], 2)

dataTransactions <- read.csv("data/Transactions.csv")
dataTransactions$Date <- as.Date(dataTransactions$Date, "%m/%d/%Y")
Transactions <- read.csv('data/Transactions.csv') %>% mutate(Total=as.numeric(Total))

Transactions <- as.data.frame(Transactions)

Total_Cost <- Transactions %>%
  summarise( res = sum(Total))

Shared_Owned <- Transactions %>%
  summarise( res1 = sum(Quantity))

Positions <- read.csv('data/Positions.csv')
str(Positions)
Gains <- Positions %>%
  summarise( res3 = sum(Gain...1))

Account_value <- round(sum(Total_Cost,Gains),2) 


Total_Cost <- format(round(as.numeric(Total_Cost), 2), nsmall=1, big.mark=",")
Account_value <- format(round(as.numeric(Account_value), 2), nsmall=1, big.mark=",")
Gains <- format(round(as.numeric(Gains), 1), nsmall=1, big.mark=",")