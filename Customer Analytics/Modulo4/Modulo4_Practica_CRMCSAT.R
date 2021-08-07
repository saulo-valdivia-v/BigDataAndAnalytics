#MÓDULO IV - SATISFACCIÓN DEL CONSUMIDOR
#En este ejercicio estaremos trabajando con data típica que uno puede extraer del modulo de Support Service
#de un CRM sobre los problemas que se reportan con el producto o servicio
#Y contiene una encuesta de satisfaccion tanto para el producto como para el servicio brindado por el equipo de custome support

#Para completar el ejercicio deberan cargar las siguientes librerias: tidyverse, corrplot, psych


#PISTA: Las librerias de corrplot y psych fueron utilizadas en el ejercicio de Percepcion de Marca. 
#Pueden revisar ese script como referencia para esta tarea


#PASO 1
#Cargamos el dataset "data_CRM.csv" eliminando columna 1 que es innecesaria
#Inspecciones en dataset con summary, describe y head para comprender la información que contiene, entender missing values en las columnas
#Realicen un plot para entender la distribución de las quejas a lo largo del período, 
#selecciondo el tipo de gráfico más óptimo para representar la data



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
#De esta forma el dataset nuevo debe contener las siguientes columnas: complaint_reason, num_casos, pend_calls, 
#avg_time_to_resolution, n_replacements, Prod_CSAT, Serv_CSAT



#PASO 3
#Seleccionar un plot idoneo para poder realizar una comparativa de C-SATs para cada problema técnico
#Justificar la selección de dicho plot brevemente



#PASO 4
#Realizar una correlación entre las variables numéricas y analizar si existen correlaciones fuertes entre
#alguna de las variables presentadas. 
#las funciones de correlación poseen un argumento llamado use que permite excluir los NA para que el computo sea
#posible. Para ello incluyan como argumento use = "complete.obs" ya que por default es use = "everything" 
#¿La columna de Serv_CSAT muestra correlaciones con alguna otra columna?


#Inspeccionen la funcion cor.test para entender su funcionamiento y apliquenla sobre aquellas correlaciones
#que ustedes opinaron anteriormente que tienen correlación con la columna de Serv_CSAT para verificar si su hipotesis es correcta
#IMPORTANTE: pueden explorar los diferentes métodos, pero el que utilizamos de forma genérica es pearson
##a su vez es importante que comprendan y utilicen el argumento exact con lógica FALSE


#Por último utilicen la función corrplot.mixed() para realizar el plot de todas las correlaciones juntas
#Intenten utilizar algunas de las opciones que presenta para embellecer el gráfico (colores, formas, tamaños, etc)
#La forma de aplicación sería corrplot.mixed(corr = (correlacion que quieren hacer con sus argumentos incluido use = "complete.obs")) 
#y el resto de argumentos que quieran incluir



#PASO 5
#Repetir el paso 4 pero enfocando el analisis en la columna Prod_CSAT en vez de Serv_CSAT: realicen hipotesis sobre correlaciones,
#apliquen cor.test para validarlas y corrplot.mixed() para representarlo.





