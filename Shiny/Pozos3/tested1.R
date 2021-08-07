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

# Se genera el dataframe de tildeuccion por aÃ±o
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

lifting_cost_MMBTU <- 0.5
lifting_cost_BOE <- lifting_cost_MMBTU*6
capex <- 5

# Se genera el df cash donde estara representada toda la informacion economica del modelo
cash <- data.frame(Anio = curva_cf$Anio,
                   OPEX_MMBTU = lifting_cost_MMBTU*-curva_cf$Gas/1000/27.1,
                   OPEX_BOE = -lifting_cost_BOE*(curva_cf$Gas/0.159+curva_cf$Oil*6.29)/1000000,
                   CAPEX_MMBTU = 0,
                   CAPEX_BOE = 0)

# Manualmente se cambian los valores de enero y febrero de los dos capex a traves de la siguiente formula
cash$CAPEX_MMBTU[cash$Anio == 'Jan-2020'] = -capex/2
cash$CAPEX_MMBTU[cash$Anio == 'Feb-2020'] = -capex/2
cash$CAPEX_BOE[cash$Anio == 'Jan-2020'] = -capex/2
cash$CAPEX_BOE[cash$Anio == 'Feb-2020'] = -capex/2

seq1 <- seq(as.Date("2020-01-01"), by = "month", length = 24)
mes_ano <- data.frame('Tiempo' = seq1,
                      "Oil" = 53.78 ,
                      "Gas" = 3,
                      "LPG" = 0
)
seq1_years <- seq(seq1[24]+31, by = "year", length.out = 17)
ano <- data.frame("Tiempo" = seq1_years,
                  "Oil" = 53.78 ,
                  "Gas" = 3,
                  "LPG" = 0
)

prix <- rbind(mes_ano, ano)

s <- prix$Tiempo[1:24]

l <- prix$Tiempo[25:41]
prix$Anio[25:41]<- format(l, "%Y")
prix$Anio[1:24] <- format(s, "%b-%Y")


precios <- prix

ventas <- data.frame(Anio = precios$Anio,
                     Oil = curva_cf$Oil*6.29*precios$Oil/1000000,
                     Gas = curva_cf$Gas/1000/27.1*precios$Gas,
                     LPG = precios$LPG*curva_cf$LPG/1000000)

# # Se realiza la suma de las ventas de Oil, Gas y LPG y se genera una columa en el df cash con el resultado
for(i in  1:nrow(ventas)){
  
  cash$Ventas[i] <- ventas$Oil[i] + ventas$Gas[i] + ventas$LPG[i] 
  
}


# # Valores para regalias e IIBB de Oil y Gas
regalias <- 0.15
IIBB_Oil <- 0.022
IIBB_Gas <- 0.022

# Calculo de las columnas de regalias e IIBB
cash$regalias <- -cash$Ventas*regalias
cash$IIBB <- -ventas$Oil*IIBB_Oil-ventas$Gas*IIBB_Gas

# Valor para ITF
ITF <- 1

# Calculo de la columna ITF
cash$ITF <- cash$Ventas*-1*0.006*ITF+cash$OPEX_MMBTU[i]*0.006+cash$CAPEX_MMBTU*0.006+cash$IIBB*0.006+cash$regalias*0.006


#### Amortizaciones ####

# Se calcula el parametro de produccion
produccion_parametro <- (sum(curva_cf$Oil)*6.29+sum(curva_cf$Gas)*35.315/6)/1000000

# Se generan dos df de amortizaciones para posteriormente unificarnos ya que se facilitan los calculos de esta 
# manera


amortizaciones_1 <- data.frame(Anio = curva_cf$Anio,
                               capex_MMBTU = cash$CAPEX_MMBTU/sum(cash$CAPEX_MMBTU),
                               capex_BOE = cash$CAPEX_BOE/sum(cash$CAPEX_BOE))
amortizaciones_2 <- data.frame(Anio = curva_cf$Anio,
                               Produccion = -(curva_cf$Oil*6.29+curva_cf$Gas*35.315/6)/1000000,
                               Apropiacion = 0,
                               SI = 0,
                               SF = 0)

# Se cambian manualmente los valores de enero y febrero del segundo df a traves de la siguiente formula
amortizaciones_2$Apropiacion[amortizaciones_2$Anio == 'Jan-2020'] = produccion_parametro/2
amortizaciones_2$Apropiacion[amortizaciones_2$Anio == 'Feb-2020'] = produccion_parametro/2
# 
# # Se elimina la columna Anio
amortizaciones_2$Anio <- NULL
# 
# # A traves del siguiente bucle for generamos las columnas SF y SI que dependen la una de la otra
# #ERRROR AQUIIIIIIIIIIIIIIIIIIIIIIII!!!!!!!!!!!!
for(i in  1:nrow(amortizaciones_2)){
  
  amortizaciones_2$SF[i] <- amortizaciones_2$Produccion[i] + amortizaciones_2$Apropiacion[i] + amortizaciones_2$SI[i] 
  if(i + 1 <= nrow(amortizaciones_2) ){
    amortizaciones_2$SI[i + 1] <- amortizaciones_2$SF[i] 
  }
  
}
# 
# # Se unifican los dos df
amortizaciones <- cbind(amortizaciones_1, amortizaciones_2)
# 
# # Se genera la nueva columna Alicuota
amortizaciones$Alicuota <- -amortizaciones$Produccion/(amortizaciones$SI + amortizaciones$Apropiacion)
# 
# # Se genera el parametro SI_BU que es igual a 0
SI_BU <- 0 
# 
# # Se calculan los valores para las columnas DDyA y SI_2 para enero de 2020
amortizaciones$DDyA[amortizaciones$Anio == "Jan-2020"] <- (SI_BU-cash$CAPEX_MMBTU[cash$Anio == "Jan-2020"]/1.5)*amortizaciones$Alicuota[amortizaciones$Anio == "Jan-2020"]
amortizaciones$SI_2[amortizaciones$Anio == "Jan-2020"] <- SI_BU-cash$CAPEX_MMBTU[cash$Anio == "Jan-2020"]-amortizaciones$DDyA[amortizaciones$Anio == "Jan-2020"]
# 
# # Se calculan las columnas de DDyA y SI_2 a traves del siguiente bucle condicionado
for(i in 1:nrow(amortizaciones)){
  #   
  if(sum(amortizaciones$Produccion[i]:amortizaciones$Produccion[nrow(amortizaciones)]) == 0){
    if(i + 1 <= nrow(amortizaciones) ){
      amortizaciones$DDyA[i+1] <- (amortizaciones$SI_2[i]-cash$CAPEX_MMBTU[i+1])*amortizaciones$Alicuota[i+1] 
    }
  }
  else{
    if(i + 1 <= nrow(amortizaciones) ){
      amortizaciones$DDyA[i+1] <- (amortizaciones$SI_2[i]-cash$CAPEX_MMBTU[i+1]/1.5)*amortizaciones$Alicuota[i+1]
    }
  }
  # ####ERROR AQUI!!!!!!!!!!!!!!!!!!!!!!!!!!!!  
  if(i + 1 <= nrow(amortizaciones) ){
    amortizaciones$SI_2[i+1] <- amortizaciones$SI_2[i]-cash$CAPEX_MMBTU[i+1]-amortizaciones$DDyA[i+1]
  }
  
}

# Calculo del EBIT con el siguiente bucle
#WARNING!!!!!!!!!!!!!!!!
for(i in 1:nrow(amortizaciones)){
  
  amortizaciones$EBIT[i] <- cash$Ventas[i]+cash$OPEX_MMBTU[i]+cash$regalias[i]+cash$IIBB+cash$ITF[i]
  
}

# Calculo de base del IIGG con el siguiente bucle
for(i in 1:nrow(amortizaciones)){
  
  amortizaciones$base_IIGG[i] <- amortizaciones$EBIT[i] - amortizaciones$DDyA[i]
  
}

# Se iguala el valor de enero 2020 de base IIGG Queb a base IIGG
amortizaciones$base_IIGG_Queb[amortizaciones$Anio == "Jan-2020"] <- amortizaciones$base_IIGG[amortizaciones$Anio == "Jan-2020"]

# Calculo del resto de valores de base IIGG Queb
#ERROR AQUI!!!!!!!!!!!
for(i in 1:nrow(amortizaciones)){
  
  if(amortizaciones$base_IIGG_Queb[i] < 0){
    if(i+1 <= nrow(amortizaciones)){
      amortizaciones$base_IIGG_Queb[i+1] <- amortizaciones$base_IIGG_Queb[i] + amortizaciones$base_IIGG[i+1] 
    }
  }
  else{
    if(i+1 <= nrow(amortizaciones)){
      amortizaciones$base_IIGG_Queb[i+1] <- amortizaciones$base_IIGG[i+1]
    }
  }
  
}


#### CALCULO PAY OUT ####

# Calculo del FF pre IIGG
for(i in 1:nrow(cash)){
  
  cash$FF_preIIGG[i] <- cash$OPEX_MMBTU[i] + cash$CAPEX_MMBTU[i] + cash$Ventas[i] + cash$regalias[i] + cash$IIBB[i] + cash$ITF[i]
  
}

# IIGG para el aÃ±o 2020
IIGG_2020 <- 0.21

for(i in 1:nrow(cash)){
  
  if(-amortizaciones$base_IIGG_Queb[i]*IIGG_2020 > 0){
    cash$IIGG[i] <- 0
  }
  else{
    cash$IIGG[i] <- -amortizaciones$base_IIGG_Queb[i]*IIGG_2020
  }
  
}

# Calculo de FF
for(i in 1:nrow(cash)){
  
  cash$FF[i] <- cash$FF_preIIGG[i] + cash$IIGG[i]
  
}

# Creacion del df pay out
pay_out <- data.frame(Anio = curva_cf$Anio)
pay_out$FF_acum[1] <- cash$FF[1]

# FF acumulado
#ERROR AQUI!!!!!!!!!!!!!!!!!!!!!!
for(i in 1:nrow(cash)){
  if(i+1 <= nrow(cash)){
    pay_out$FF_acum[i+1] <- pay_out$FF_acum[i] + cash$FF[i+1]
  }
}

# Valor Y para el calculo de Anios
for(i in 1:nrow(cash)){
  
  if(i <= 3){
    cash$Y[i] <- 0
  }
  else{
    cash$Y[i] <- cash$FF[i]
  }
  
}

# # Calculo de la columna Anios
# for(i in 1:nrow(pay_out)){
#   if(!is.na(pay_out$FF_acum[i+1])){
#     if(pay_out$FF_acum[i+1]<0){
#       pay_out$Anios[i+1] <- 1/12
#     }
#     else{
#       if(pay_out$FF_acum[i]>0){
#         pay_out$Anios[i+1] <- 0
#       }
#       else{
#         pay_out$Anios[i+1] <- -pay_out$Anios[i]/cash$Y[i+1]*(1/12)
#       }
#     }
#   }
# }

pay_out$FF_acum <- round(pay_out$FF_acum,2)
# pay_out$Anios[1] <- 0
# 
# 
# #### Calculo del VAN, TIR, IA, VAN/IA y valor del pay out#####
# 
# # Se cambia la columna Anio del df cash a formato fecha
# fechas_1 <- seq.Date(as.Date("01-01-2020", "%d-%m-%Y"), as.Date("01-12-2021", "%d-%m-%Y"), "month")
# fechas_2 <- seq.Date(as.Date("01-01-2022", "%d-%m-%Y"), as.Date("01-12-2036", "%d-%m-%Y"), "year")
# fechas <- c(fechas_1, fechas_2)

#verificar
#cash$Anio <- fechas[0:41]ash$Anio <- fechas]

#pay_out_value <- sum(pay_out$Anios)

#cash$Anio <- fechas

# Se calcula todo con la siguiente tasa de descuento
tasa_desc <- 0.15

VAN <- npv(r = tasa_desc, cash$FF)
TIR <- irr(cash$FF)*100

IA <- npv(r= tasa_desc, cash$CAPEX_MMBTU)*-1
VAN_IA <- VAN/IA
pay_out_value <- sum(pay_out$Anios)

#cash$FF

#irr(cash$FF)*100
