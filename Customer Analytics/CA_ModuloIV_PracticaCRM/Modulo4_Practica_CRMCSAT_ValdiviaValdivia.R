#MÓDULO IV - SATISFACCIÓN DEL CONSUMIDOR
#En este ejercicio estaremos trabajando con data típica que uno puede extraer del modulo de Support Service
#de un CRM sobre los problemas que se reportan con el producto o servicio
#Y contiene una encuesta de satisfaccion tanto para el producto como para el servicio brindado por el equipo de custome support

# AUTOR: Saulo Valdivia Valdivia

#Para completar el ejercicio deberan cargar las siguientes librerias: tidyverse, corrplot, psych
library(tidyverse)
library(corrplot)
library(psych)

#PISTA: Las librerias de corrplot y psych fueron utilizadas en el ejercicio de Percepcion de Marca. 
#Pueden revisar ese script como referencia para esta tarea


#PASO 1
#Cargamos el dataset "data_CRM.csv" eliminando columna 1 que es innecesaria
data_CRM <- read.csv('data_CRM.csv')
data_CRM$X <- NULL

#Inspecciones en dataset con summary, describe y head para comprender la información que contiene, entender missing values en las columnas
summary(data_CRM)
describeData(data_CRM,head=4,tail=4)

#Realicen un plot para entender la distribución de las quejas a lo largo del período, 
#selecciondo el tipo de gráfico más óptimo para representar la data
data_CRM$create_date <- as.Date(data_CRM$create_date, "%Y-%m-%d")

complains_by_date <- data_CRM %>%
  group_by(create_date) %>%
  summarise(total = n())

ggplot(complains_by_date, aes(x = create_date, y = total)) +
  geom_line(group = 1) +
  stat_smooth(method = "loess")

#PASO 2
#El dataset presenta todos los casos de los usuarios que han contactado con Customer Support en el período enero-abril 2020
#Pero nos interesa hacer el análisis sobre complaint_reason, por lo cual es necesario crear un nuevo dataset, 
#agrupar los datos por complaint_reason y realizar las siguientes operaciones para las columnas relevantes: 
#generar una columna que cuente la cantidad de llamadas para cada tipo de complaint_reason llamada "num_casos"
#generar una columna que cuente la cantidad de llamadas pendientes para cada tipo de complaint_reason contando la cantidad de "y" llamada pend_calls
#calcular el promedio de time_to_resolution_min para cada tipo de complaint_reason en una columna nueva llamada avg_time_to_resolution
#generar una columna que cuente la cantidad de need_replace para cada tipo de complaint_reason contando la cantidad de "TRUE" llamada n_replacements
#generar una nueva columna que calcule el Prod_CSAT para cada tipo de complaint_reason en una columna nueva llamada Prod_CSAT
#generar una nueva columna que calcule el Serv_CSAT para cada tipo de complaint_reason en una columna nueva llamada Serv_CSAT
complaint_reason_group <- data_CRM %>%
  group_by(complaint_reason) %>%
  summarise(num_casos = n(),
            pend_calls = sum(pending_call == 'y'),
            avg_time_to_resolution = mean(time_to_resolution_min),
            n_replacements = sum(need_replace == TRUE),
            Prod_CSAT = length(which(na.omit(ProdCSAT) >= 4))/length(na.omit(ProdCSAT)),
            Serv_CSAT = (length(which(na.omit(ServCSAT) >= 4))/length(na.omit(ServCSAT))*100))

#De esta forma el dataset nuevo debe contener las siguientes columnas: complaint_reason, num_casos, pend_calls, 
#avg_time_to_resolution, n_replacements, Prod_CSAT, Serv_CSAT
complaint_reason_data <- complaint_reason_group %>%
  select(complaint_reason, 
         num_casos, 
         pend_calls, 
         avg_time_to_resolution, 
         n_replacements,
         Prod_CSAT,
         Serv_CSAT)

#PASO 3
#Seleccionar un plot idoneo para poder realizar una comparativa de C-SATs para cada problema técnico
#Justificar la selección de dicho plot brevemente
complaint_reason <- as.factor(complaint_reason_data$complaint_reason)

ggplot(data=complaint_reason_data, aes(x=complaint_reason, y=Prod_CSAT, fill=complaint_reason)) +
  geom_bar(stat="identity") +
  theme(legend.position='bottom',axis.text.x = element_text(angle = 90))

ggplot(data=complaint_reason_data, aes(x=complaint_reason, y=Serv_CSAT, fill=complaint_reason)) +
  geom_bar(stat="identity") +
  theme(legend.position='bottom',axis.text.x = element_text(angle = 90))

#PASO 4
#Realizar una correlación entre las variables numéricas y analizar si existen correlaciones fuertes entre
#alguna de las variables presentadas. 
#las funciones de correlación poseen un argumento llamado use que permite excluir los NA para que el computo sea
#posible. Para ello incluyan como argumento use = "complete.obs" ya que por default es use = "everything" 
#¿La columna de Serv_CSAT muestra correlaciones con alguna otra columna?
# RESPUESTA:
# El grafico de correlacion muestra una muy elevada correlacion entre num_casos y pend_calls. Esto implica
# una relacion directa entre el numero de casos y las llamadas pendientes.
# Otras correlaciones importantes se pueden apreciar entre:   
#   avg_time_to_resolution y Prod_CSAT/Serv_CSAT. Que indica que existe una relacion elevada
#   entre el tiempo de resolucion y el puntaje del cliente al momento de evaluar la experiencia.
#   - Promedio de resolucion (avg_time_to_resolution) y Prod_CSAT con una correlacion de 0.81
#   - Promedio de resolucion (avg_time_to_resolution) y Serv_CSAT con una correlacion de 0.75
# Finalmente. La correlacion entre Prod_CSAT y Serv_CSAT es tambien elevada (0.83) lo que indica
# que el puntaje asociado al producto tiene incidencia al puntaje asignado al Servicio otorgado al cliente.

complaint_reason_data_cor <- complaint_reason_data[,2:7]

M <- cor(complaint_reason_data_cor, use = 'complete.obs')
col <- colorRampPalette(c("#BB4444", "#EE9988", "#FFFFFF", "#77AADD", "#4477AA"))
corrplot(M, method="color", col=col(200),  
         type="upper", order="hclust", 
         addCoef.col = "black",
         tl.col="black", tl.srt=45,
         diag=FALSE)

#Inspeccionen la funcion cor.test para entender su funcionamiento y apliquenla sobre aquellas correlaciones
#que ustedes opinaron anteriormente que tienen correlación con la columna de Serv_CSAT para verificar si su hipotesis es correcta
#IMPORTANTE: pueden explorar los diferentes métodos, pero el que utilizamos de forma genérica es pearson
##a su vez es importante que comprendan y utilicen el argumento exact con lógica FALSE
# RESPUESTA: 
#     - Aplicando el test de correlacion de Pearson entre avg_time_to_resolution y Serv_CSATServ_CSAT se puede ver
#       que el coeficiente de correlacion es de 0.7456617 y el p-value es muy pequeño. Lo que indica una correlacion positiva 
#       y una relacion entre el promedio de tiempo de resolucion y la valoracion otorgada al servicio por el cliente.
#     - Aplicando el mismo test para Prod_CSAT y Serv_CSAT se puede ver que el coeficiente de correlacion es de
#       0.8294235. Esto indica una relacion significativa entre estas dos variables como se explico anteriormente.
cor.test(complaint_reason_data_cor$avg_time_to_resolution, complaint_reason_data_cor$Serv_CSAT, method = "pearson", exact = FALSE)
cor.test(complaint_reason_data_cor$Prod_CSAT, complaint_reason_data_cor$Serv_CSAT, method = "pearson", exact = FALSE)


#Por último utilicen la función corrplot.mixed() para realizar el plot de todas las correlaciones juntas
#Intenten utilizar algunas de las opciones que presenta para embellecer el gráfico (colores, formas, tamaños, etc)
#La forma de aplicación sería corrplot.mixed(corr = (correlacion que quieren hacer con sus argumentos incluido use = "complete.obs")) 
#y el resto de argumentos que quieran incluir

corrplot.mixed(M, 
               tl.pos = "lt", 
               diag = "l",
               tl.col="black")


#PASO 5
#Repetir el paso 4 pero enfocando el analisis en la columna Prod_CSAT en vez de Serv_CSAT: realicen hipotesis sobre correlaciones,
#apliquen cor.test para validarlas y corrplot.mixed() para representarlo.
# RESPUESTA: Realizamos las graficas de correlacion y los tests anteriores para Prod_CSAT.
# Se puede apreciar los siguiente:
#     - Promedio de resolucion (avg_time_to_resolution) y Prod_CSAT con una correlacion de 0.8133575. Lo que indica 
#       una correlacion positiva y una relacion entre el promedio de tiempo de resolucion y la valoracion otorgada al servicio por el cliente.
#     - La correlacion entre Prod_CSAT y Serv_CSAT es tambien elevada (0.8294235) lo que indica
#       que el puntaje asociado al producto tiene incidencia en el puntaje asignado al Servicio otorgado al cliente.
col <- colorRampPalette(c("#BB4444", "#EE9988", "#FFFFFF", "#77AADD", "#4477AA"))
corrplot(M, method="color", col=col(200),  
         type="upper", order="hclust", 
         addCoef.col = "black",
         tl.col="black", tl.srt=45,
         diag=FALSE)

cor.test(complaint_reason_data_cor$avg_time_to_resolution, complaint_reason_data_cor$Prod_CSAT, method = "pearson", exact = FALSE)

cor.test(complaint_reason_data_cor$Prod_CSAT, complaint_reason_data_cor$Serv_CSAT, method = "pearson", exact = FALSE)

corrplot.mixed(M, 
               tl.pos = "lt", 
               diag = "l",
               tl.col="black")
