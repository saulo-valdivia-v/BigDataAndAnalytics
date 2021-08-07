#Libreria RTWEET

#Es una librería que se conecta a la API de Twitter para poder descargar información
#Rtweet es una librería que tiene acceso a mucha información de Twitter ya que establece una conexión con su API
#Pero para utilizar todas sus funciones necesito tener credenciales de acceso a la API
#Sin credenciales puedo realizar sólo búsquedas limitadas para obtener tweets a partir de una keyword
#Para ello es necesario contar con una cuenta de Twitter y habilitar a Rtweet como app

#Documentación y ejemplos: https://github.com/ropensci/rtweet

#Instalamos la librería
#install.packages("rtweet")

#Llamamos la librería para poder acceder a sus funciones
library(rtweet)
library(dplyr)
library(tidytext)

#Al ejecutar la función search_tweets, en nuestro navegador se abrirá una ventana para loguear una cuenta de twitter
#y dar autorización a la app. Después comenzará la descarga de tweets.
#El límite máximo permitido es la descarga de hasta 18.000 registros, que es el número que vamos a utilizar
Tweets_Zara <- search_tweets(q="Zara", n = 18000, include_rts = FALSE, lang= "es")

#El limite de 18000 se reestablece luego de 15 minutos.

#La potencia de las librerías rtweet, stringr y tidytext juntos
Tweets_Zara_Token <- Tweets_Zara %>%
  mutate(text = str_to_lower(text)) %>%
  unnest_tokens(word, text, drop = FALSE, token = "tweets") %>%
  count(word) %>%
  arrange(desc(n))


ejemplo_extract <- str_extract(Tweets_Zara$text, pattern = "#[:alnum:]*") #extrae el primer hashtag presente en el tweet
ejemplo_extract_all <- str_extract_all(Tweets_Zara$text, pattern = "#[:alnum:]*") #extrae todos los hashtags presentes en todos los tweets

Tweets_Zara3 <- Tweets_Zara %>%
  filter(str_detect(text, pattern = "#[:alnum:]")) #extraemos todos los tweets que contengan hashtags


Hashtags_Zara <- Tweets_Zara_Token %>%
  filter(str_detect(word, pattern = "#[:alnum:]")) #extraemos la lista de hashtags y su frecuencia

Menciones_Zara4 <- Tweets_Zara_Token %>%
  filter(str_detect(word, pattern = "@[:alnum:]")) #extraemos todos los tweets donde usuarios son mencionados


##### FIN. 
