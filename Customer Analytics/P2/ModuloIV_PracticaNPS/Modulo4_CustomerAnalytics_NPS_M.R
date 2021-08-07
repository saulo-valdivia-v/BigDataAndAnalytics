#Practica Matricas de Satisfaccion del Consumidor - NPS
#NPS - Net Promoter Score - Score promedio de recomendacion
#En R existe una libreria llamada NPS para calcularlo automaticamente
#Deberán trabajar el calculo NPS sobre un dataset y analizar correlaciones con cluster de RFM


#PASO 1: Deben cargar las librerias tidyverse, lubridate, caret, corrplot y NPS

library(tidyverse)
library(lubridate)
library(caret)
library(NPS)



#PASO 2: Generen un dataset llamado ventas2020 cargando el archivo "NPS_T1.csv" eliminando primera columna
#Eliminen aquellos registros que figuren con un NPS NA utilizando filter
#Modifiquen la columna nps a columna numerica utilizando mutate y as.numeric
#Ayuda: al utilizar select si escriben select(-1) entonces se seleccionan todas las columnas excepto la primera

ventas2020 <- read.csv("NPS_T1.csv",header = TRUE, sep = ',')%>%
                         select(-1) %>% 
  filter(!is.na(nps))

mutate(ventas2020,as.numeric(nps))
str(ventas2020)
#comprobación que no existen NA
sapply(ventas2020, function(x) sum(is.na(x)))

  
#Calculen el NPS agrupado por cada tienda, utilizando la función nps del paquete NPS dentro de la funcion summarise
#¿cual es la tienda con mejor performance?
nps_tiendas <- ventas2020 %>%
  group_by(store) %>% 
  summarise(Resultado_NPS=nps(nps))
#la tienda 4 es la que presenta mejor NPS con un 19% aprox.

#Realizaremos un analisis entre los meses del año y el NPS para cada tienda
#para ello deben crear una columna mes en el dataframe de ventas2020 
#y agrupar tanto por mes como por store y calcular el nps en un nuevo data frame

mutate(ventas2020,as_date(fecha_compra))#cambiamos el tipo de la columna fecha_compra
mes<-month(ventas2020$fecha_compra)#aplicamos la funcion month para extraer el mes 
ventas2020['Mes']=mes #ahora creamos la columna mes con al variable mes

nps_tienda_mes<-ventas2020 %>%
  group_by(store,Mes) %>% 
  summarise(NPS=nps(nps))


#visualizamos la comparación de NPS de cada tienda para cada mes
#utilicen gráfico de scatter (geom_point) y den color a los puntos con
#columna store

library(ggplot2)

ggplot(nps_tienda_mes)+
  geom_point(aes(x=Mes,y=NPS,color=store))+
  xlim(0, 8)+
  ggtitle('Comparacion NPS de Tiendas por Mes')+
  theme_classic()

#Desarrollar el cálculo de RFM para cada comprador en otro dataframe 
#sin olvidar de modificar la columna de  fecha para que R la reconozca como tal utilizando as.Date

df_RFM<-ventas2020 %>% 
  select(id_member,fecha_compra,gasto)

df_RFM$fecha_compra <- as.Date(df_RFM$fecha_compra, "%Y-%m-%d")

str(df_RFM)

dim(df_RFM)

##### CALCULAMOS RFM #####
Calculo_RFM <- df_RFM %>% 
  group_by(id_member) %>%
  summarise(Recency=as.numeric(as.Date(Sys.Date())-max(fecha_compra)),
            Frequency=length(id_member), 
            Monetary_Value= sum(gasto))
dim(Calculo_RFM)

#APLICAMOS ESTADISTICA DESCRIPTIVA PARA COMPRENDER EL RESULTADO
range(Calculo_RFM$Monetary_Value)
mean(Calculo_RFM$Frequency)
mean(Calculo_RFM$Monetary_Value)
mean(Calculo_RFM$Recency)

median(Calculo_RFM$Frequency)
median(Calculo_RFM$Monetary_Value)
median(Calculo_RFM$Recency)


#Generen 5 clusters a traves de kmean para identificar segmentos de consumidores
#pueden utilizar de referencia el script visto en el modulo II

#VAMOS A REALIZAR UNA SEGMENTACION DE LOS USUARIOS ASUMIENDO LAS SIGUIENTES CONDICIONES:
#Los usuarios se clasifican de acuerdo a los quantiles en los que se encuentran a nivel de recency y frequency
#El scoring se realiza de 1 a 5, siendo 1 quantil 0.2, 2 es cuantil 0.4, 3 es cuantil 0.6, 4 es cuantil 0.8 y 5 es quantil 1

#CALCULO MANUAL Y CON K-MEANS

#Realizamos el scoring agregando las columnas a nuestro dataset general
Calculo_RFM$ScoreRecency <- NA
Calculo_RFM$ScoreFrequency <- NA
Calculo_RFM$ScoreMV <- NA

#CALCULO SCORES RECENCY
Calculo_RFM$ScoreRecency[Calculo_RFM$Recency <= quantile(Calculo_RFM$Recency,0.20)]<-1
Calculo_RFM$ScoreRecency[Calculo_RFM$Recency <= quantile(Calculo_RFM$Recency,0.40) & Calculo_RFM$Recency > quantile(Calculo_RFM$Recency,0.20)]<-2
Calculo_RFM$ScoreRecency[Calculo_RFM$Recency <= quantile(Calculo_RFM$Recency,0.60) & Calculo_RFM$Recency > quantile(Calculo_RFM$Recency,0.40)]<-3
Calculo_RFM$ScoreRecency[Calculo_RFM$Recency <= quantile(Calculo_RFM$Recency,0.80) & Calculo_RFM$Recency > quantile(Calculo_RFM$Recency,0.60)]<-4
Calculo_RFM$ScoreRecency[Calculo_RFM$Recency >= quantile(Calculo_RFM$Recency,0.80)]<-5

#confirmamos que es correcto
table(Calculo_RFM$ScoreRecency)

#CALCULO SCORES FRECUENCY
Calculo_RFM$ScoreFrequency[Calculo_RFM$Frequency <= quantile(Calculo_RFM$Frequency,0.20)]<-1
Calculo_RFM$ScoreFrequency[Calculo_RFM$Frequency > quantile(Calculo_RFM$Frequency,0.20) & Calculo_RFM$Frequency <= quantile(Calculo_RFM$Frequency,0.40)]<-2
Calculo_RFM$ScoreFrequency[Calculo_RFM$Frequency <= quantile(Calculo_RFM$Frequency,0.60) & Calculo_RFM$Frequency > quantile(Calculo_RFM$Frequency,0.40)]<-3
Calculo_RFM$ScoreFrequency[Calculo_RFM$Frequency <= quantile(Calculo_RFM$Frequency,0.80) & Calculo_RFM$Frequency > quantile(Calculo_RFM$Frequency,0.60)]<-4
Calculo_RFM$ScoreFrequency[Calculo_RFM$Frequency >= quantile(Calculo_RFM$Frequency,0.80)]<-5
#confirmamos que es correcto
table(Calculo_RFM$ScoreFrequency)

#CALCULO SCORES MONETARY VALUE
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
#porcentaje por segmantos de usuarios 
prop.table(table(Calculo_RFM$segmento))


#USANDO K-MEAN (algoritmo no supervisado)

?kmeans

Calculo_RFM2 <- df_RFM %>% 
  mutate(as.Date(fecha_compra, "%Y-%m-%d")) %>%
  group_by(id_member) %>%
  summarise(Recency=as.numeric(as.Date(Sys.Date())-max(fecha_compra)),
            Frequency=length(id_member), 
            Monetary_Value= sum(gasto))


set.seed(1234) #se puede colocar un número random, es para asegurar que sea reproducible y se obtengan los mismos resultados siempre
SegmentacionRFM <- kmeans(scale(Calculo_RFM2[,2:4]), 5, nstart = 1) 

#Una vez que corre se genera una lista de 9 conjuntos de datos, que fusiono con el RFM original
Calculo_RFM2$ScoreRFM <- as.factor(SegmentacionRFM$cluster)

table(Calculo_RFM2$ScoreRFM)

#Traducimos el score numérico a un naming relevante para los equipos de marketing
Calculo_RFM2$Segmento <- NA
Calculo_RFM2$Segmento[Calculo_RFM2$ScoreRFM == 1] <- "inactivo"
Calculo_RFM2$Segmento[Calculo_RFM2$ScoreRFM == 2] <- "en riesgo"
Calculo_RFM2$Segmento[Calculo_RFM2$ScoreRFM == 3] <- "potenciales"
Calculo_RFM2$Segmento[Calculo_RFM2$ScoreRFM  == 4] <- "leales"
Calculo_RFM2$Segmento[Calculo_RFM2$ScoreRFM == 5] <- "champions"

#inspeccionamos la distribucion
table(Calculo_RFM2$Segmento)#calculo kmeans
table(Calculo_RFM$segmento)#calculo manual
prop.table(table(Calculo_RFM2$Segmento))

# Para asignar los Segmentos en nuestros 5 cluster, crearemos un tabla con las medias de los 5 para 
# analizar y poder asignar el segmento adecuado.
tabla_cluster<-Calculo_RFM2 %>% 
  select(ScoreRFM,Recency,Frequency,Monetary_Value) %>% 
  group_by(ScoreRFM) %>%
  summarise(mean(Recency),
            mean(Frequency),
            mean(Monetary_Value))

#con esto correjimos lo anteriormente asignado

#cluster 1 Leal: segunda mejor frecuencia, tercero con mayor valor monetario y mejor recency
#Cluster 2 Champions: mayor valor monetario, mayor frecuencia compra y 3ro en recency
#cluster 3 Inactivo: pero valor monetario, peor frecuencia y segundo en recency
#cluster 4 Potencial; segundo mas alto en valor monetario, 2do pero en recency y tercero en mayor frecuencia
#cluster 5 En riesgo: segundo peor en valor monetario y frecuencia, mejor recency

Calculo_RFM2$Segmento[Calculo_RFM2$ScoreRFM == 1] <- "Leal"
Calculo_RFM2$Segmento[Calculo_RFM2$ScoreRFM == 2] <- "Champions"
Calculo_RFM2$Segmento[Calculo_RFM2$ScoreRFM == 3] <- "Inactivo"
Calculo_RFM2$Segmento[Calculo_RFM2$ScoreRFM  == 4] <- "Potencial"
Calculo_RFM2$Segmento[Calculo_RFM2$ScoreRFM == 5] <- "En Riesgo"

table(Calculo_RFM2$Segmento)#calculo kmeans
table(Calculo_RFM$segmento)#calculo manual


#las diferencias que vemos entre el calculo manual y el de cluster reflejan el sesgo que produce el calculo manual,
#al suponer rangos de puntajes y declarar segmentos, a diferencia del K-mean que calcula la distacias entre los puntos para
#su segmentacion

#Calcular nps agrupando por segmento de consumidores en un nuevo data frame

Nps_agrupado_por_segmento<-ventas2020 %>% 
  select(id_member,nps) %>% 
  group_by(id_member) %>% 
  summarise(Nps_agrupado=nps(nps))

Nps_agrupado_por_segmento['Segmento']=Calculo_RFM2$Segmento

str(Nps_agrupado_por_segmento)
#Ahora realicen una correlacion entre NPS y  los segmentos de consumidores de RFM
#Existen mayor correlacion con aquellos consumidores que gastan mas dinero o menos dinero?
Nps_agrupado_por_segmento['Score']=as.integer(Calculo_RFM2$ScoreRFM)

cor.test(Nps_agrupado_por_segmento$Nps_agrupado,Nps_agrupado_por_segmento$Score)
#la correlacion entre segmento y nps es ´positiva pero baja de tan solo un 5%
cor(Nps_agrupado_por_segmento$Nps_agrupado,Nps_agrupado_por_segmento$Score==2)
#la correlacion es negativa con los clientes que compran más de un 7%
library(ggplot2)

ggplot(Nps_agrupado_por_segmento)+
  geom_point(aes(x=Score,y=Nps_agrupado,color=Segmento))+
  xlim(0, 10)+
  geom_jitter(aes(x=Score,y=Nps_agrupado,color=Segmento))+
  ggtitle('Comparacion NPS de Tiendas por Mes')+
  theme_classic()


#RESPUESTA
# el cor.tes nos indica que existe una correlacion entre nps y segmento, pero es muy baja de tan 
#sólo un 5%


#Que sucede si realizamos un promedio de NPS por cada segmentos para cada tienda?
#los segmentos puntúan muy diferente a cada tienda? Observamos algun patron?


tabla1<-ventas2020
tabla2<-Calculo_RFM2 %>% 
  select(id_member,ScoreRFM,Segmento)

promedio_NPS_Tienda_Segmento<-merge(tabla1,tabla2)

promedio_NPS_Tienda_Segmento<-promedio_NPS_Tienda_Segmento %>% 
  select(store,nps,ScoreRFM,Segmento) %>% 
  group_by(store,ScoreRFM,Segmento) %>% 
  summarise(Media_NPS=mean(nps),
            nps_real=nps(nps))

#RESPUESTA:
#al realizar un promedio nps por tienda y segmento se pierde la puntuacion nps inicial obtenida con la
#formula NPS original, ya que los promedio nos indican que la mayoria de los segmentos tienen una posicion
#neutral para con cada tienda, la puntuacion es 7,9 en promedio similar en todas las tiendas , lo que no se refleja con la formula nps en donde cada tienda tiene aprox. 
# un 15% de NPS.


#Que sucede si correlacionamos frecuencia de compra de los 172 ids con el NPS? 
#Los consumidores que tienen mayor frecuencia de compra puntúan mas y mejor?

tabla3<-Calculo_RFM2 %>% 
  select(id_member,ScoreRFM,Segmento,Frequency)
tabla4<-Nps_agrupado_por_segmento %>% 
  select(id_member,Nps_agrupado)

Frecuencia_NPS<-merge(tabla3,tabla4)
str(Frecuencia_NPS)

plot(Frecuencia_NPS)

#GRAFICO CORRELACION
ggplot(Frecuencia_NPS)+
  geom_point(aes(x=Frequency,y=Nps_agrupado,color=Segmento))+
  xlim(30, 80)+
  ggtitle('Frecuencia de Compra y NPS')+
  geom_smooth(aes(x=Frequency,y=Nps_agrupado),method = "lm")+
  labs(x = "Frecuencia Compra", y = "NPS")+
  theme_classic()
cor.test(Frecuencia_NPS$Frequency,Frecuencia_NPS$Nps_agrupado)
cor(Frecuencia_NPS$Frequency,Frecuencia_NPS$Nps_agrupado)

#Se puede apreciar que extiste una correlacion negativa entre ambas variables, por lo tanto 
#lo compradores con mayor frecuencia no estan puntuando mejor.

#En líneas generales luego del análisis exploratorio, ¿podriamos identificar tiendas que sobresalen
#por una buena o una mala performance en terminos de NPS?
#REOUESTA:
# SI, podemos identificar tiendas que sobresalen en base a su NPS como lo son las tienda 4 y 5
# las cuales presentan un mayor NPS para nuestros segmentos en general y la de "peor nps" es la tienda 2,
#pero con un 13% lo cual es bueno a nivel de resutlado NPS.

#Pueden utilizar los dataset NPS_T2.csv y NPS_T3.csv para seguir practicando
#Y realizando cruces de informacion


