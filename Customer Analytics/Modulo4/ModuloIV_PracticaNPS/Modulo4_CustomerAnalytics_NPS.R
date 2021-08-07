#Practica Matricas de Satisfaccion del Consumidor - NPS
#NPS - Net Promoter Score - Score promedio de recomendacion
#En R existe una libreria llamada NPS para calcularlo automaticamente
#Deberán trabajar el calculo NPS sobre un dataset y analizar correlaciones con cluster de RFM
library(tidyverse)

#PASO 1: Deben cargar las librerias tidyverse, lubridate, caret, corrplot y NPS

#PASO 2: Generen un dataset llamado ventas2020 cargando el archivo "NPS_T1.csv" eliminando primera columna
#Eliminen aquellos registros que figuren con un NPS NA utilizando filter
#Modifiquen la columna nps a columna numerica utilizando mutate y as.numeric
#Ayuda: al utilizar select si escriben select(-1) entonces se seleccionan todas las columnas excepto la primera
ventas2020 <- read.csv('NPS_T1.csv')# %>%
  
  
#Calculen el NPS agrupado por cada tienda, utilizando la función nps del paquete NPS dentro de la funcion summarise
#¿cual es la tienda con mejor performance?
nps_tiendas <- ventas2020 %>%
  group_by() %>%
  summarise()


#Realizaremos un analisis entre los meses del año y el NPS para cada tienda
#para ello deben crear una columna mes en el dataframe de ventas2020 
#y agrupar tanto por mes como por store y calcular el nps en un nuevo data frame


#visualizamos la comparación de NPS de cada tienda para cada mes
#utilicen gráfico de scatter (geom_point) y den color a los puntos con
#columna store


#Desarrollar el cálculo de RFM para cada comprador en otro dataframe 
#sin olvidar de modificar la columna de  fecha para que R la reconozca como tal utilizando as.Date
#Generen 5 clusters a traves de kmean para identificar segmentos de consumidores
#pueden utilizar de referencia el script visto en el modulo II



#Calcular nps agrupando por segmento de consumidores en un nuevo data frame



#Ahora realicen una correlacion entre NPS y  los segmentos de consumidores de RFM
#Existen mayor correlacion con aquellos consumidores que gastan mas dinero o menos dinero?


#Que sucede si realizamos un promedio de NPS por cada segmentos para cada tienda?
#los segmentos puntúan muy diferente a cada tienda? Observamos algun patron?


#Que sucede si correlacionamos frecuencia de compra de los 172 ids con el NPS? 
#Los consumidores que tienen mayor frecuencia de compra puntúan mas y mejor?


#En líneas generales luego del análisis exploratorio, ¿podriamos identificar tiendas que sobresalen
#por una buena o una mala performance en terminos de NPS?




#Pueden utilizar los dataset NPS_T2.csv y NPS_T3.csv para seguir practicando
#Y realizando cruces de informacion


