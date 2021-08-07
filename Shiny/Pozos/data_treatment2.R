library(tidyverse)
library(FinCal)
library(dplyr)
#### HOJA PROD ####

# Se importa el csv que contiene la tabla de produccion de oil e ivy y calculo el acumulado.

prod = read.csv('Prod.csv', sep = ';')

# Se cambia en nombre de la primera columna y se pasa a character
names(prod)[names(prod) == "ï..Anio"] <- "Anio"  #TILDEEEEEEEEEEEEEEEEEEEE
prod$Anio <- as.character(prod$Anio)

# Primer calculo para Oil y Ivy
prod$calc_oil <- prod$Oil*30.4166666666667/1000
prod$calc_ivy <- prod$Ivy*30.4166666666667/1000

# Se realiza el acumulado y se redondea sin cifras decimales
prod$oil_acc <- round(cumsum(prod$calc_oil), 0)
prod$ivy_acc <- round(cumsum(prod$calc_ivy), 0)

# Se genera el df para la curva de produccion hasta fin de 2021
curva_cf <- data.frame(Anio = prod$Mes)
curva_cf$Oil <- prod$Oil*365/12
curva_cf$Gas <- round(prod$Ivy*365/12, 0)
curva_cf <- curva_cf[-c(23:446),]

# Se genera el dataframe de produccion por aÃ±o
anual <- prod %>%
  select(Anio, Oil, Ivy) %>%
  group_by(Anio) %>%
  summarise_all(sum)

# Se cambia el nombre de la columna Ivy
names(anual)[names(anual) == "Ivy"] <- "Gas"

# Se calcula el gasto mensual para Oil y Gas y se redondea sin cifras decimales
anual$Oil <- round(anual$Oil*365/12, 0)
anual$Gas <- round(anual$Gas*365/12, 0)

# Eliminadas las dos primeras filas
anual <- anual[-c(1:2),]

# Se unifican los dos df y se crea la columna LPG a 0
curva_cf <- rbind(curva_cf, anual)
curva_cf$LPG <- 0

# Manualmente se introducen los valores para enero y febreo de 2020
curva_cf <- rbind(c("feb-20", 0, 0, 0), curva_cf)
curva_cf <- rbind(c("ene-20", 0, 0, 0), curva_cf)

# Se convierten los valores de las columas a numerico
curva_cf$Oil <- as.numeric(curva_cf$Oil)
curva_cf$Gas <- as.numeric(curva_cf$Gas)
curva_cf$LPG <- as.numeric(curva_cf$LPG)

#### OPEX Y CAPEX ####

# Se generan los valores del lifting cost MMBTU y BOE y el valor para el capex
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
cash$CAPEX_MMBTU[cash$Anio == 'ene-20'] = -capex/2
cash$CAPEX_MMBTU[cash$Anio == 'feb-20'] = -capex/2
cash$CAPEX_BOE[cash$Anio == 'ene-20'] = -capex/2
cash$CAPEX_BOE[cash$Anio == 'feb-20'] = -capex/2


#### Ventas ####

# Se carga el csv con los precios de Oil, Gas y LPG
precios = read.csv('Precios.csv', sep = ';')

# Se cambia el nombre a la primera columa  #TILDEEEEEEEEEEEEEEEEEEEEEEEEEEE
#precios$ï..mes
names(precios)[names(precios) == "ï..mes"] <- "Anio"

# Se crea el df ventas a traves de los siguientes calculos
ventas <- data.frame(Anio = precios$Anio,
                     Oil = curva_cf$Oil*6.29*precios$Oil/1000000,
                     Gas = curva_cf$Gas/1000/27.1*precios$Gas,
                     LPG = precios$LPG*curva_cf$LPG/1000000)


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
                               ApropiaciÃ³n = 0,
                               SI = 0,
                               SF = 0)

# Se cambian manualmente los valores de enero y febrero del segundo df a traves de la siguiente formula
amortizaciones_2$ApropiaciÃ³n[amortizaciones_2$Anio == 'ene-20'] = produccion_parametro/2
amortizaciones_2$ApropiaciÃ³n[amortizaciones_2$Anio == 'feb-20'] = produccion_parametro/2
# 
# # Se elimina la columna Anio
amortizaciones_2$Anio <- NULL
# 
# # A traves del siguiente bucle for generamos las columnas SF y SI que dependen la una de la otra
# #ERRROR AQUIIIIIIIIIIIIIIIIIIIIIIII!!!!!!!!!!!!
for(i in  1:nrow(amortizaciones_2)){
  
  amortizaciones_2$SF[i] <- amortizaciones_2$Produccion[i] + amortizaciones_2$ApropiaciÃ³n[i] + amortizaciones_2$SI[i] 
  amortizaciones_2$SI[i + 1] <- amortizaciones_2$SF[i]
  
}
# 
# # Se unifican los dos df
amortizaciones <- cbind(amortizaciones_1, amortizaciones_2)
# 
# # Se genera la nueva columna Alicuota
amortizaciones$Alicuota <- -amortizaciones$Produccion/(amortizaciones$SI + amortizaciones$ApropiaciÃ³n)
# 
# # Se genera el parametro SI_BU que es igual a 0
SI_BU <- 0 
# 
# # Se calculan los valores para las columnas DDyA y SI_2 para enero de 2020
amortizaciones$DDyA[amortizaciones$Anio == "ene-20"] <- (SI_BU-cash$CAPEX_MMBTU[cash$Anio == "ene-20"]/1.5)*amortizaciones$Alicuota[amortizaciones$Anio == "ene-20"]
amortizaciones$SI_2[amortizaciones$Anio == "ene-20"] <- SI_BU-cash$CAPEX_MMBTU[cash$Anio == "ene-20"]-amortizaciones$DDyA[amortizaciones$Anio == "ene-20"]
# 
# # Se calculan las columnas de DDyA y SI_2 a traves del siguiente bucle condicionado
for(i in 1:nrow(amortizaciones)){
  #   
  if(sum(amortizaciones$Produccion[i]:amortizaciones$Produccion[nrow(amortizaciones)]) == 0){
    amortizaciones$DDyA[i+1] <- (amortizaciones$SI_2[i]-cash$CAPEX_MMBTU[i+1])*amortizaciones$Alicuota[i+1]
  }
  else{
    amortizaciones$DDyA[i+1] <- (amortizaciones$SI_2[i]-cash$CAPEX_MMBTU[i+1]/1.5)*amortizaciones$Alicuota[i+1]
  }
  # ####ERROR AQUI!!!!!!!!!!!!!!!!!!!!!!!!!!!!  
  amortizaciones$SI_2[i+1] <- amortizaciones$SI_2[i]-cash$CAPEX_MMBTU[i+1]-amortizaciones$DDyA[i+1]
  
}
# 
# # Se realiza la suma de las ventas de Oil, Gas y LPG y se genera una columa en el df cash con el resultado
for(i in  1:nrow(ventas)){
  
  cash$Ventas[i] <- ventas$Oil[i] + ventas$Gas[i] + ventas$LPG[i] 
  
}
# 
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
amortizaciones$base_IIGG_Queb[amortizaciones$Anio == "ene-20"] <- amortizaciones$base_IIGG[amortizaciones$Anio == "ene-20"]

# Calculo del resto de valores de base IIGG Queb
#ERROR AQUI!!!!!!!!!!!
for(i in 1:nrow(amortizaciones)){
  
  if(amortizaciones$base_IIGG_Queb[i] < 0){
    amortizaciones$base_IIGG_Queb[i+1] <- amortizaciones$base_IIGG_Queb[i] + amortizaciones$base_IIGG[i+1]
  }
  else{
    amortizaciones$base_IIGG_Queb[i+1] <- amortizaciones$base_IIGG[i+1]
  }
  
}


#### AUXILIAR CAUDALES ####

# Creacion del df de auxiliar de caudales
aux_caudales <- data.frame(Anio = curva_cf$Anio,
                           Prod_Oil = curva_cf$Oil*6.29/1000,
                           QOil = curva_cf$Oil*6.29/(365.25/12),
                           Prod_Gas = curva_cf$Gas/1000)
aux_caudales$QGas <- aux_caudales$Prod_Gas/365.25*12



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
library(lubridate)
# Creacion del df pay out
pay_out <- data.frame(Anio = curva_cf$Anio)
#class(pay_out$Anio)
#xtt <- pay_out[0:1, 0:1]
#class(xtt)

#x1 <- "ene-20"
#x11 <- as.Date(x1, format(x1, format="%b-%y"))
#x2<- format(x1, format="%b-%y")
#class(x2)
#hoy <- Sys.Date()
#class(hoy)
#format(hoy, format="%b %y")

#navidad2019=as.Date("2019-12-25")
##pay_out_test1 <- as.Date(navidad_2019, "%Y %m %B")
p#ay_out_test
#pay_out$Anio <- as.Date(pay_out)
pay_out$FF_acum[1] <- cash$FF[1]

# FF acumulado
#ERROR AQUI!!!!!!!!!!!!!!!!!!!!!!
for(i in 1:nrow(cash)){
  
  pay_out$FF_acum[i+1] <- pay_out$FF_acum[i] + cash$FF[i+1]
  
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

# Calculo de la columna Anios
for(i in 1:nrow(pay_out)){
  
  if(pay_out$FF_acum[i+1]<0){
    pay_out$Anios[i+1] <- 1/12
  }
  else{
    if(pay_out$FF_acum[i]>0){
      pay_out$Anios[i+1] <- 0
    }
    else{
      pay_out$Anios[i+1] <- -pay_out$Anios[i]/cash$Y[i+1]*(1/12)
    }
  }
  
}
pay_out$FF_acum <- round(pay_out$FF_acum,2)
pay_out$Anios[1] <- 0


#### Calculo del VAN, TIR, IA, VAN/IA y valor del pay out#####

# Se cambia la columna Anio del df cash a formato fecha
fechas_1 <- seq.Date(as.Date("01-01-2020", "%d-%m-%Y"), as.Date("01-12-2021", "%d-%m-%Y"), "month")
fechas_2 <- seq.Date(as.Date("01-01-2022", "%d-%m-%Y"), as.Date("01-12-2057", "%d-%m-%Y"), "year")
fechas <- c(fechas_1, fechas_2)

#verificar
cash$Anio <- fechas[0:58]

# Se calcula todo con la siguiente tasa de descuento
#tasa_desc <- 0.15
#tasa_desc <- input$desc
#tasa_desc

#VAN <- npv(r = tasa_desc, cash$FF)
#TIR <- irr(cash$FF)*100

#IA <- npv(r= tasa_desc, cash$CAPEX_MMBTU)*-1
#VAN_IA <- VAN/IA
pay_out_value <- sum(pay_out$Anios)

#VAN
#TIR



