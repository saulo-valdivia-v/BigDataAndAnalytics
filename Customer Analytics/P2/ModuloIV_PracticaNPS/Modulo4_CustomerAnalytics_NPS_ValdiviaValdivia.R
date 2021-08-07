#Practica Matricas de Satisfaccion del Consumidor - NPS
#NPS - Net Promoter Score - Score promedio de recomendacion
#En R existe una libreria llamada NPS para calcularlo automaticamente
#Deberán trabajar el calculo NPS sobre un dataset y analizar correlaciones con cluster de RFM

# AUTOR: Saulo Valdivia Valdivia

#PASO 1: Deben cargar las librerias tidyverse, lubridate, caret, corrplot y NPS
library(tidyverse)
library(lubridate)
library(caret)
library(corrplot)
library(NPS)

#PASO 2: Generen un dataset llamado ventas2020 cargando el archivo "NPS_T1.csv" eliminando primera columna
ventas2020 <- read.csv('NPS_T1.csv')
ventas2020['X'] = NULL

#Eliminen aquellos registros que figuren con un NPS NA utilizando filter
ventas2020na <- ventas2020 %>% filter(!is.na(nps))

#Modifiquen la columna nps a columna numerica utilizando mutate y as.numeric
ventas2020na <- ventas2020na %>% mutate(NPSN = as.numeric(nps))

#Ayuda: al utilizar select si escriben select(-1) entonces se seleccionan todas las columnas excepto la primera

#Calculen el NPS agrupado por cada tienda, utilizando la función nps del paquete NPS dentro de la funcion summarise
#¿cual es la tienda con mejor performance?
# RESPUESTA: El NPS agrupado reporta que la tienda 4 y 5 tienen los mejores puntajes.

nps_tiendas <- ventas2020na %>%
  group_by(store) %>%
  summarise(nps = nps(NPSN))

arrange(nps_tiendas, desc(nps))

#Realizaremos un analisis entre los meses del año y el NPS para cada tienda
#para ello deben crear una columna mes en el dataframe de ventas2020 
ventas2020mes <- ventas2020na %>% mutate(fecha=as.Date(fecha_compra))
ventas2020mes <- ventas2020mes %>% mutate(mes=month(fecha))

#y agrupar tanto por mes como por store y calcular el nps en un nuevo data frame
nps_tiendas_mes <- ventas2020mes %>%
  group_by(store, mes) %>%
  summarise(nps = nps(NPSN))

#visualizamos la comparación de NPS de cada tienda para cada mes
#utilicen gráfico de scatter (geom_point) y den color a los puntos con
#columna store
ggplot(nps_tiendas_mes, aes(x=nps, y=mes, shape=store, color=store)) + geom_point()


#Desarrollar el cálculo de RFM para cada comprador en otro dataframe 
#sin olvidar de modificar la columna de  fecha para que R la reconozca como tal utilizando as.Date
#Generen 5 clusters a traves de kmean para identificar segmentos de consumidores
#pueden utilizar de referencia el script visto en el modulo II
Calculo_RFM <- ventas2020mes %>% 
  group_by(id_member) %>%
  summarise(Recency=as.numeric(as.Date(Sys.Date())-max(fecha)),
            Frequency=length(id_member), 
            Monetary_Value= sum(gasto))

set.seed(1234)
SegmentacionRFM <- kmeans(scale(Calculo_RFM[,2:4]), 5, nstart = 1) 

Calculo_RFM$ScoreRFM <- as.factor(SegmentacionRFM$cluster)

merged <- merge(ventas2020mes, Calculo_RFM, by = "id_member", all.x = TRUE, all.y = TRUE)

# Agrupando metricas de clustering para entender mejor los Scores
Calculo_RFM_Cluster<-merged %>% 
  select(ScoreRFM,Recency,Frequency,Monetary_Value) %>% 
  group_by(ScoreRFM) %>%
  summarise(mean(Recency),
            mean(Frequency),
            mean(Monetary_Value))

# Revisando las medias para las metricas del clustering concluimos lo siguiente para los Cluster.
# Cluster 1: Cliente Leal
# Cluster 2: Cliente Champion
# Cluster 3: Cliente Inactivo
# Cluster 4: Cliente Potencial
# Cluster 5: Cliente en Riesgo

#Calcular nps agrupando por segmento de consumidores en un nuevo data frame
nps_tiendas_rfm <- merged %>%
  group_by(id_member, ScoreRFM) %>%
  summarise(nps = nps(NPSN), gasto = sum(Monetary_Value))

#Ahora realicen una correlacion entre NPS y  los segmentos de consumidores de RFM
# COMENTARIO: La correlacion entre segmento(ScoreRFM) y nps es positiva pero muy baja (0.05 o 5%)
nps_tiendas_rfm$ScoreRFM <- as.numeric(nps_tiendas_rfm$ScoreRFM)
M <- cor(nps_tiendas_rfm)
corrplot(M, method = "circle")

cor.test(nps_tiendas_rfm$nps,nps_tiendas_rfm$ScoreRFM)

#Existen mayor correlacion con aquellos consumidores que gastan mas dinero o menos dinero?
# RESPUESTA: La correlacion es muy pequeña para los clientes que gastan mas dinero (Champions)
# y los que gastan menos dinero (Inactivos) cerca del -0.07 y 0.07 lo que nos indica que no hay
# una correlacion significativa.
cor(nps_tiendas_rfm$nps,nps_tiendas_rfm$ScoreRFM==2)
cor(nps_tiendas_rfm$nps,nps_tiendas_rfm$ScoreRFM==3)

#Que sucede si realizamos un promedio de NPS por cada segmentos para cada tienda?
#los segmentos puntúan muy diferente a cada tienda? Observamos algun patron?
# RESPUESTA: No se observan grandes diferencias en los promedios, lo que indica que la mayoria de los segmentos tienen una posicion
# neutral para cada tienda. Los puntajes para NPS por cada tienda son superiores al 14%

nps_tiendas_rfm_store <- merged %>%
  group_by(store, ScoreRFM) %>%
  summarise(npsm = nps(NPSN))

rfm_store_1 <- nps_tiendas_rfm_store %>% filter(store == 'tienda_1')
mean(rfm_store_1$npsm)

rfm_store_2 <- nps_tiendas_rfm_store %>% filter(store == 'tienda_2')
mean(rfm_store_2$npsm)

rfm_store_3 <- nps_tiendas_rfm_store %>% filter(store == 'tienda_3')
mean(rfm_store_3$npsm)

rfm_store_4 <- nps_tiendas_rfm_store %>% filter(store == 'tienda_4')
mean(rfm_store_4$npsm)

rfm_store_5 <- nps_tiendas_rfm_store %>% filter(store == 'tienda_5')
mean(rfm_store_5$npsm)

#Que sucede si correlacionamos frecuencia de compra de los 172 ids con el NPS? 
#Los consumidores que tienen mayor frecuencia de compra puntúan mas y mejor?
# RESPUESTA: EL grafico muestra una correlacion negativa entre ambas variables, por lo tanto 
# se puede decir que la frecuencia no influye significativamente en el puntaje NPS.

nps_tiendas_rfm_freq <- merged %>%
  group_by(id_member,ScoreRFM,Frequency) %>%
  summarise(npsm = nps(NPSN))


ggplot(nps_tiendas_rfm_freq)+
  geom_point(aes(x=Frequency,y=npsm,color=ScoreRFM))+
  xlim(30, 80)+
  ggtitle('Frecuencia de Compra y NPS')+
  geom_smooth(aes(x=Frequency,y=npsm),method = "lm")+
  labs(x = "Frecuencia Compra", y = "NPS")+
  theme_classic()
cor.test(nps_tiendas_rfm_freq$Frequency,nps_tiendas_rfm_freq$npsm)
cor(nps_tiendas_rfm_freq$Frequency,nps_tiendas_rfm_freq$npsm)

#En líneas generales luego del análisis exploratorio, ¿podriamos identificar tiendas que sobresalen
#por una buena o una mala performance en terminos de NPS?
# RESPUESTA: Comparando las medias calculadas anteriormente se identifican tiendas con un mejor performance.
# Las tiendas 4 y 5 son las que tienen puntajes de NPS mayores al resto de tiendas.
# Sin embargo, al tener un promedio superior al 14%, el resto de las tiendas tambien tiene un puntaje bueno
# ya que significa que los promotores son mayores que los detractores.

#Pueden utilizar los dataset NPS_T2.csv y NPS_T3.csv para seguir practicando
#Y realizando cruces de informacion


