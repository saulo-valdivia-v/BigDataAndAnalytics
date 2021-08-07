#-----------> AUTOR: ALEJANDRO ESTEBAN LOZA (201025930)



#MÓDULO IV - SATISFACCIÓN DEL CONSUMIDOR
#En este ejercicio estaremos trabajando con data típica que uno puede extraer del modulo de Support Service
#de un CRM sobre los problemas que se reportan con el producto o servicio
#Y contiene una encuesta de satisfaccion tanto para el producto como para el servicio brindado por el equipo de custome support

#Para completar el ejercicio deberan cargar las siguientes librerias: tidyverse, corrplot, psych

library (tidyverse)
library(corrplot)
library(psych)
library(dplyr)
library(DescTools)

#PISTA: Las librerias de corrplot y psych fueron utilizadas en el ejercicio de Percepcion de Marca. 
#Pueden revisar ese script como referencia para esta tarea

#------------------------------------------------------------------------------------------------------------------#

#PASO 1
#--> Cargamos el dataset "data_CRM.csv" eliminando columna 1 que es innecesaria
#--> Inspecciones en dataset con summary, describe y head para comprender la información que contiene, entender missing values en las columnas
#--> Realicen un plot para entender la distribución de las quejas a lo largo del período, 
#--> selecciondo el tipo de gráfico más óptimo para representar la data

#*   Caargamos el dataset y eliminamos la primera columna
CRM <- read.csv('data_CRM.csv', header = T) %>%
  select(-1)

#*   Sacamos descriptivos sobre las tablas
summary(CRM)
describe(CRM)
head(CRM)

#*   Estudiamos la variable 'create_date' para ver la frecuencia de quejas por dia durante nuestro periodo
table(CRM$create_date)
#*   Genero una tabla que agrupe todas las fechas registradas junto al total de quejas recibidas por dia
Distribucion_Quejas_Dia <- CRM[,c(4,8)]
Distribucion_Quejas_Dia$Queja <- 1
Distribucion_Quejas_Dia <- Distribucion_Quejas_Dia %>%
  group_by(create_date) %>%
  summarise(sum(Queja))
#*   Convertimos la fecha al forma 'date'
dias <- as.Date(Distribucion_Quejas_Dia$create_date)
#*   Graficamos la dsitrbucion del total de quejas por dia durante los meses de Enero - Abril
ggplot(Distribucion_Quejas_Dia, aes(x = dias, y = `sum(Queja)`)) +
  geom_line(group = 1) +
  labs(title = 'Numero de quejas distribuidas por dias',
       y = 'Numero de Quejas',
       x = 'Distribucion de Dias') + 
  theme(plot.title = element_text(hjust=0.5)) +
  theme(legend.position='bottom',axis.text.x = element_text(angle = 90)) + 
  scale_y_continuous(limits = c(80,140), breaks = seq(80,140,10)) +
  theme(axis.text.x = element_text(angle=45, hjust = 1)) +
  stat_smooth(color = "#FC4E07", fill = "#FC4E07", method = "loess")
  

#--------------------------------------------------------------------------------------------------------------------#
#------------------------------------------------------------------------------------------------------------------#


#PASO 2
#--> El dataset presenta todos los casos de los usuarios que han contactado con Customer Support en el período enero-abril 2020
#--> Pero nos interesa hacer el análisis sobre complaint_reason, por lo cual es necesario crear un nuevo dataset, 
#--> agrupar los datos por complaint_reason y realizar las siguientes operaciones para las columnas relevantes: 
#* GENERAR UNA COLUMNA QUE CUENTE LA CANTIDAD DE LLAMADAS PARA CADA TIPO DE COMPLAINT_REASON LLAMADA 'NUM CASOS'
#* GENERAR UNA COLUMNA QUE CUENTE LA CANTIDAD DE LLAMADAS PENDIENTES PARA CADA TIPO DE COMPLAINT_REASON CONTANDO LA CANTIDAD DE 'Y' LLAMADA PEND-CALLS
#* CALCULAR EL PROMEDIO DE TIME_TO_RESOLUTION_MIN PARA CADA TIPO DE COMPLAINT_REASON_ EN UNA COLUMNA NUEVA LLAMADA AVG_TIME_TO_RESOLUTION
#* GENERAR UNA COLUMNA QUE CUENTE LA CANTIDAD DE NEED_RELPACE PARA CADA TIPO DE COMPLAINT_REASON CONTANDO LA CANTIDAD DE 'TRUE' LLAMADA N_REPLACEMENTS
#* GENERAR UNA NUEVA COLUMNA QUE CALCULE EL 'PROD_CAST' PARA CADA TIPO DE 'COMPLAINT_REASON' EN UNA COLUMNA NUEVA LLAMADA 'PROD_CSAT'
#* GENERAR UNA NUEVA COLUMNA QUE CALCULE EL 'SERV_CSAT' PARA CADA TIPO DE 'COMPLAINT_REASON' EN UNA COLUMNA NUEVA LLAMADA 'SERV_CSAT'



#*   Me genero un dataframe con las columnas que nos interesan:
#*   A partir del uso de 'pipes' encadenamos una serie de solicitudes sobre la tabla de dato general 'CRM', de tal manera que todo
#*   lo solicitado se estructure en una nueva tabla donde todo quede agrupado en funcion de los diferentes tipos de queja
#*   recibidas. Con respecto a los datos de las columnas relativas a CSAT, calculamos el dato porcentual de todas las calificaciones
#*   que son mayores o iguales a 4, entre el total de las calificaciones.

DF_CRM <- data.frame(CRM %>%
                       group_by(complaint_reason) %>%
                       summarise(num_casos = length(complaint_reason),
                                 pend_calls = length(pending_call[pending_call == "y"]),
                                 avg_time_to_resolution = mean(time_to_resolution_min),
                                 n_replacements = length(need_replace[need_replace == TRUE]),
                                 Prod_CSAT = (length(ProdCSAT[!is.na(ProdCSAT) & ProdCSAT >= 4])/length(ProdCSAT[!is.na(ProdCSAT)]))*100,
                                 Serv_CSAT = (length(ServCSAT[!is.na(ServCSAT) & ServCSAT >= 4])/length(ServCSAT[!is.na(ServCSAT)]))*100))



#--------------------------------------------------------------------------------------------------------------------#
#--------------------------------------------------------------------------------------------------------------------#

#PASO 3
#--> Seleccionar un plot idoneo para poder realizar una comparativa de C-SATs para cada problema técnico
#--> Justificar la selección de dicho plot brevemente


#*    Factorizamos nuestra variable 'Complaint_Reason' para poder graficar sobre ella con mas facilidad
complaint_reason <- as.factor(DF_CRM$complaint_reason)
#*    A continuacion graficaremos las variables tanto de forma individual como conjuntamente
#*    Utilizamos un plot donde se muestran los diferentes niveles de porcentaje CSAT realizada por los consumidores
#*    por cada tipo de queja   

#*    Generamos un grafico para visualizar de forma individual la frecuencia de 'Prod_CSAT' por quejas realizadas
ggplot(data = DF_CRM, aes(x = complaint_reason, y = Prod_CSAT, color = complaint_reason)) + 
  geom_point() + 
  labs( x = 'Complaint Reason',
        y = 'Prod_CSAT',
        title = 'Frecuencia de Prod_CSAT por tipo de queja') +
  theme(plot.title = element_text(hjust=0.5)) +
  theme(legend.position='bottom',axis.text.x = element_text(angle = 90)) +
  theme(legend.title = element_text(size = 7),
        legend.text = element_text(size = 7)) +
  theme(axis.text=element_text(size=7),
        axis.title=element_text(size=10,face="bold"))
#*    Generamos un grafico para visualizar de forma individual la frecuencia de 'Serv_CSAT' por quejas realizadas
ggplot(data = DF_CRM, aes(x = complaint_reason, y = Serv_CSAT, color = complaint_reason)) + 
  geom_point() + 
  labs( x = 'Complaint Reason',
        y = 'Serv_CSAT',
        title = 'Frecuencia de Serv_CSAT por tipo de queja') +
  theme(plot.title = element_text(hjust=0.5)) +
  theme(legend.position='bottom',axis.text.x = element_text(angle = 90)) +
  theme(legend.title = element_text(size = 7),
        legend.text = element_text(size = 7)) +
  theme(axis.text=element_text(size=7),
        axis.title=element_text(size=10,face="bold"))
#*    Generamos un grafico mezclando ambas variables y asi visualizar las CSAT para cada problema tecnico
ggplot(data = DF_CRM, aes(x = Prod_CSAT, y = Serv_CSAT)) + 
         geom_point(aes(color = complaint_reason)) +
  labs(title = 'Distribucion de Prod_CSAT y Serv_CSAT por tipo de problema t�cnico') +
  theme(plot.title = element_text(hjust=0.5)) +
  theme(legend.title = element_text(color = 'navyblue', size = 12),
        legend.text = element_text(size = 10)) + 
  theme(legend.background = element_rect(fill = "darkgray")) +
  scale_x_continuous(limits = c(0,100), breaks = seq(0,100,10)) + 
  scale_y_continuous(limits = c(0,100), breaks = seq(0,100,10))

 
#--------------------------------------------------------------------------------------------------------------------#
#--------------------------------------------------------------------------------------------------------------------#


#PASO 4
#--> Realizar una correlación entre las variables numéricas y analizar si existen correlaciones fuertes entre
#--> alguna de las variables presentadas. 
#--> las funciones de correlación poseen un argumento llamado use que permite excluir los NA para que el computo sea
#--> posible. Para ello incluyan como argumento use = "complete.obs" ya que por default es use = "everything" 




#*    Comprobamos la tipologia de cada una de nuestras variables
str(DF_CRM)
#*    Nos guardamos en un objeto todas las columnas de caracter numero, las cuales podemos trabajar la correlacion tipo
datos_numericos <- DF_CRM[,2:7]
#*    Creamos una Tabla con las correlaciones entre todos los datos de las columnas creadas
Tabla_correlaciones <- round(cor(datos_numericos,use = 'complete.obs'), digits = 2); Tabla_correlaciones
#*    Generamos un grafico para visualziar el tipo de correlacion entre las variables, ademas de visualizarlo anteriormente en una tabla
corrplot(cor(datos_numericos,use = 'complete.obs'), 
         type="upper", 
         order = 'hclust', 
         tl.col="black", 
         addCoef.col = 'black',
         tl.srt=60)

#*    El caso de mayor correlacion es la relacion de variables entre Numeros de casos y Llamadas Pendientes,
#*    con un nivel de correlacion positiva de 1. Una correlacion tan alta implica una relacion totalmente 
#*    directa entre las variables relacionadas. A un mayor numero de casos que resolver tenemos una mayor
#*    probabilidad de que quede un mayor numero de llamadas por resolver.
#*    Tambien observamos niveles de correlacion positiva cercanos al 1. Concretamente en las relaciones entre:
#*    - Tiempo de resolucion de la llamada y Prod_CSAT con un 0.81
#*    - Tiempo de resolucion de la llamada y Serv_CSAT con un 0.75
#*    En estos dos ultimos casos, la relacion que guardan las variables es que el tiempo de resolucion tiene
#*    cierta incidencia en la valoracion con la que el cliente puntua su experiencia tanto con el producto
#*    como con el servicio
#*    - Prod_CSAT y Serv_CSAT con un 0.83
#*    Finalmente, estas dos ultimas variables gozan tambien de una correlacion alta. Podemos confirmar que 
#*    la valoracion del producto suele tener una relacion directa con respecto a la valoracion que los consumidores
#*    otorgan al servicio prestado.


#--> �La columna de Serv_CSAT muestra correlaciones con alguna otra columna?


#*    Como hemos comentado anteriormente, la columna Serv_CSAT guarda una correlacion alta con las variables
#*    'Tiempo de resolucion de llamada' y 'Prod CSAT'. Una relacion proporcionalmente directa implica que ambas
#*    variables incidan en la valoracion del cliente a la hora de puntuar el servicio. El tiempo empleado en que se
#*    resuelva el problema del empleado, as� como la propia valoracion con la que califica su experiencia sobre 
#*    el producto, influyen en la calificacion del Serv_CSAT.


#--> Inspeccionen la funcion cor.test para entender su funcionamiento y apliquenla sobre aquellas correlaciones
#--> que ustedes opinaron anteriormente que tienen correlación con la columna de Serv_CSAT para verificar si su hipotesis es correcta
#--> IMPORTANTE: pueden explorar los diferentes métodos, pero el que utilizamos de forma genérica es pearson
#--> a su vez es importante que comprendan y utilicen el argumento exact con lógica FALSE



#*    Utilizamos el soporte de ayuda de R para comprender la utilidad de la funcion cor.test
?cor.test

#*    Como veremos en los casos de a continuacion, una vez apliquemos el test, ambos valores de p-value son inferiores
#*    al 0.05. Por lo que rechazamos la Hipotesis Nula. Cuando estudiamos la correlacion de Pearson, rechazar la hipotesis nula
#*    implica que existe correlacion entre las variables.

cor.test(DF_CRM$avg_time_to_resolution,DF_CRM$Serv_CSAT, method = "pearson")
#*    Aplicamos la funcion cor.test, la cual nos ofrece el dato de la correlacion entre las variables con las que hemos
#*    trabajado. Tal y como hemos comentado en el anterior apartado, el coeficiente de correlacion es de 0.7456617. Por
#*    lo que, ante un nivel de correlacion positiva de este grado, podemos concluir que existe cierto grado de incidencia
#*    de la variable 'Tiempo de resolucion de la llamada' sobre la valoracion del consumidor hacia el Servicio Prestado.
cor.test(DF_CRM$Prod_CSAT,DF_CRM$Serv_CSAT,method = "pearson")
#*    Repetimos test de correlacion con las variables Prod_CSAT y Serv_CSAT, donde se nos muestra un grado de correlacion
#*    del 0.8294235. Al igual que en el anterior caso, concluimos que existe una relacion proporicionalmente directa entre
#*    ambas variables.




#--> Por último utilicen la función corrplot.mixed() para realizar el plot de todas las correlaciones juntas
#--> Intenten utilizar algunas de las opciones que presenta para embellecer el gráfico (colores, formas, tamaños, etc)
#--> La forma de aplicación sería corrplot.mixed(corr = (correlacion que quieren hacer con sus argumentos incluido use = "complete.obs")) 
#--> y el resto de argumentos que quieran incluir


#*    Repetimos el proceso utilizado anteriormente para poder representar los datos de correlacion mediante la funcion corrplot.mixed()
datos_numericos <- DF_CRM[,2:7]
Tabla_correlaciones <- round(cor(datos_numericos,use = 'complete.obs'), digits = 2); Tabla_correlaciones
#*    Graficamos con la funcion corrplot.mixed
corrplot.mixed(Tabla_correlaciones, 
               tl.pos = "lt", 
               diag = "l",
               tl.col="black")


#-------------------------------------------------------------------------------------------------------------------#


#PASO 5
#Repetir el paso 4 pero enfocando el analisis en la columna Prod_CSAT en vez de Serv_CSAT: realicen hipotesis sobre correlaciones,
#apliquen cor.test para validarlas y corrplot.mixed() para representarlo.

#*     Repetimos el proceso elaborado anteriormente para la variable Serv_CSAT, pero ahora para la variable Prod_CSAT
cor.test(DF_CRM$avg_time_to_resolution, DF_CRM$Prod_CSAT, method = "pearson")
#*     La correlacion entre ambas variables es positiva y la podriamos considerar alta al tener un 0.8133575 de correlacion.
#*     Por lo que podriamos concluir que el tiempo de resolucion empleado en la llamada tiene incidencia en la valoracion
#*     que el consumidor da sobre el producto
#*     Observamos un p-valor bajo, por lo que rechazamos la Hipotesis Nula. La H0 implica que no existe correlacion, por lo
#*     que con el test de Pearson podemos confirmar que si existe relacion entre las variables.
cor.test(DF_CRM$Serv_CSAT, DF_CRM$Prod_CSAT, method = "pearson")
#*     La correlacion entre el Serv_CSAT y Prod_CSAT es positiva y alta. Por lo que existe relacion a la hora de conceder una 
#*     valoracion por parte de los consumidores hacia el producto, asi como hacia el servicio.
#*     Al igual que en el caso anterior, el p-valor esta por debajo del 0.05. Por lo que rechazamos la Hipotesis Nula
#*     y podemos confirmar que existe correlacion entre las variables.
corrplot.mixed(Tabla_correlaciones, 
               tl.pos = "lt", 
               diag = "l",
               tl.col="black")
