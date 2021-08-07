#MÓDULO IV - SATISFACCIÓN DEL CONSUMIDOR
#En este ejercicio estaremos trabajando con data típica que uno puede extraer del modulo de Support Service
#de un CRM sobre los problemas que se reportan con el producto o servicio
#Y contiene una encuesta de satisfaccion tanto para el producto como para el servicio brindado por el equipo de custome support

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

ggplot(data_CRM, aes(x=create_date)) + geom_histogram()

ggplot(data_CRM, aes(x=create_date)) + 
  geom_histogram(aes(y=..density..), colour="black", fill="white")+
  geom_density(alpha=.2, fill="#FF6666") 


#PASO 2
#El dataset presenta todos los casos de los usuarios que han contactado con Customer Support en el período enero-abril 2020
#Pero nos interesa hacer el análisis sobre complaint_reason, por lo cual es necesario crear un nuevo dataset, 
#agrupar los datos por complaint_reason y realizar las siguientes operaciones para las columnas relevantes: 
#generar una columna que cuente la cantidad de llamadas para cada tipo de complaint_reason llamada "num_casos"
complaint_reason <- data_CRM %>%
  group_by(complaint_reason) %>%
  summarise(num_casos = n())

#generar una columna que cuente la cantidad de llamadas pendientes para cada tipo de complaint_reason contando la cantidad de "y" llamada pend_calls
complaint_reason_pending <- data_CRM %>%
  group_by(complaint_reason) %>%
  summarise(num_casos = n(),
            pend_calls = sum(pending_call == 'y'))

#calcular el promedio de time_to_resolution_min para cada tipo de complaint_reason en una columna nueva llamada avg_time_to_resolution
complaint_reason_pending <- data_CRM %>%
  group_by(complaint_reason) %>%
  summarise(num_casos = n(),
            pend_calls = sum(pending_call == 'y'),
            avg_time_to_resolution = mean(time_to_resolution_min))

#generar una columna que cuente la cantidad de need_replace para cada tipo de complaint_reason contando la cantidad de "TRUE" llamada n_replacements
complaint_reason_pending <- data_CRM %>%
  group_by(complaint_reason) %>%
  summarise(num_casos = n(),
            pend_calls = sum(pending_call == 'y'),
            avg_time_to_resolution = mean(time_to_resolution_min),
            n_replacements = sum(need_replace == TRUE))


#generar una nueva columna que calcule el Prod_CSAT para cada tipo de complaint_reason en una columna nueva llamada Prod_CSAT
complaint_reason_group <- data_CRM %>%
  group_by(complaint_reason) %>%
  summarise(num_casos = n(),
            pend_calls = sum(pending_call == 'y'),
            avg_time_to_resolution = mean(time_to_resolution_min),
            n_replacements = sum(need_replace == TRUE),
            total_pcsat = (sum(pending_call == 'n' & ProdCSAT == 4, na.rm=TRUE)) +
                          (sum(pending_call == 'n' & ProdCSAT == 5, na.rm=TRUE)),
            Prod_CSAT = (total_pcsat/(num_casos - pend_calls))* 100)

#generar una nueva columna que calcule el Serv_CSAT para cada tipo de complaint_reason en una columna nueva llamada Serv_CSAT
complaint_reason_group <- data_CRM %>%
  group_by(case_record_type, complaint_reason) %>%
  summarise(num_casos = n(),
            pend_calls = sum(pending_call == 'y'),
            avg_time_to_resolution = mean(time_to_resolution_min),
            n_replacements = sum(need_replace == TRUE),
            total_pcsat = (sum(pending_call == 'n' & ProdCSAT == 4, na.rm=TRUE)) +
              (sum(pending_call == 'n' & ProdCSAT == 5, na.rm=TRUE)),
            Prod_CSAT = (total_pcsat/(num_casos - pend_calls))* 100,
            total_scsat = (sum(pending_call == 'n' & ServCSAT == 4, na.rm=TRUE)) +
              (sum(pending_call == 'n' & ServCSAT == 5, na.rm=TRUE)),
            Serv_CSAT = (total_scsat/(num_casos - pend_calls))* 100)

#De esta forma el dataset nuevo debe contener las siguientes columnas: complaint_reason, num_casos, pend_calls, 
#avg_time_to_resolution, n_replacements, Prod_CSAT, Serv_CSAT

complaint_reason_data <- complaint_reason_group %>%
  select(case_record_type,
         complaint_reason, 
         num_casos, 
         pend_calls, 
         avg_time_to_resolution, 
         n_replacements,
         Prod_CSAT,
         Serv_CSAT)

#PASO 3
#Seleccionar un plot idoneo para poder realizar una comparativa de C-SATs para cada problema técnico
#Justificar la selección de dicho plot brevemente

ggplot(data=complaint_reason_data, aes(x=case_record_type, y=Prod_CSAT, fill=complaint_reason)) +
  geom_bar(stat="identity", position=position_dodge()) +
  #geom_text(aes(label=Prod_CSAT), vjust=1.6, color="white", size=3.5) +
  theme_minimal()

ggplot(data=complaint_reason_data, aes(x=case_record_type, y=Serv_CSAT, fill=complaint_reason)) +
  geom_bar(stat="identity", position=position_dodge()) +
  #geom_text(aes(label=Prod_CSAT), vjust=1.6, color="white", size=3.5) +
  theme_minimal()

ggplot(complaint_reason_data, aes(x="", y=Prod_CSAT, fill=complaint_reason)) +
  geom_bar(stat="identity", width=1, color="white") +
  coord_polar("y", start=0) +
  theme_void()

#PASO 4
#Realizar una correlación entre las variables numéricas y analizar si existen correlaciones fuertes entre
#alguna de las variables presentadas. 
#las funciones de correlación poseen un argumento llamado use que permite excluir los NA para que el computo sea
#posible. Para ello incluyan como argumento use = "complete.obs" ya que por default es use = "everything" 
#¿La columna de Serv_CSAT muestra correlaciones con alguna otra columna?
data_cor <- data_CRM %>%
   filter(pending_call == 'y') %>%
   select(cust_id, 
          age, 
          time_to_resolution_min, 
          ProdCSAT,
          ServCSAT)

M <- cor(data_cor, use = "complete.obs")

col <- colorRampPalette(c("#BB4444", "#EE9988", "#FFFFFF", "#77AADD", "#4477AA"))
corrplot(M, method="color", col=col(200),  
         type="upper", order="hclust", 
         addCoef.col = "black", # Add coefficient of correlation
         tl.col="black", tl.srt=45, #Text label color and rotation
         # hide correlation coefficient on the principal diagonal
         diag=FALSE)

#Inspeccionen la funcion cor.test para entender su funcionamiento y apliquenla sobre aquellas correlaciones
#que ustedes opinaron anteriormente que tienen correlación con la columna de Serv_CSAT para verificar si su hipotesis es correcta
#IMPORTANTE: pueden explorar los diferentes métodos, pero el que utilizamos de forma genérica es pearson
##a su vez es importante que comprendan y utilicen el argumento exact con lógica FALSE
res <- cor.test(data_cor$ServCSAT, data_cor$age, method = "pearson", exact = FALSE)
res

res <- cor.test(data_cor$ServCSAT, data_cor$ProdCSAT, method = "pearson", exact = FALSE)
res

#Por último utilicen la función corrplot.mixed() para realizar el plot de todas las correlaciones juntas
#Intenten utilizar algunas de las opciones que presenta para embellecer el gráfico (colores, formas, tamaños, etc)
#La forma de aplicación sería corrplot.mixed(corr = (correlacion que quieren hacer con sus argumentos incluido use = "complete.obs")) 
#y el resto de argumentos que quieran incluir

corrplot.mixed(M)
corrplot.mixed(M, lower.col = "black", number.cex = .7)


#PASO 5
#Repetir el paso 4 pero enfocando el analisis en la columna Prod_CSAT en vez de Serv_CSAT: realicen hipotesis sobre correlaciones,
#apliquen cor.test para validarlas y corrplot.mixed() para representarlo.





