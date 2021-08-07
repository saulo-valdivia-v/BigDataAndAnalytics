#Analisis de Sentimiento con la librería Syuzhet

#Existen varias formas de calcular el sentimiento de las palabras.
#Si bien no existe una solución automática que tenga buena precisión en idioma español, utilizaremos un
#paquete bastante popular, que analiza las palabras y es capaz de asignar sentimiento de acuerdo a 4 métodos:
# nrc, bing, afinn y standford
#Vamos a revisar las diferencias de cada método

#Documentación y ejemplos: https://cran.r-project.org/web/packages/syuzhet/vignettes/syuzhet-vignette.html

#Instalamos la librería
#install.packages("syuzhet")

#Llamamos la librería para poder acceder a sus funciones
library(readr)
library(syuzhet)

#Carga de datasets
Tokens_TripAdvisor4 <- read_csv("datasets/Tokens_TripAdvisor4.csv")
Tokens_TripAdvisor4 <- Tokens_TripAdvisor4 %>% select(palabra, n)

### CLASIFICACIÓN SENTIMIENTO CON MÉTODO AFINN
#Utilizaremos el dataset creado con las reviews de tripadvisor, para que no tarde mucho utilizando Tokens_TripAdvisor4
#Primero debemos convertir el dataframe en un vector utilizando la función unlist
Sentiment_TripAdvisor <- unlist(Tokens_TripAdvisor4)
Sentiment_Afinn <- get_sentiment(char_v = Sentiment_TripAdvisor, method = "afinn", language = "english")

#creamos un dataframe para poder ver los resultados con cbind
Sentiment_TripAdvisor_Afinn <- cbind(Sentiment_TripAdvisor, Sentiment_Afinn)

head(Sentiment_TripAdvisor_Afinn, n=10)
#como resultado vemos que existe un rango desde -5 a 5, todo lo que esté cercano a -5 es negativo, a 0 es neutral y 5 es positivo


### CLASIFICACIÓN SENTIMIENTO CON MÉTODO NRC
Sentiment_NRC <- get_sentiment(char_v = Sentiment_TripAdvisor, method = "nrc", language = "english")
Sentiment_TripAdvisor_NRC <- cbind(Sentiment_TripAdvisor, Sentiment_NRC)

### CLASIFICACIÓN SENTIMIENTO CON MÉTODO BING
Sentiment_Bing <- get_sentiment(char_v = Sentiment_TripAdvisor, method = "bing", language = "english")
Sentiment_TripAdvisor_Bing <- cbind(Sentiment_TripAdvisor, Sentiment_Bing)

### El método standford requiere la instalación de una libería adicional, no lo utilizaremos en este ejemplo


#A su vez, Syuzhet tiene una función específica de NRC para visibilizar las emociones y sentimiento
#Analiza 8 "emociones": anger, anticipation, disgust, fear, joy, sadness, surprise y trust
#Así como el puntaje positivo o negativo.
Analisis_NRC <- get_nrc_sentiment(char_v = Sentiment_TripAdvisor, language = "english")
#a diferencia de la función get_sentiment, get_nrc_sentiment me entrega un data frame con el resultado de cada palabra
#pero no tengo las palabras disponibles, por lo que para que tenga sentido igualmente necesito juntarno con el vector
Analisis_NRC_df <- cbind(Sentiment_TripAdvisor, Analisis_NRC)

#La función get_nrc_sentiment es la única función del paquete que permite realizar análisis sobre textos en español
#por eso es la única funcióm que emplearemos de este paquete.s

##### FIN. 

