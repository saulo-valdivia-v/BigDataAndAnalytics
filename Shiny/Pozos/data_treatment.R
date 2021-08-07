library(tidyverse)
library(FinCal)
library(dplyr)
library(readxl)
library(shiny)
library(shinydashboard)
library(tidyverse)
library(shinycssloaders)
library(shinyWidgets)
library(ggplot2)
library(plotly)
library(dplyr)
library(DT)




tilde = read_excel("Modeloprod.xlsx")
x <- length(tilde$Meses)
peri <- seq(as.Date("2020-01-01"), by = "month", length = x)
tilde$Mes <- format(peri, "%b-%Y")
tilde$Anio <- format(peri, "%Y")
names(tilde)[names(tilde) == 'Produccion Oil'] <- 'Oil'
names(tilde)[names(tilde) == 'Produccion Gas'] <- 'Ivy'
#names(tilde)
tilde$Anio <- as.character(tilde$Anio)

# Primer calculo para Oil y Ivy
tilde$calc_oil <- tilde$Oil*30.4166666666667/1000
tilde$calc_ivy <- tilde$Ivy*30.4166666666667/1000

# Se realiza el acumulado y se redondea sin cifras decimales
tilde$oil_acc <- round(cumsum(tilde$calc_oil), 0)
tilde$ivy_acc <- round(cumsum(tilde$calc_ivy), 0)

# Se genera el df para la curva de tildeuccion hasta fin de 2021
curva_cf <- data.frame(Anio = tilde$Mes)
curva_cf$Oil <- tilde$Oil*365/12
curva_cf$Gas <- round(tilde$Ivy*365/12, 0)
curva_cf <- curva_cf[c(1:24),]

# Se genera el dataframe de tildeuccion por aÃÂ±o
anual <- tilde %>%
  select(Anio, Oil, Ivy) %>%
  group_by(Anio) %>%
  summarise_all(sum)

# Se cambia el nombre de la columna Ivy
names(anual)[names(anual) == "Ivy"] <- "Gas"

# Se calcula el gasto mensual para Oil y Gas y se redondea sin cifras decimales
anual$Oil <- round(anual$Oil*365/12, 0)
anual$Gas <- round(anual$Gas*365/12, 0)


# Se unifican los dos df y se crea la columna LPG a 0
curva_cf <- rbind(curva_cf, anual)
curva_cf$LPG <- 0

# Se convierten los valores de las columas a numerico
curva_cf$Oil <- as.numeric(curva_cf$Oil)
curva_cf$Gas <- as.numeric(curva_cf$Gas)
curva_cf$LPG <- as.numeric(curva_cf$LPG)