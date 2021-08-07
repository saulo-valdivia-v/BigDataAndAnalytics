#Ahora utilizaremos los datos calculados de RFM para realizar un modelo que permita detectar los grupos de compradores
#de acuerdo a sus comportamientos de compra:

install.packages("caret")
install.packages("readxl")

library(readxl)
library(dplyr)
library(caret)

#cargamos el archivo dataset, limpiamos y calculamos RFM
dataset_RFM <- read_excel("dataset_RFM.xlsx") %>%
  rename(customer_id = V1, gross_compra = V2, fecha_compra = V3) %>%
  mutate(fecha_compra = as.Date(fecha_compra, "%Y-%m-%d")) #dara warnings de time zone

Calculo_RFM <- dataset_RFM %>% 
  group_by(customer_id) %>%
  summarise(Recency=as.numeric(as.Date(Sys.Date())-max(fecha_compra)),
            Frequency=length(customer_id), 
            Monetary_Value= sum(gross_compra)) 

#VAMOS A REALIZAR UNA SEGMENTACION DE LOS USUARIOS ASUMIENDO LAS SIGUIENTES CONDICIONES:
#Los usuarios se clasifican de acuerdo a los quantiles en los que se encuentran a nivel de recency y frequency
#El scoring se realiza de 1 a 5, siendo 1 quantil 0.2, 2 es cuantil 0.4, 3 es cuantil 0.6, 4 es cuantil 0.8 y 5 es quantil 1


#Realizamos el scoring agregando las columnas a nuestro dataset general
Calculo_RFM$ScoreRecency <- NA
Calculo_RFM$ScoreFrequency <- NA
Calculo_RFM$ScoreMV <- NA

Calculo_RFM$ScoreRecency[Calculo_RFM$Recency <= quantile(Calculo_RFM$Recency,0.20)]<-1
Calculo_RFM$ScoreRecency[Calculo_RFM$Recency <= quantile(Calculo_RFM$Recency,0.40) & Calculo_RFM$Recency > quantile(Calculo_RFM$Recency,0.20)]<-2
Calculo_RFM$ScoreRecency[Calculo_RFM$Recency <= quantile(Calculo_RFM$Recency,0.60) & Calculo_RFM$Recency > quantile(Calculo_RFM$Recency,0.40)]<-3
Calculo_RFM$ScoreRecency[Calculo_RFM$Recency <= quantile(Calculo_RFM$Recency,0.80) & Calculo_RFM$Recency > quantile(Calculo_RFM$Recency,0.60)]<-4
Calculo_RFM$ScoreRecency[Calculo_RFM$Recency >= quantile(Calculo_RFM$Recency,0.80)]<-5

#confirmamos que es correcto
table(Calculo_RFM$ScoreRecency)


Calculo_RFM$ScoreFrequency[Calculo_RFM$Frequency <= quantile(Calculo_RFM$Frequency,0.20)]<-1
Calculo_RFM$ScoreFrequency[Calculo_RFM$Frequency > quantile(Calculo_RFM$Frequency,0.20) & Calculo_RFM$Frequency <= quantile(Calculo_RFM$Frequency,0.40)]<-2
Calculo_RFM$ScoreFrequency[Calculo_RFM$Frequency <= quantile(Calculo_RFM$Frequency,0.60) & Calculo_RFM$Frequency > quantile(Calculo_RFM$Frequency,0.40)]<-3
Calculo_RFM$ScoreFrequency[Calculo_RFM$Frequency <= quantile(Calculo_RFM$Frequency,0.80) & Calculo_RFM$Frequency > quantile(Calculo_RFM$Frequency,0.60)]<-4
Calculo_RFM$ScoreFrequency[Calculo_RFM$Frequency >= quantile(Calculo_RFM$Frequency,0.80)]<-5

#confirmamos que es correcto
table(Calculo_RFM$ScoreFrequency)


Calculo_RFM$ScoreMV[Calculo_RFM$Monetary_Value <= quantile(Calculo_RFM$Monetary_Value,0.20)]<-1
Calculo_RFM$ScoreMV[Calculo_RFM$Monetary_Value <= quantile(Calculo_RFM$Monetary_Value,0.40) & Calculo_RFM$Monetary_Value >= quantile(Calculo_RFM$Monetary_Value,0.20)]<-2
Calculo_RFM$ScoreMV[Calculo_RFM$Monetary_Value <= quantile(Calculo_RFM$Monetary_Value,0.60) & Calculo_RFM$Monetary_Value >= quantile(Calculo_RFM$Monetary_Value,0.40)]<-3
Calculo_RFM$ScoreMV[Calculo_RFM$Monetary_Value <= quantile(Calculo_RFM$Monetary_Value,0.80) & Calculo_RFM$Monetary_Value >= quantile(Calculo_RFM$Monetary_Value,0.60)]<-4
Calculo_RFM$ScoreMV[Calculo_RFM$Monetary_Value >= quantile(Calculo_RFM$Monetary_Value,0.80)]<-5

#confirmamos que es correcto
table(Calculo_RFM$ScoreMV)

#Scoring final sumando los anteriores
Calculo_RFM$ScoreRFM <- rowSums (Calculo_RFM[ , c(5:6,7)])


#Asignamos un segmento de consumidor de acuerdo a su score
Calculo_RFM$segmento <- NA
Calculo_RFM$segmento[which(Calculo_RFM$ScoreRFM < 4)] = "inactivo"
Calculo_RFM$segmento[which(Calculo_RFM$ScoreRFM >= 4 & Calculo_RFM$ScoreRFM < 7)] = "en riesgo"
Calculo_RFM$segmento[which(Calculo_RFM$ScoreRFM >= 7 & Calculo_RFM$ScoreRFM < 10)] = "potenciales"
Calculo_RFM$segmento[which(Calculo_RFM$ScoreRFM >= 10 & Calculo_RFM$ScoreRFM < 13)] = "leales"
Calculo_RFM$segmento[which(Calculo_RFM$ScoreRFM >= 13)] = "champions"

#confirmamos que es correcto
table(Calculo_RFM$segmento)

#### Consultas
#¿Cuántos consumidores existen para cada segmento identificado?
#¿Cuál es el porcentaje de usuarios champions? Pista: utilizamos prop.table para obtener las frecuencias relativas

#Practiquen RFM con los consumidores del 2019 y con los de 2018



##### SEGMENTAR EMPLEANDO ALGORITMOS DE CLUSTERING
# Volvemos a calcular un segundo data frame de RFM, del 2019

Calculo_RFM2 <- dataset_RFM %>% 
  mutate(as.Date(fecha_compra, "%Y-%m-%d")) %>%
  filter(fecha_compra > "2019-01-01") %>%
  group_by(customer_id) %>%
  summarise(Recency=as.numeric(as.Date(Sys.Date())-max(fecha_compra)),
            Frequency=length(customer_id), 
            Monetary_Value= sum(gross_compra)) 



#Utilizamos el algoritmo k-means para clusterizar y generar 5 clusters de consumidores
#k-means es un algoritmo no supervisado porque no le proporciono reglas (etiquetas), sino que identifica
#patrones y agrupa los datos según la cantidad de cluster/grupos que le indico
#aprenderán más sobre los algoritmos de clustering en segundo cuatrimestre
set.seed(1234) #se puede colocar un número random, es para asegurar que sea reproducible y se obtengan los mismos resultados siempre
SegmentacionRFM <- kmeans(scale(Calculo_RFM2[,2:4]), 5, nstart = 1) 

#Una vez que corre se genera una lista de 9 conjuntos de datos, que fusiono con el RFM original
Calculo_RFM2$ScoreRFM <- as.factor(SegmentacionRFM$cluster)

table(Calculo_RFM2$ScoreRFM) #comparen con la tabla de frecuencias del ejercicio manual sobre 2019

#Traducimos el score numérico a un naming relevante para los equipos de marketing
Calculo_RFM2$NSegmento <- NA
Calculo_RFM2$Segmento[Calculo_RFM2$ScoreRFM == 1] <- "inactivo"
Calculo_RFM2$Segmento[Calculo_RFM2$ScoreRFM == 2] <- "en riesgo"
Calculo_RFM2$Segmento[Calculo_RFM2$ScoreRFM == 3] <- "potenciales"
Calculo_RFM2$Segmento[Calculo_RFM2$ScoreRFM  == 4] <- "leales"
Calculo_RFM2$Segmento[Calculo_RFM2$ScoreRFM == 5] <- "champions"

#inspeccionamos la distribucion
table(Calculo_RFM2$Segmento)
prop.table(table(Calculo_RFM2$Segmento))

####Qué diferencias encontramos con la forma "manual" de quantiles?
#¿Creen que hemos empleado correctamente la logica del nombre del segmento?

###### EJERCICIOS
#Pueden practicar con los datos enteros del dataset, sin filtro 2019, y además probando diferentes cantidades de
#cluster, se recomienda como minimo 3.
